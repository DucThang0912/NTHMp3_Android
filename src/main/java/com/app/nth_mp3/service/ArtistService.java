package com.app.nth_mp3.service;

import com.app.nth_mp3.model.Artist;
import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.model.Song;

import java.util.List;
import java.util.Optional;

public interface ArtistService {
    
    List<Artist> getAllArtists();
    Optional<Artist> getArtistById(Long id);
    Artist createArtist(Artist artist);
    Artist updateArtist(Long id, Artist artist);
    void deleteArtist(Long id);
    List<Song> getArtistSongs(Long id);
    List<Album> getArtistAlbums(Long id);
} 