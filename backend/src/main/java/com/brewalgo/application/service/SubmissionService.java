package com.brewalgo.application.service;

import com.brewalgo.application.dto.SubmissionDTO;
import com.brewalgo.domain.entity.Submission;
import java.util.List;

public interface SubmissionService {
    
    SubmissionDTO submitSolution(Long userId, Long problemId, String code, String language);
    
    SubmissionDTO submitContestSolution(Long userId, Long problemId, Long contestId, String code, String language);
    
    SubmissionDTO getSubmissionById(Long id);
    
    List<SubmissionDTO> getSubmissionsByUser(Long userId);
    
    List<SubmissionDTO> getSubmissionsByProblem(Long problemId);
    
    List<SubmissionDTO> getSubmissionsByContest(Long contestId);
    
    List<SubmissionDTO> getUserProblemSubmissions(Long userId, Long problemId);
    
    List<SubmissionDTO> getAcceptedSubmissionsByUser(Long userId);
    
    SubmissionDTO evaluateSubmission(Long submissionId);
    
    void updateSubmissionStatus(Long submissionId, Submission.Status status, 
                                Integer executionTime, Integer memoryUsed, String errorMessage);
    
    int calculateScore(Long problemId, Integer executionTime);
    
    boolean hasUserSolvedProblem(Long userId, Long problemId);
}