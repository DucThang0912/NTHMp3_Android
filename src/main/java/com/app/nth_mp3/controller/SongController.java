package com.app.nth_mp3.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.service.SongService;

@RestController
@RequestMapping("/api/songs")
public class SongController {
    @Autowired
    private SongService songService;

    // API lấy thông tin bài hát theo spotifyId
    @GetMapping("/spotify/{spotifyId}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<Song> getSongBySpotifyId(@PathVariable String spotifyId) {
        try {
            Song song = songService.findBySpotifyId(spotifyId);
            return ResponseEntity.ok(song);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    // API cập nhật số lần phát
    @PutMapping("/play-count/{spotifyId}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<Song> incrementPlayCount(@PathVariable String spotifyId) {
        try {
            Song song = songService.incrementPlayCount(spotifyId);
            return ResponseEntity.ok(song);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // API lưu bài hát
    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<Song> saveSong(@RequestBody Song song) {
        Song savedSong = songService.saveSong(song);
        return ResponseEntity.ok(savedSong);
    }
}
