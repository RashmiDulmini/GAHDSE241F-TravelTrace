package com.project.TravelTrace.controller;

import com.project.TravelTrace.entity.User;
import com.project.TravelTrace.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
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
    public User loginUser(@RequestBody User user) {
        User existingUser = userService.findByEmail(user.getEmail());

        // Check if user exists and if the password matches
        if (existingUser != null && userService.checkPassword(user.getPassword(), existingUser.getPassword())) {
            return existingUser; // Return the user if login is successful
        } else {
            throw new RuntimeException("Invalid email or password");
        }
    }
}
