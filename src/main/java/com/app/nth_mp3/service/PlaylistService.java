package com.app.nth_mp3.service;

import com.app.nth_mp3.model.Playlist;
import java.util.List;
import java.util.Optional;

public interface PlaylistService {
    List<Playlist> getAllPlaylists();
    Optional<Playlist> getPlaylistById(Long id);
    Playlist createPlaylist(Playlist playlist);
    Playlist updatePlaylist(Long id, Playlist playlist);
    void deletePlaylist(Long id);
    
    // Các phương thức bổ sung
    List<Playlist> getPlaylistsByUserId(Long userId);
    List<Playlist> getPlaylistsByUsername(String username);
    List<Playlist> getPublicPlaylists();
    void togglePlaylistVisibility(Long id);
} 