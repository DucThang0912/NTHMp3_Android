package com.app.nth_mp3.controller;

import com.app.nth_mp3.dto.AlbumDTO;
import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/albums")
public class AlbumController {

    @Autowired
    private AlbumService albumService;

    private AlbumDTO convertToDTO(Album album) {
        AlbumDTO dto = new AlbumDTO();
        dto.setId(album.getId());
        dto.setTitle(album.getTitle());
        dto.setArtistName(album.getArtist().getName());
        dto.setArtistId(album.getArtist().getId());
        dto.setReleaseYear(album.getReleaseYear());
        dto.setCoverImageUrl(album.getCoverImageUrl());
        dto.setTotalSongs(album.getSongs().size());
        dto.setCreatedDate(album.getCreatedDate());
        dto.setUpdatedDate(album.getUpdatedDate());
        return dto;
    }

    // API lấy tất cả album
    @GetMapping("/list")
    public ResponseEntity<List<AlbumDTO>> getAllAlbums() {
        try {
            List<Album> albums = albumService.getAllAlbums();
            List<AlbumDTO> albumDTOs = albums.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
            return new ResponseEntity<>(albumDTOs, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy album theo id
    @GetMapping("/get-by/{id}")
    public ResponseEntity<Album> getAlbumById(@PathVariable Long id) {
        try {
            return albumService.getAlbumById(id)
                    .map(album -> new ResponseEntity<>(album, HttpStatus.OK))
                    .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API tạo album mới
    @PostMapping
    public ResponseEntity<Album> createAlbum(@RequestBody Album album) {
        try {
            Album createdAlbum = albumService.createAlbum(album);
            return new ResponseEntity<>(createdAlbum, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API cập nhật album
    @PutMapping("/{id}")
    public ResponseEntity<Album> updateAlbum(@PathVariable Long id, @RequestBody Album album) {
        try {
            Album updatedAlbum = albumService.updateAlbum(id, album);
            return new ResponseEntity<>(updatedAlbum, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API xóa album
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> deleteAlbum(@PathVariable Long id) {
        try {
            albumService.deleteAlbum(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy album theo nghệ sĩ
    @GetMapping("/artist/{artistId}")
    public ResponseEntity<List<Album>> getAlbumsByArtistId(@PathVariable Long artistId) {
        try {
            List<Album> albums = albumService.getAlbumsByArtistId(artistId);
            return new ResponseEntity<>(albums, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy album theo năm phát hành
    @GetMapping("/year/{year}")
    public ResponseEntity<List<Album>> getAlbumsByYear(@PathVariable Integer year) {
        try {
            List<Album> albums = albumService.getAlbumsByYear(year);
            return new ResponseEntity<>(albums, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
} 