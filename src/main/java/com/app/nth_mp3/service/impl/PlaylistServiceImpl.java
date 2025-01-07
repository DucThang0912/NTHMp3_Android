package com.app.nth_mp3.service.impl;

import com.app.nth_mp3.model.Playlist;
import com.app.nth_mp3.repository.PlaylistRepository;
import com.app.nth_mp3.service.PlaylistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PlaylistServiceImpl implements PlaylistService {

    @Autowired
    private PlaylistRepository playlistRepository;

    // Lấy tất cả playlist
    @Override
    public List<Playlist> getAllPlaylists() {
        return playlistRepository.findAll();
    }

    // Lấy playlist theo id
    @Override
    public Optional<Playlist> getPlaylistById(Long id) {
        return playlistRepository.findById(id);
    }

    // Tạo playlist
    @Override
    public Playlist createPlaylist(Playlist playlist) {
        // Kiểm tra xem playlist name đã tồn tại chưa
        boolean nameExists = playlistRepository.existsByNameAndUserId(
            playlist.getName(), 
            playlist.getUser().getId()
        );
        
        if (nameExists) {
            throw new RuntimeException("Playlist với tên này đã tồn tại!");
        }
        
        return playlistRepository.save(playlist);
    }

    // Cập nhật playlist
    @Override
    public Playlist updatePlaylist(Long id, Playlist playlistDetails) {
        Playlist playlist = playlistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy playlist với id: " + id));

        playlist.setName(playlistDetails.getName());
        playlist.setDescription(playlistDetails.getDescription());
        playlist.setPublic(playlistDetails.isPublic());

        return playlistRepository.save(playlist);
    }

    // Xóa playlist
    @Override
    public void deletePlaylist(Long id) {
        Playlist playlist = playlistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy playlist với id: " + id));
        playlistRepository.delete(playlist);
    }

    // Lấy playlist theo id người dùng
    @Override
    public List<Playlist> getPlaylistsByUserId(Long userId) {
        return playlistRepository.findByUserId(userId);
    }

    // Lấy playlist theo username
    @Override
    public List<Playlist> getPlaylistsByUsername(String username) {
        return playlistRepository.findByUser_Username(username);
    }

    // Lấy playlist công khai
    @Override
    public List<Playlist> getPublicPlaylists() {
        return playlistRepository.findByIsPublicTrue();
    }

    // Chuyển đổi tính công khai của playlist
    @Override
    public void togglePlaylistVisibility(Long id) {
        Playlist playlist = playlistRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy playlist với id: " + id));
        playlist.setPublic(!playlist.isPublic());
        playlistRepository.save(playlist);
    }
} 