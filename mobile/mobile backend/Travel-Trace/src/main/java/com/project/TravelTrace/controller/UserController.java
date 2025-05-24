package com.project.TravelTrace.controller;

import com.project.TravelTrace.entity.User;
import com.project.TravelTrace.service.UserService;
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
@CrossOrigin(origins = "*") // Allows requests from Flutter/frontend/Postman
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    // Endpoint for registering a new user
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        try {
            User registeredUser = userService.registerUser(user);
            return ResponseEntity.ok(registeredUser);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Endpoint for logging in an existing user
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        try {
            logger.info("Login attempt for: {}", user.getEmail());
            if (user.getEmail() == null || user.getPassword() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("message", "Email and password must not be null"));
            }

            User existingUser = userService.findByEmail(user.getEmail());

            if (existingUser == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found with email: " + user.getEmail()));
            }

            if (userService.checkPassword(user.getPassword(), existingUser.getPassword())) {
                logger.info("Login successful for user: {}", user.getEmail());
                // Don't send password back to client
                existingUser.setPassword(null);
                return ResponseEntity.ok(existingUser);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("message", "Invalid password"));
            }
        } catch (Exception e) {
            logger.error("An error occurred during login", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "An error occurred during login: " + e.getMessage()));
        }
    }
}
