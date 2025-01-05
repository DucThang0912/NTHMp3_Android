package com.app.nth_mp3.service.impl;

import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.repository.AlbumRepository;
import com.app.nth_mp3.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AlbumServiceImpl implements AlbumService {

    @Autowired
    private AlbumRepository albumRepository;

    // Lấy tất cả album
    @Override
    public List<Album> getAllAlbums() {
        return albumRepository.findAll();
    }

    // Lấy album theo id
    @Override
    public Optional<Album> getAlbumById(Long id) {
        return albumRepository.findById(id);
    }

    // Tạo album
    @Override
    public Album createAlbum(Album album) {
        return albumRepository.save(album);
    }

    // Cập nhật album
    @Override
    public Album updateAlbum(Long id, Album albumDetails) {
        Album album = albumRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy album với id: " + id));

        album.setTitle(albumDetails.getTitle());
        album.setArtist(albumDetails.getArtist());
        album.setReleaseYear(albumDetails.getReleaseYear());
        album.setCoverImageUrl(albumDetails.getCoverImageUrl());

        return albumRepository.save(album);
    }

    // Xóa album
    @Override
    public void deleteAlbum(Long id) {
        Album album = albumRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy album với id: " + id));
        albumRepository.delete(album);
    }

    // Lấy album theo id nghệ sĩ
    @Override
    public List<Album> getAlbumsByArtistId(Long artistId) {
        return albumRepository.findByArtistId(artistId);
    }

    // Lấy album theo năm phát hành
    @Override
    public List<Album> getAlbumsByYear(Integer year) {
        return albumRepository.findByReleaseYear(year);
    }

    @Override
    public List<Album> getAlbumByTitleAndArtistId(String title, Long artistId) {
        return albumRepository.findByTitleAndArtistId(title, artistId);
    }
} 