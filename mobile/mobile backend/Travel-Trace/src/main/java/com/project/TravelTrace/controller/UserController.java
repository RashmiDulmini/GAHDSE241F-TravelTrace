package com.project.TravelTrace.controller;

import com.project.TravelTrace.entity.User;
import com.project.TravelTrace.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserRepository userRepository;

    // Register new user
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        if (user == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "User data is missing"));
        }

        if (user.getEmail() == null || user.getUserName() == null || user.getPassword() == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Email, Username, and Password are required"));
        }

        try {
            if (userRepository.existsByEmail(user.getEmail())) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "Email already exists"));
            }
            if (userRepository.existsByUserName(user.getUserName())) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(Map.of("message", "Username already exists"));
            }

            // Save user
            User savedUser = userRepository.save(user);

            // Hide password before returning
            savedUser.setPassword(null);
            return ResponseEntity.ok(savedUser);

        } catch (Exception e) {
            logger.error("Error during registration", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Internal error during registration"));
        }
    }

    // Login user
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        if (user == null || user.getEmail() == null || user.getPassword() == null) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Email and Password must be provided"));
        }

        try {
            User existingUser = userRepository.findByEmail(user.getEmail());
            if (existingUser == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found with email: " + user.getEmail()));
            }

            if (existingUser.getPassword().equals(user.getPassword())) {
                existingUser.setPassword(null);
                return ResponseEntity.ok(existingUser);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("message", "Invalid password"));
            }
        } catch (Exception e) {
            logger.error("Login error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Internal error during login"));
        }
    }

    // Update user by id
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User updatedUser) {
        if (updatedUser == null) {
            return ResponseEntity.badRequest().body(Map.of("message", "Updated user data missing"));
        }

        try {
            // Find user by id first
            var optionalUser = userRepository.findById(id);

            if (optionalUser.isPresent()) {
                User user = optionalUser.get();

                if (updatedUser.getFullName() != null) user.setFullName(updatedUser.getFullName());
                if (updatedUser.getUserName() != null) user.setUserName(updatedUser.getUserName());
                if (updatedUser.getAddress() != null) user.setAddress(updatedUser.getAddress());
                if (updatedUser.getContact() != null) user.setContact(updatedUser.getContact());
                if (updatedUser.getEmail() != null) user.setEmail(updatedUser.getEmail());
                if (updatedUser.getProfilePicture() != null) user.setProfilePicture(updatedUser.getProfilePicture());
                if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) {
                    user.setPassword(updatedUser.getPassword());
                }

                User savedUser = userRepository.save(user);
                savedUser.setPassword(null);

                return ResponseEntity.ok(savedUser);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found"));
            }

        } catch (Exception e) {
            logger.error("Error updating user", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Internal error updating user"));
        }
    }
}