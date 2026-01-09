package com.brewalgo.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponseDTO {
    
    private String token;
    private String tokenType = "Bearer";
    private UserDTO user;
    private String message;
}