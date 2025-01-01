package com.app.nth_mp3.controller;

import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.model.Artist;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.service.ArtistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
    @RequestMapping("/api/artists")
public class ArtistController {

    @Autowired
    private ArtistService artistService;

    // API lấy tất cả nghệ sĩ
    @GetMapping("/list")
    public ResponseEntity<List<Artist>> getAllArtists() {
        try {
            List<Artist> artists = artistService.getAllArtists();
            return new ResponseEntity<>(artists, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy nghệ sĩ theo id
    @GetMapping("/get-by/{id}")
    public ResponseEntity<Artist> getArtistById(@PathVariable Long id) {
        try {
            return artistService.getArtistById(id)
                    .map(artist -> new ResponseEntity<>(artist, HttpStatus.OK))
                    .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API tạo nghệ sĩ mới
    @PostMapping
    public ResponseEntity<Artist> createArtist(@RequestBody Artist artist) {
        try {
            Artist createdArtist = artistService.createArtist(artist);
            return new ResponseEntity<>(createdArtist, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API cập nhật nghệ sĩ
    @PutMapping("/{id}")
    public ResponseEntity<Artist> updateArtist(@PathVariable Long id, @RequestBody Artist artist) {
        try {
            Artist updatedArtist = artistService.updateArtist(id, artist);
            return new ResponseEntity<>(updatedArtist, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API xóa nghệ sĩ
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> deleteArtist(@PathVariable Long id) {
        try {
            artistService.deleteArtist(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy danh sách bài hát của nghệ sĩ
    @GetMapping("/{id}/songs")
    public ResponseEntity<List<Song>> getArtistSongs(@PathVariable Long id) {
        try {
            List<Song> songs = artistService.getArtistSongs(id);
            return new ResponseEntity<>(songs, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy danh sách album của nghệ sĩ
    @GetMapping("/{id}/albums")
    public ResponseEntity<List<Album>> getArtistAlbums(@PathVariable Long id) {
        try {
            List<Album> albums = artistService.getArtistAlbums(id);
            return new ResponseEntity<>(albums, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
} 