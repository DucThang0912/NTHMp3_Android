package com.app.nth_mp3.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.repository.SongRepository;
import com.app.nth_mp3.service.SongService;

@Service
public class SongServiceImpl implements SongService {
    @Autowired
    private SongRepository songRepository;

    @Override
    public Song findBySpotifyId(String spotifyId) {
        return songRepository.findBySpotifyId(spotifyId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy bài hát"));
    }

    @Override
    @Transactional
    public Song incrementPlayCount(String spotifyId) {
        Song song = findBySpotifyId(spotifyId);
        song.setPlayCount(song.getPlayCount() + 1);
        return songRepository.save(song);
    }

    @Override
    public Song saveSong(Song song) {
        // Kiểm tra spotifyId đã tồn tại chưa
        boolean exists = songRepository.existsBySpotifyId(song.getSpotifyId());
        
        if (exists) {
            throw new RuntimeException("Bài hát với Spotify ID này đã tồn tại!");
        }
        
        return songRepository.save(song);
    }
}
