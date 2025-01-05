package com.app.nth_mp3.service;

import com.app.nth_mp3.model.Album;
import java.util.List;
import java.util.Optional;

public interface AlbumService {
    List<Album> getAllAlbums();
    Optional<Album> getAlbumById(Long id);
    List<Album> getAlbumByTitleAndArtistId(String title, Long artistId);
    Album createAlbum(Album album);
    Album updateAlbum(Long id, Album album);
    void deleteAlbum(Long id);
    List<Album> getAlbumsByArtistId(Long artistId);
    List<Album> getAlbumsByYear(Integer year);
} 