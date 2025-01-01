package com.app.nth_mp3.controller;

import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/songs")
public class SongController {

    @Autowired
    private SongService songService;

    // API lấy tất cả bài hát
    @GetMapping("/list")
    public ResponseEntity<List<Song>> getAllSongs() {
        return ResponseEntity.ok(songService.getAllSongs());
    }

    // API lấy bài hát theo id
    @GetMapping("/get-by/{id}")
    public ResponseEntity<Song> getSongById(@PathVariable Long id) {
        return songService.getSongById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // API tạo bài hát mới
    @PostMapping
    public ResponseEntity<Song> createSong(@RequestBody Song song) {
        try {
            return new ResponseEntity<>(songService.createSong(song), HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API cập nhật bài hát
    @PutMapping("/{id}")
    public ResponseEntity<Song> updateSong(@PathVariable Long id, @RequestBody Song song) {
        try {
            return ResponseEntity.ok(songService.updateSong(id, song));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API xóa bài hát
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSong(@PathVariable Long id) {
        try {
            songService.deleteSong(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy bài hát theo nghệ sĩ
    @GetMapping("/artist/{artistId}")
    public ResponseEntity<List<Song>> getSongsByArtistId(@PathVariable Long artistId) {
        return ResponseEntity.ok(songService.getSongsByArtistId(artistId));
    }

    // API lấy bài hát theo album
    @GetMapping("/album/{albumId}")
    public ResponseEntity<List<Song>> getSongsByAlbumId(@PathVariable Long albumId) {
        return ResponseEntity.ok(songService.getSongsByAlbumId(albumId));
    }

    // API lấy bài hát theo thể loại
    @GetMapping("/genre/{genreId}")
    public ResponseEntity<List<Song>> getSongsByGenreId(@PathVariable Long genreId) {
        return ResponseEntity.ok(songService.getSongsByGenreId(genreId));
    }

    // API tăng số lần nghe
    @PostMapping("/{id}/increment-play")
    public ResponseEntity<Void> incrementPlayCount(@PathVariable Long id) {
        try {
            songService.incrementPlayCount(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // API lấy top bài hát được nghe nhiều
    @GetMapping("/top-played")
    public ResponseEntity<List<Song>> getTopPlayedSongs(@RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(songService.getTopPlayedSongs(limit));
    }
} 