package com.brewalgo.application.dto;

import com.brewalgo.domain.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO {
    
    private Long id;
    private String username;
    private String email;
    private Integer rating;
    private Integer problemsSolved;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;
    private String role;
    
    public static UserDTO fromEntity(User user) {
        return UserDTO.builder()
            .id(user.getId())
            .username(user.getUsername())
            .email(user.getEmail())
            .rating(user.getRating())
            .problemsSolved(user.getProblemsSolved())
            .createdAt(user.getCreatedAt())
            .lastLoginAt(user.getLastLoginAt())
            .role(user.getRole().name())
            .build();
    }
}