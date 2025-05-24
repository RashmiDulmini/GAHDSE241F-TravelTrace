package com.project.TravelTrace.service;

import com.project.TravelTrace.entity.User;
import com.project.TravelTrace.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // Use NoOpPasswordEncoder for plain text password storage (not secure)

    // Method to register a user with plain text password
    public User registerUser(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already registered!");
        }

        // Store the plain text password (not encrypted)
        user.setPassword(user.getPassword());
        return userRepository.save(user);
    }

    // Method to find a user by their email
    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // Method to find a user by their ID
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    // Method to check if the entered password matches the one in the database
    public boolean checkPassword(String rawPassword, String encodedPassword) {
        // No encoding, so direct comparison (also not secure)
        return rawPassword.equals(encodedPassword);
    }
}
