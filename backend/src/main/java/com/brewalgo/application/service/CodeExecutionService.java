package com.brewalgo.application.service;

import com.brewalgo.application.dto.ExecutionResult;
import com.brewalgo.domain.entity.TestCase;
import com.brewalgo.infrastructure.persistence.TestCaseRepository;
import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.command.CreateContainerResponse;
import com.github.dockerjava.api.command.WaitContainerResultCallback;
import com.github.dockerjava.api.model.Bind;
import com.github.dockerjava.api.model.HostConfig;
import com.github.dockerjava.api.model.Volume;
import com.github.dockerjava.core.DefaultDockerClientConfig;
import com.github.dockerjava.core.DockerClientBuilder;
import com.github.dockerjava.httpclient5.ApacheDockerHttpClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class CodeExecutionService {

    private final TestCaseRepository testCaseRepository;
    private static final long TIMEOUT_SECONDS = 5;
    private static final long MEMORY_LIMIT_MB = 256;

    private final DockerClient dockerClient = DockerClientBuilder.getInstance(
        DefaultDockerClientConfig.createDefaultConfigBuilder().build()
    ).withDockerHttpClient(
        new ApacheDockerHttpClient.Builder()
            .dockerHost(DefaultDockerClientConfig.createDefaultConfigBuilder().build().getDockerHost())
            .maxConnections(100)
            .connectionTimeout(Duration.ofSeconds(30))
            .responseTimeout(Duration.ofSeconds(45))
            .build()
    ).build();

    public ExecutionResult executeCode(Long problemId, String code, String language) {
        log.info("Executing code for problem {} in language {}", problemId, language);
        
        List<TestCase> testCases = testCaseRepository.findByProblemIdOrderByOrderIndex(problemId);
        
        if (testCases.isEmpty()) {
            return new ExecutionResult("ERROR", null, "No test cases found for this problem", 0L, 0L, 0, 0);
        }

        int passedTests = 0;
        long totalExecutionTime = 0;
        
        for (TestCase testCase : testCases) {
            try {
                ExecutionResult result = runSingleTestCase(code, language, testCase);
                
                if ("ACCEPTED".equals(result.getStatus())) {
                    passedTests++;
                }
                
                totalExecutionTime += result.getExecutionTimeMs();
                
                // If any test fails, return immediately
                if (!"ACCEPTED".equals(result.getStatus())) {
                    result.setPassedTestCases(passedTests);
                    result.setTotalTestCases(testCases.size());
                    return result;
                }
                
            } catch (Exception e) {
                log.error("Error executing test case", e);
                return new ExecutionResult("RUNTIME_ERROR", null, e.getMessage(), 0L, 0L, passedTests, testCases.size());
            }
        }
        
        // All tests passed
        return new ExecutionResult("ACCEPTED", "All test cases passed", null, totalExecutionTime, 0L, passedTests, testCases.size());
    }

    private ExecutionResult runSingleTestCase(String code, String language, TestCase testCase) throws Exception {
        String tempDir = System.getProperty("java.io.tmpdir");
        String executionId = UUID.randomUUID().toString();
        Path workDir = Path.of(tempDir, "brewalgo", executionId);
        Files.createDirectories(workDir);

        try {
            long startTime = System.currentTimeMillis();
            
            String imageName;
            String[] command;
            String fileName;

            if ("JAVA".equalsIgnoreCase(language)) {
                imageName = "brewalgo-java-executor:latest";
                fileName = "Solution.java";
                File codeFile = workDir.resolve(fileName).toFile();
                try (FileWriter writer = new FileWriter(codeFile)) {
                    writer.write(code);
                }
                command = new String[]{"sh", "-c", "javac Solution.java && echo '" + testCase.getInput() + "' | java Solution"};
            } else if ("PYTHON".equalsIgnoreCase(language)) {
                imageName = "brewalgo-python-executor:latest";
                fileName = "solution.py";
                File codeFile = workDir.resolve(fileName).toFile();
                try (FileWriter writer = new FileWriter(codeFile)) {
                    writer.write(code);
                }
                command = new String[]{"sh", "-c", "echo '" + testCase.getInput() + "' | python solution.py"};
            } else {
                return new ExecutionResult("ERROR", null, "Unsupported language: " + language, 0L, 0L, 0, 0);
            }

            // Create container
            CreateContainerResponse container = dockerClient.createContainerCmd(imageName)
                .withHostConfig(HostConfig.newHostConfig()
                    .withBinds(new Bind(workDir.toString(), new Volume("/app")))
                    .withMemory(MEMORY_LIMIT_MB * 1024 * 1024L)
                    .withCpuQuota(50000L))
                .withCmd(command)
                .withWorkingDir("/app")
                .exec();

            // Start container
            dockerClient.startContainerCmd(container.getId()).exec();

            // Wait for completion with timeout
            Integer statusCode = dockerClient.waitContainerCmd(container.getId())
                .exec(new WaitContainerResultCallback())
                .awaitStatusCode(TIMEOUT_SECONDS, java.util.concurrent.TimeUnit.SECONDS);

            long executionTime = System.currentTimeMillis() - startTime;

            // Get logs
            String output = dockerClient.logContainerCmd(container.getId())
                .withStdOut(true)
                .withStdErr(true)
                .exec(new com.github.dockerjava.api.async.ResultCallback.Adapter<>())
                .awaitCompletion()
                .toString().trim();

            // Cleanup container
            dockerClient.removeContainerCmd(container.getId()).withForce(true).exec();

            // Check result
            if (statusCode == null) {
                return new ExecutionResult("TIME_LIMIT_EXCEEDED", output, "Execution exceeded time limit", executionTime, 0L, 0, 0);
            }

            if (statusCode != 0) {
                return new ExecutionResult("RUNTIME_ERROR", output, "Non-zero exit code: " + statusCode, executionTime, 0L, 0, 0);
            }

            // Compare output
            if (output.trim().equals(testCase.getExpectedOutput().trim())) {
                return new ExecutionResult("ACCEPTED", output, null, executionTime, 0L, 0, 0);
            } else {
                return new ExecutionResult("WRONG_ANSWER", output, "Expected: " + testCase.getExpectedOutput(), executionTime, 0L, 0, 0);
            }

        } finally {
            // Cleanup temp directory
            Files.walk(workDir)
                .sorted((a, b) -> -a.compareTo(b))
                .forEach(path -> {
                    try {
                        Files.deleteIfExists(path);
                    } catch (Exception e) {
                        log.warn("Failed to delete: {}", path);
                    }
                });
        }
    }
}