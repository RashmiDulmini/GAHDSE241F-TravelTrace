package com.project.TravelTrace.controller;

import com.project.TravelTrace.entity.User;
import com.project.TravelTrace.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Allows requests from Flutter/frontend/Postman
public class UserController {

    @Autowired
    private UserService userService;

    // Endpoint for registering a new user
    @PostMapping("/register")
    public User registerUser(@RequestBody User user) {
        return userService.registerUser(user);
    }

    // Endpoint for logging in an existing user
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        System.out.println("Login attempt for: " + user.getEmail());
        if (user.getEmail() == null || user.getPassword() == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Email and password must not be null");
        }

        User existingUser = userService.findByEmail(user.getEmail());

        if (existingUser == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("User not found with email: " + user.getEmail());
        }

        if (userService.checkPassword(user.getPassword(), existingUser.getPassword())) {
            System.out.println("Login successful for user: " + user.getEmail());
            return ResponseEntity.ok(existingUser);
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid email or password");
        }
    }

}
