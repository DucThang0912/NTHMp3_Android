package com.app.nth_mp3.repository;

import com.app.nth_mp3.model.Playlist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface PlaylistRepository extends JpaRepository<Playlist, Long> {
    List<Playlist> findByUserId(Long userId);
    List<Playlist> findByUser_Username(String username);
    List<Playlist> findByIsPublicTrue();
    boolean existsByNameAndUserId(String name, Long userId);
}