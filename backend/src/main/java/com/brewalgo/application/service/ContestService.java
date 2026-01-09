package com.brewalgo.application.service;

import com.brewalgo.application.dto.ContestDTO;
import com.brewalgo.application.dto.LeaderboardEntryDTO;
import java.util.List;

public interface ContestService {
    
    ContestDTO createContest(ContestDTO contestDTO);
    
    ContestDTO getContestById(Long id);
    
    ContestDTO getContestBySlug(String slug);
    
    List<ContestDTO> getAllContests();
    
    List<ContestDTO> getUpcomingContests();
    
    List<ContestDTO> getLiveContests();
    
    List<ContestDTO> getCompletedContests();
    
    ContestDTO updateContest(Long id, ContestDTO contestDTO);
    
    void deleteContest(Long id);
    
    void startContest(Long contestId);
    
    void endContest(Long contestId);
    
    boolean joinContest(Long contestId, Long userId);
    
    List<LeaderboardEntryDTO> getContestLeaderboard(Long contestId);
    
    void updateContestStatus(Long contestId);
    
    boolean isContestActive(Long contestId);
    
    boolean canUserJoin(Long contestId, Long userId);
}