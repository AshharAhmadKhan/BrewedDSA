package com.brewalgo.application.dto;

import com.brewalgo.domain.entity.Submission;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionDTO {
    
    private Long id;
    private Long userId;
    private String username;
    private Long problemId;
    private String problemTitle;
    private Long contestId;
    private String code;
    private String language;
    private String status;
    private Integer executionTimeMs;
    private Integer memoryUsedKb;
    private Integer scoreAwarded;
    private LocalDateTime submittedAt;
    private String errorMessage;
    
    public static SubmissionDTO fromEntity(Submission submission) {
        return SubmissionDTO.builder()
            .id(submission.getId())
            .userId(submission.getUser().getId())
            .username(submission.getUser().getUsername())
            .problemId(submission.getProblem().getId())
            .problemTitle(submission.getProblem().getTitle())
            .contestId(submission.getContest() != null ? submission.getContest().getId() : null)
            .code(submission.getCode())
            .language(submission.getLanguage().name())
            .status(submission.getStatus().name())
            .executionTimeMs(submission.getExecutionTimeMs())
            .memoryUsedKb(submission.getMemoryUsedKb())
            .scoreAwarded(submission.getScoreAwarded())
            .submittedAt(submission.getSubmittedAt())
            .errorMessage(submission.getErrorMessage())
            .build();
    }
}