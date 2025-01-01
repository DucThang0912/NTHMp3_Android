package com.app.nth_mp3.service.impl;

import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.repository.SongRepository;
import com.app.nth_mp3.service.SongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class SongServiceImpl implements SongService {

    @Autowired
    private SongRepository songRepository;

    // Lấy tất cả bài hát
    @Override
    public List<Song> getAllSongs() {
        return songRepository.findAll();
    }

    // Lấy bài hát theo id
    @Override
    public Optional<Song> getSongById(Long id) {
        return songRepository.findById(id);
    }

    // Tạo bài hát
    @Override
    @Transactional
    public Song createSong(Song song) {
        try {
            song.setPlayCount(0); // Khởi tạo số lần phát = 0
            return songRepository.save(song);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi tạo bài hát: " + e.getMessage());
        }
    }

    // Cập nhật bài hát
    @Override
    @Transactional
    public Song updateSong(Long id, Song songDetails) {
        try {
            Song song = songRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài hát với id: " + id));
            
        song.setTitle(songDetails.getTitle());
        song.setArtist(songDetails.getArtist());
        song.setAlbum(songDetails.getAlbum());
        song.setGenre(songDetails.getGenre());
        song.setDuration(songDetails.getDuration());
        song.setFilePath(songDetails.getFilePath());
        song.setLyrics(songDetails.getLyrics());
            
        return songRepository.save(song);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi cập nhật bài hát: " + e.getMessage());
        }
    }

    // Xóa bài hát
    @Override
    @Transactional
    public void deleteSong(Long id) {
        try {
                songRepository.deleteById(id);
            } catch (Exception e) {
                throw new RuntimeException("Lỗi khi xóa bài hát: " + e.getMessage());
            }
    }

    // Lấy bài hát theo id của nghệ sĩ
    @Override
    public List<Song> getSongsByArtistId(Long artistId) {
        return songRepository.findByArtistId(artistId);
    }

    // Lấy bài hát theo id của album
    @Override
    public List<Song> getSongsByAlbumId(Long albumId) {
        return songRepository.findByAlbumId(albumId);
    }

    // Lấy bài hát theo id của thể loại
    @Override
    public List<Song> getSongsByGenreId(Long genreId) {
        return songRepository.findByGenreId(genreId);
    }

    // Tăng số lần nghe
    @Override
    @Transactional
    public void incrementPlayCount(Long songId) {
        Song song = songRepository.findById(songId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy bài hát với id: " + songId));
        song.setPlayCount(song.getPlayCount() + 1);
        songRepository.save(song);
    }

    // Lấy bài hát được nghe nhiều nhất
    @Override
    public List<Song> getTopPlayedSongs(int limit) {
        return songRepository.findTopByOrderByPlayCountDesc(limit);
    }
} 