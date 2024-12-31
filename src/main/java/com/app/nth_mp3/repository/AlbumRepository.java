package com.app.nth_mp3.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.app.nth_mp3.model.Album;

@Repository
public interface AlbumRepository extends JpaRepository<Album, Long> {
}