package com.app.nth_mp3.service.impl;

import com.app.nth_mp3.model.Playlist;
import com.app.nth_mp3.model.PlaylistSong;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.repository.PlaylistRepository;
import com.app.nth_mp3.repository.PlaylistSongRepository;
import com.app.nth_mp3.repository.SongRepository;
import com.app.nth_mp3.service.PlaylistSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PlaylistSongServiceImpl implements PlaylistSongService {

    @Autowired
    private PlaylistSongRepository playlistSongRepository;
    
    @Autowired
    private PlaylistRepository playlistRepository;
    
    @Autowired
    private SongRepository songRepository;

    // Thêm bài hát vào playlist
    @Override
    @Transactional
    public PlaylistSong addSongToPlaylist(Long playlistId, Long songId) {
        // Kiểm tra xem bài hát đã có trong playlist chưa
        if (playlistSongRepository.existsByPlaylistIdAndSongId(playlistId, songId)) {
            throw new RuntimeException("Bài hát đã tồn tại trong playlist");
        }

        Playlist playlist = playlistRepository.findById(playlistId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy playlist"));
        
        Song song = songRepository.findById(songId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài hát"));

        PlaylistSong playlistSong = new PlaylistSong();
        playlistSong.setPlaylist(playlist);
        playlistSong.setSong(song);

        return playlistSongRepository.save(playlistSong);
    }

    // Xóa bài hát khỏi playlist
    @Override
    @Transactional
    public void removeSongFromPlaylist(Long playlistId, Long songId) {
        playlistSongRepository.deleteByPlaylistIdAndSongId(playlistId, songId);
    }

    // Lấy danh sách bài hát trong playlist
    @Override
    public List<Song> getSongsInPlaylist(Long playlistId) {
        return playlistSongRepository.findByPlaylistId(playlistId)
                .stream()
                .map(PlaylistSong::getSong)
                .collect(Collectors.toList());
    }

    // Kiểm tra bài hát có tồn tại trong playlist không
    @Override
    public boolean isSongInPlaylist(Long playlistId, Long songId) {
        return playlistSongRepository.existsByPlaylistIdAndSongId(playlistId, songId);
    }
} 