package com.project.TravelTrace.repository;

import com.project.TravelTrace.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Find a user by their email address
    User findByEmail(String email);

    // Check if email already exists in the database
    boolean existsByEmail(String email);
}
