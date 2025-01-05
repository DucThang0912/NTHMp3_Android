package com.app.nth_mp3.controller;

import com.app.nth_mp3.dto.GenreDTO;
import com.app.nth_mp3.model.Genre;
import com.app.nth_mp3.service.GenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/genres")
public class GenreController {

    @Autowired
    private GenreService genreService;

    private GenreDTO convertToDTO(Genre genre) {
        GenreDTO dto = new GenreDTO();
        dto.setId(genre.getId());
        dto.setName(genre.getName());
        dto.setCreatedDate(genre.getCreatedDate());
        dto.setUpdatedDate(genre.getUpdatedDate());
        return dto;
    }

    @GetMapping("/list")
    public ResponseEntity<List<GenreDTO>> getAllGenres() {
        try {
            List<Genre> genres = genreService.getAllGenres();
            List<GenreDTO> genreDTOs = genres.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
            return new ResponseEntity<>(genreDTOs, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/get-by/{id}")
    public ResponseEntity<GenreDTO> getGenreById(@PathVariable Long id) {
        try {
            return genreService.getGenreById(id)
                .map(genre -> new ResponseEntity<>(convertToDTO(genre), HttpStatus.OK))
                .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API tạo thể loại mới
    @PostMapping
    public ResponseEntity<Genre> createGenre(@RequestBody Genre genre) {
        try {
            Genre createdGenre = genreService.createGenre(genre);
            return new ResponseEntity<>(createdGenre, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API cập nhật thể loại
    @PutMapping("/{id}")
    public ResponseEntity<Genre> updateGenre(@PathVariable Long id, @RequestBody Genre genre) {
        try {
            Genre updatedGenre = genreService.updateGenre(id, genre);
            return new ResponseEntity<>(updatedGenre, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API xóa thể loại
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> deleteGenre(@PathVariable Long id) {
        try {
            genreService.deleteGenre(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
} 