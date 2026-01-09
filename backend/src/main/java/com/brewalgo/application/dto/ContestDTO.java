package com.brewalgo.application.dto;

import com.brewalgo.domain.entity.Contest;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContestDTO {
    
    private Long id;
    private String slug;
    private String title;
    private String description;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer durationMinutes;
    private String status;
    private Integer maxParticipants;
    private Integer currentParticipants;
    private LocalDateTime createdAt;
    
    public static ContestDTO fromEntity(Contest contest) {
        return ContestDTO.builder()
            .id(contest.getId())
            .slug(contest.getSlug())
            .title(contest.getTitle())
            .description(contest.getDescription())
            .startTime(contest.getStartTime())
            .endTime(contest.getEndTime())
            .durationMinutes(contest.getDurationMinutes())
            .status(contest.getStatus().name())
            .maxParticipants(contest.getMaxParticipants())
            .currentParticipants(contest.getCurrentParticipants())
            .createdAt(contest.getCreatedAt())
            .build();
    }
}