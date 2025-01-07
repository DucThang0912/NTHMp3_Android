package com.app.nth_mp3.repository;

import com.app.nth_mp3.model.Song;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;


@Repository
public interface SongRepository extends JpaRepository<Song, Long> {
    Optional<Song> findBySpotifyId(String spotifyId);
    boolean existsBySpotifyId(String spotifyId);
}