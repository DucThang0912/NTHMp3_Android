package com.app.nth_mp3.service;

import com.app.nth_mp3.model.Song;
import java.util.List;
import java.util.Optional;

public interface SongService {
    List<Song> getAllSongs();
    Optional<Song> getSongById(Long id);
    Song createSong(Song song);
    Song updateSong(Long id, Song song);
    void deleteSong(Long id);
    List<Song> getSongsByArtistId(Long artistId);
    List<Song> getSongsByAlbumId(Long albumId);
    List<Song> getSongsByGenreId(Long genreId);
    void incrementPlayCount(Long songId);
    List<Song> getTopPlayedSongs(int limit);
} 