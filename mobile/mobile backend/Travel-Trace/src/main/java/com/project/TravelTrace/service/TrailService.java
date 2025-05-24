package com.project.TravelTrace.service;

import com.project.TravelTrace.entity.Trail;
import com.project.TravelTrace.repository.TrailRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class TrailService {

    @Autowired
    private TrailRepository trailRepository;

    public Trail save(Trail trail) {
        return trailRepository.save(trail);
    }

    public Trail findById(Long id) {
        return trailRepository.findById(id).orElse(null);
    }

    public List<Trail> findByUserId(Long userId) {
        return trailRepository.findByUserId(userId);
    }

    public List<Trail> findAll() {
        return trailRepository.findAll();
    }
} 