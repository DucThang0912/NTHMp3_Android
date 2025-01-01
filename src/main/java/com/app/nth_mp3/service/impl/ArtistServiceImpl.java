package com.app.nth_mp3.service.impl;

import com.app.nth_mp3.model.Artist;
import com.app.nth_mp3.model.Album;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.repository.ArtistRepository;
import com.app.nth_mp3.service.ArtistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ArtistServiceImpl implements ArtistService {

    @Autowired
    private ArtistRepository artistRepository;

    // Lấy tất cả nghệ sĩ
    @Override
    public List<Artist> getAllArtists() {
        return artistRepository.findAll();
    }

    // Lấy nghệ sĩ theo id
    @Override
    public Optional<Artist> getArtistById(Long id) {
        return artistRepository.findById(id);
    }

    // Tạo nghệ sĩ
    @Override
    public Artist createArtist(Artist artist) {
        return artistRepository.save(artist);
    }

    // Cập nhật nghệ sĩ
    @Override
    public Artist updateArtist(Long id, Artist artistDetails) {
        Artist artist = artistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nghệ sĩ với id: " + id));

        artist.setName(artistDetails.getName());
        artist.setBio(artistDetails.getBio());
        artist.setAvatarUrl(artistDetails.getAvatarUrl());

        return artistRepository.save(artist);
    }

    // Xóa nghệ sĩ
    @Override
    public void deleteArtist(Long id) {
        Artist artist = artistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nghệ sĩ với id: " + id));
        artistRepository.delete(artist);
    }

    // Lấy bài hát theo id của nghệ sĩ
    @Override
    public List<Song> getArtistSongs(Long id) {
        Artist artist = artistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nghệ sĩ với id: " + id));
        return artist.getSongs();
    }

    // Lấy album theo id của nghệ sĩ
    @Override
    public List<Album> getArtistAlbums(Long id) {
        Artist artist = artistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nghệ sĩ với id: " + id));
        return artist.getAlbums();
    }
} 