package com.brewalgo.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LeaderboardEntryDTO {
    
    private Integer rank;
    private Long userId;
    private String username;
    private Integer rating;
    private Integer problemsSolved;
    private Integer totalScore;
    private Integer contestScore;
}