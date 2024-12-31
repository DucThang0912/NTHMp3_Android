package com.app.nth_mp3.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.app.nth_mp3.model.Genre;

@Repository
public interface GenreRepository extends JpaRepository<Genre, Long> {
}