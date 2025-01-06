package com.app.nth_mp3.service;

import java.util.List;

import com.app.nth_mp3.model.Playhistory;
public interface PlayHistoryService {
    Playhistory addToHistory(Long userId, Long songId);
    List<Playhistory> getUserHistory(Long userId);
    void clearHistory(Long userId);
    boolean toggleFavorite(Long userId, Long songId);
    List<Playhistory> getFavorites(Long userId);
}
