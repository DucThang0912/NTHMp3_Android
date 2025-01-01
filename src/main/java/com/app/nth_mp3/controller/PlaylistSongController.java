package com.app.nth_mp3.controller;

import com.app.nth_mp3.model.PlaylistSong;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.service.PlaylistSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/playlists/{playlistId}/songs")
public class PlaylistSongController {

    @Autowired
    private PlaylistSongService playlistSongService;

    // API thêm bài hát vào playlist
    @PostMapping("/{songId}")
    public ResponseEntity<PlaylistSong> addSongToPlaylist(
            @PathVariable Long playlistId,
            @PathVariable Long songId) {
        try {
            PlaylistSong playlistSong = playlistSongService.addSongToPlaylist(playlistId, songId);
            return new ResponseEntity<>(playlistSong, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API xóa bài hát khỏi playlist
    @DeleteMapping("/{songId}")
    public ResponseEntity<HttpStatus> removeSongFromPlaylist(
            @PathVariable Long playlistId,
            @PathVariable Long songId) {
        try {
            playlistSongService.removeSongFromPlaylist(playlistId, songId);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy danh sách bài hát trong playlist
    @GetMapping
    public ResponseEntity<List<Song>> getSongsInPlaylist(@PathVariable Long playlistId) {
        try {
            List<Song> songs = playlistSongService.getSongsInPlaylist(playlistId);
            return new ResponseEntity<>(songs, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API kiểm tra bài hát có trong playlist không
    @GetMapping("/{songId}/check")
    public ResponseEntity<Boolean> checkSongInPlaylist(
            @PathVariable Long playlistId,
            @PathVariable Long songId) {
        try {
            boolean exists = playlistSongService.isSongInPlaylist(playlistId, songId);
            return new ResponseEntity<>(exists, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
} 