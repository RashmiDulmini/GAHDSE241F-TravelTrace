package com.project.TravelTrace.controller;

import com.project.TravelTrace.entity.Trail;
import com.project.TravelTrace.entity.User;
import com.project.TravelTrace.service.TrailService;
import com.project.TravelTrace.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@RestController
@RequestMapping("/api/trails")
@CrossOrigin(origins = "*")
public class TrailController {

    private static final Logger logger = LoggerFactory.getLogger(TrailController.class);
    private static final String UPLOAD_DIR = "uploads";

    @Autowired
    private TrailService trailService;

    @Autowired
    private UserService userService;

    @PostMapping("/create")
    public ResponseEntity<?> createTrail(
            @RequestParam("name") String name,
            @RequestParam("trailName") String trailName,
            @RequestParam("description") String description,
            @RequestParam("startLatitude") Double startLatitude,
            @RequestParam("startLongitude") Double startLongitude,
            @RequestParam("endLatitude") Double endLatitude,
            @RequestParam("endLongitude") Double endLongitude,
            @RequestParam("mediaType") String mediaType,
            @RequestParam("mediaFile") MultipartFile mediaFile,
            @RequestParam("userId") Long userId) {

        try {
            // Create upload directory if it doesn't exist
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Generate unique filename
            String originalFilename = mediaFile.getOriginalFilename();
            String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + fileExtension;
            Path filePath = uploadPath.resolve(newFilename);

            // Save file
            Files.copy(mediaFile.getInputStream(), filePath);

            // Create trail entity
            Trail trail = new Trail();
            trail.setName(name);
            trail.setTrailName(trailName);
            trail.setDescription(description);
            trail.setStartLatitude(startLatitude);
            trail.setStartLongitude(startLongitude);
            trail.setEndLatitude(endLatitude);
            trail.setEndLongitude(endLongitude);
            trail.setMediaType(mediaType);
            trail.setMediaUrl(newFilename);

            // Set user
            User user = userService.findById(userId);
            if (user == null) {
                return ResponseEntity.badRequest().body("User not found");
            }
            trail.setUser(user);

            // Save trail
            Trail savedTrail = trailService.save(trail);
            return ResponseEntity.ok(savedTrail);

        } catch (IOException e) {
            logger.error("Failed to create trail", e);
            return ResponseEntity.badRequest().body("Failed to create trail: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getTrail(@PathVariable Long id) {
        Trail trail = trailService.findById(id);
        if (trail == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(trail);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getUserTrails(@PathVariable Long userId) {
        return ResponseEntity.ok(trailService.findByUserId(userId));
    }
}
