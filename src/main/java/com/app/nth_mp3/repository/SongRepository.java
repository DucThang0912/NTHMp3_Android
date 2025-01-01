package com.app.nth_mp3.repository;

import com.app.nth_mp3.model.Song;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SongRepository extends JpaRepository<Song, Long> {
    List<Song> findByArtistId(Long artistId);
    List<Song> findByAlbumId(Long albumId);
    List<Song> findByGenreId(Long genreId);
    
    @Query(value = "SELECT * FROM song ORDER BY play_count DESC LIMIT :limit", nativeQuery = true)
    List<Song> findTopByOrderByPlayCountDesc(@Param("limit") int limit);
}