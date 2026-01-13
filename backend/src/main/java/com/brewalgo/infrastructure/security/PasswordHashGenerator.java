package com.brewalgo.infrastructure.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordHashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        System.out.println("=== BrewAlgo Password Hashes ===\n");
        
        // Generate hash for "admin123"
        System.out.println("admin (password: admin123):");
        System.out.println(encoder.encode("admin123"));
        System.out.println();
        
        // Generate hash for "password123"
        System.out.println("alice, bob, charlie, dave (password: password123):");
        System.out.println(encoder.encode("password123"));
        System.out.println();
        
        System.out.println("Copy these hashes into seed.sql!");
    }
}
