package com.brewalgo.infrastructure.persistence;

import com.brewalgo.application.dto.ContestDTO;
import com.brewalgo.application.dto.LeaderboardEntryDTO;
import com.brewalgo.application.service.ContestService;
import com.brewalgo.domain.entity.Contest;
import com.brewalgo.domain.entity.Submission;
import com.brewalgo.domain.exception.BusinessException;
import com.brewalgo.domain.repository.ContestRepository;
import com.brewalgo.domain.repository.SubmissionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ContestServiceImpl implements ContestService {
    
    private final ContestRepository contestRepository;
    private final SubmissionRepository submissionRepository;
    
    @Override
    @Transactional
    public ContestDTO createContest(ContestDTO contestDTO) {
        log.info("Creating new contest: {}", contestDTO.getTitle());
        
        Contest contest = Contest.builder()
            .slug(generateSlug(contestDTO.getTitle()))
            .title(contestDTO.getTitle())
            .description(contestDTO.getDescription())
            .startTime(contestDTO.getStartTime())
            .endTime(contestDTO.getEndTime())
            .durationMinutes(contestDTO.getDurationMinutes())
            .status(Contest.Status.UPCOMING)
            .maxParticipants(contestDTO.getMaxParticipants() != null ? contestDTO.getMaxParticipants() : 1000)
            .currentParticipants(0)
            .createdAt(LocalDateTime.now())
            .build();
        
        Contest savedContest = contestRepository.save(contest);
        log.info("Contest created: {}", savedContest.getId());
        
        return ContestDTO.fromEntity(savedContest);
    }
    
    @Override
    @Transactional(readOnly = true)
    public ContestDTO getContestById(Long id) {
        Contest contest = contestRepository.findById(id)
            .orElseThrow(() -> BusinessException.notFound("Contest", id));
        return ContestDTO.fromEntity(contest);
    }
    
    @Override
    @Transactional(readOnly = true)
    public ContestDTO getContestBySlug(String slug) {
        Contest contest = contestRepository.findBySlug(slug)
            .orElseThrow(() -> BusinessException.notFound("Contest", slug));
        return ContestDTO.fromEntity(contest);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ContestDTO> getAllContests() {
        return contestRepository.findAll()
            .stream()
            .map(ContestDTO::fromEntity)
            .collect(Collectors.toList());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ContestDTO> getUpcomingContests() {
        return contestRepository.findUpcomingContests(LocalDateTime.now())
            .stream()
            .map(ContestDTO::fromEntity)
            .collect(Collectors.toList());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ContestDTO> getLiveContests() {
        return contestRepository.findLiveContests(LocalDateTime.now())
            .stream()
            .map(ContestDTO::fromEntity)
            .collect(Collectors.toList());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ContestDTO> getCompletedContests() {
        return contestRepository.findCompletedContests(LocalDateTime.now())
            .stream()
            .map(ContestDTO::fromEntity)
            .collect(Collectors.toList());
    }
    
    @Override
    @Transactional
    public ContestDTO updateContest(Long id, ContestDTO contestDTO) {
        Contest contest = contestRepository.findById(id)
            .orElseThrow(() -> BusinessException.notFound("Contest", id));
        
        if (contestDTO.getTitle() != null) {
            contest.setTitle(contestDTO.getTitle());
            contest.setSlug(generateSlug(contestDTO.getTitle()));
        }
        if (contestDTO.getDescription() != null) {
            contest.setDescription(contestDTO.getDescription());
        }
        if (contestDTO.getStartTime() != null) {
            contest.setStartTime(contestDTO.getStartTime());
        }
        if (contestDTO.getEndTime() != null) {
            contest.setEndTime(contestDTO.getEndTime());
        }
        if (contestDTO.getDurationMinutes() != null) {
            contest.setDurationMinutes(contestDTO.getDurationMinutes());
        }
        
        Contest updatedContest = contestRepository.save(contest);
        return ContestDTO.fromEntity(updatedContest);
    }
    
    @Override
    @Transactional
    public void deleteContest(Long id) {
        if (!contestRepository.existsById(id)) {
            throw BusinessException.notFound("Contest", id);
        }
        contestRepository.deleteById(id);
        log.info("Contest deleted: {}", id);
    }
    
    @Override
    @Transactional
    public void startContest(Long contestId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        
        contest.setStatus(Contest.Status.LIVE);
        contestRepository.save(contest);
        log.info("Contest {} started", contestId);
    }
    
    @Override
    @Transactional
    public void endContest(Long contestId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        
        contest.setStatus(Contest.Status.COMPLETED);
        contestRepository.save(contest);
        log.info("Contest {} ended", contestId);
    }
    
    @Override
    @Transactional
    public boolean joinContest(Long contestId, Long userId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        
        if (!canUserJoin(contestId, userId)) {
            return false;
        }
        
        contest.setCurrentParticipants(contest.getCurrentParticipants() + 1);
        contestRepository.save(contest);
        log.info("User {} joined contest {}", userId, contestId);
        
        return true;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<LeaderboardEntryDTO> getContestLeaderboard(Long contestId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        
        List<Submission> acceptedSubmissions = submissionRepository.findContestAcceptedSubmissionsOrdered(contest);
        
        // Group by user and calculate total scores
        Map<Long, LeaderboardEntryDTO> leaderboardMap = new HashMap<>();
        
        for (Submission submission : acceptedSubmissions) {
            Long userId = submission.getUser().getId();
            
            leaderboardMap.putIfAbsent(userId, LeaderboardEntryDTO.builder()
                .userId(userId)
                .username(submission.getUser().getUsername())
                .rating(submission.getUser().getRating())
                .problemsSolved(0)
                .totalScore(0)
                .contestScore(0)
                .build());
            
            LeaderboardEntryDTO entry = leaderboardMap.get(userId);
            entry.setProblemsSolved(entry.getProblemsSolved() + 1);
            entry.setContestScore(entry.getContestScore() + submission.getScoreAwarded());
        }
        
        // Sort by score descending and assign ranks
        List<LeaderboardEntryDTO> leaderboard = new ArrayList<>(leaderboardMap.values());
        leaderboard.sort(Comparator.comparingInt(LeaderboardEntryDTO::getContestScore).reversed());
        
        for (int i = 0; i < leaderboard.size(); i++) {
            leaderboard.get(i).setRank(i + 1);
        }
        
        return leaderboard;
    }
    
    @Override
    @Transactional
    public void updateContestStatus(Long contestId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        
        LocalDateTime now = LocalDateTime.now();
        
        if (now.isBefore(contest.getStartTime())) {
            contest.setStatus(Contest.Status.UPCOMING);
        } else if (now.isAfter(contest.getEndTime())) {
            contest.setStatus(Contest.Status.COMPLETED);
        } else {
            contest.setStatus(Contest.Status.LIVE);
        }
        
        contestRepository.save(contest);
    }
    
    @Override
    public boolean isContestActive(Long contestId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        return contest.getStatus() == Contest.Status.LIVE;
    }
    
    @Override
    public boolean canUserJoin(Long contestId, Long userId) {
        Contest contest = contestRepository.findById(contestId)
            .orElseThrow(() -> BusinessException.notFound("Contest", contestId));
        
        if (contest.getStatus() != Contest.Status.UPCOMING && contest.getStatus() != Contest.Status.LIVE) {
            return false;
        }
        
        return contest.getCurrentParticipants() < contest.getMaxParticipants();
    }
    
    private String generateSlug(String title) {
        return title.toLowerCase()
            .replaceAll("[^a-z0-9\\s-]", "")
            .replaceAll("\\s+", "-")
            .replaceAll("-+", "-")
            .trim();
    }
}