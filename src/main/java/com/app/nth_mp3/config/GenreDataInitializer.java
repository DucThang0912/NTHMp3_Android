package com.app.nth_mp3.config;

import com.app.nth_mp3.model.Genre;
import com.app.nth_mp3.repository.GenreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
public class GenreDataInitializer implements CommandLineRunner {

    @Autowired
    private GenreRepository genreRepository;

    @Override
    public void run(String... args) {
        // Danh sách các thể loại cần thêm
        List<String> genreNames = Arrays.asList(
            "Nhạc Trẻ",
            "Rap/Hip Hop",
            "Rock",
            "Ballad",
            "R&B",
            "EDM",
            "Nhạc Trữ Tình",
            "Nhạc Dân Ca",
            "Jazz",
            "Indie",
            "Pop",
            "Blues",
            "Country",
            "Classical",
            "Latin",
            "K-Pop",
            "V-Pop",
            "US-UK",
            "Acoustic",
            "Alternative",
            "Remix",
            "Nhạc Phim",
            "Nhạc Không Lời",
            "Nhạc Thiếu Nhi"
        );

        // Kiểm tra và thêm từng thể loại
        for (String name : genreNames) {
            // Kiểm tra xem thể loại đã tồn tại chưa
            if (!genreRepository.existsByName(name)) {
                Genre genre = new Genre();
                genre.setName(name);
                genreRepository.save(genre);
            }
        }
    }
} 