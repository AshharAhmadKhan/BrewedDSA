package com.brewalgo.application.service;

import com.brewalgo.application.dto.AuthRequestDTO;
import com.brewalgo.application.dto.AuthResponseDTO;
import com.brewalgo.application.dto.UserDTO;
import com.brewalgo.domain.entity.User;
import java.util.List;

public interface UserService {
    
    AuthResponseDTO register(AuthRequestDTO request);
    
    AuthResponseDTO login(String username, String password);
    
    UserDTO getUserById(Long id);
    
    UserDTO getUserByUsername(String username);
    
    UserDTO updateUser(Long id, UserDTO userDTO);
    
    void deleteUser(Long id);
    
    List<UserDTO> getTopUsersByRating(int limit);
    
    List<UserDTO> getUsersByMinimumRating(int minRating);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
    
    void updateUserRating(Long userId, int newRating);
    
    void incrementProblemsSolved(Long userId);
}