package com.app.nth_mp3.service;

import com.app.nth_mp3.model.Genre;

import java.util.List;
import java.util.Optional;

public interface GenreService {
    List<Genre> getAllGenres();
    Optional<Genre> getGenreById(Long id);
    Optional<Genre> getGenreByName(String name);
    Genre createGenre(Genre genre);
    Genre updateGenre(Long id, Genre genre);
    void deleteGenre(Long id);
} 