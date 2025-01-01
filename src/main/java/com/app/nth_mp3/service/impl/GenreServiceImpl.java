package com.app.nth_mp3.service.impl;

import com.app.nth_mp3.model.Genre;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.repository.GenreRepository;
import com.app.nth_mp3.service.GenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GenreServiceImpl implements GenreService {

    @Autowired
    private GenreRepository genreRepository;

    // Lấy tất cả thể loại  
    @Override
    public List<Genre> getAllGenres() {
        return genreRepository.findAll();
    }
    
    // Lấy thể loại theo id
    @Override
    public Optional<Genre> getGenreById(Long id) {
        return genreRepository.findById(id);
    }

    // Tạo thể loại
    @Override
    public Genre createGenre(Genre genre) {
        return genreRepository.save(genre);
    }

    // Cập nhật thể loại
    @Override
    public Genre updateGenre(Long id, Genre genreDetails) {
        Genre genre = genreRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thể loại với id: " + id));

        genre.setName(genreDetails.getName());

        return genreRepository.save(genre);
    }

    // Xóa thể loại
    @Override
    public void deleteGenre(Long id) {
        Genre genre = genreRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thể loại với id: " + id));
        genreRepository.delete(genre);
    }
} 