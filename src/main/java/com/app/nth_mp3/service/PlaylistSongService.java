package com.app.nth_mp3.service;

import com.app.nth_mp3.model.PlaylistSong;
import com.app.nth_mp3.model.Song;
import java.util.List;

public interface PlaylistSongService {
    // Thêm bài hát vào playlist
    PlaylistSong addSongToPlaylist(Long playlistId, Long songId);
    
    // Xóa bài hát khỏi playlist
    void removeSongFromPlaylist(Long playlistId, Long songId);
    
    // Lấy danh sách bài hát trong playlist
    List<Song> getSongsInPlaylist(Long playlistId);
    
    // Kiểm tra bài hát có tồn tại trong playlist không
    boolean isSongInPlaylist(Long playlistId, Long songId);
} 