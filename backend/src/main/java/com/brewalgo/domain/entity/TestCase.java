package com.brewalgo.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "test_cases")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TestCase {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "problem_id", nullable = false)
    private Problem problem;
    
    @Column(columnDefinition = "TEXT", nullable = false)
    private String input;
    
    @Column(columnDefinition = "TEXT", nullable = false)
    private String expectedOutput;
    
    @Column(nullable = false)
    private Boolean isHidden = false;
    
    @Column(nullable = false)
    private Integer orderIndex = 0;
}