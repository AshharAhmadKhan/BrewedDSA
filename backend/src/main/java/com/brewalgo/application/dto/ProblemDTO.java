package com.brewalgo.application.dto;

import com.brewalgo.domain.entity.Problem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProblemDTO {
    
    private Long id;
    private String slug;
    private String title;
    private String description;
    private String difficulty;
    private Integer baseScore;
    private Integer acceptanceRate;
    private Integer totalSubmissions;
    private Integer successfulSubmissions;
    private LocalDateTime createdAt;
    private String hints;
    private String tags;
    
    public static ProblemDTO fromEntity(Problem problem) {
        return ProblemDTO.builder()
            .id(problem.getId())
            .slug(problem.getSlug())
            .title(problem.getTitle())
            .description(problem.getDescription())
            .difficulty(problem.getDifficulty().name())
            .baseScore(problem.getBaseScore())
            .acceptanceRate(problem.getAcceptanceRate())
            .totalSubmissions(problem.getTotalSubmissions())
            .successfulSubmissions(problem.getSuccessfulSubmissions())
            .createdAt(problem.getCreatedAt())
            .hints(problem.getHints())
            .tags(problem.getTags())
            .build();
    }
}