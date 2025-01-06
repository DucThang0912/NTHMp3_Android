package com.app.nth_mp3.service;

import java.util.List;

import com.app.nth_mp3.model.Song;

public interface FavoriteSongService {
    void addToFavorites(Long userId, Long songId);
    void removeFromFavorites(Long userId, Long songId);
    List<Song> getUserFavorites(Long userId);
    boolean isSongFavorited(Long userId, Long songId);
}
