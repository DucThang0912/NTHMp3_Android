package com.app.nth_mp3.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import jakarta.transaction.Transactional;
import com.app.nth_mp3.model.Playhistory;
import com.app.nth_mp3.model.User;
import com.app.nth_mp3.model.Song;
import com.app.nth_mp3.repository.PlayHistoryRepository;
import com.app.nth_mp3.repository.UserRepository;
import com.app.nth_mp3.repository.SongRepository;
import com.app.nth_mp3.service.PlayHistoryService;

@Service
@Transactional
public class PlayHistoryServiceImpl implements PlayHistoryService {
    
    @Autowired
    private PlayHistoryRepository playHistoryRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private SongRepository songRepository;

    // Thêm bài hát vào lịch sử nghe
    @Override
    @Transactional
    public Playhistory addToHistory(Long userId, Long songId) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
            
        Song song = songRepository.findById(songId)
            .orElseThrow(() -> new RuntimeException("Song not found"));

        Playhistory history = new Playhistory();
        history.setUser(user);
        history.setSong(song);
        history.setType(Playhistory.HistoryType.PLAY);
        
        return playHistoryRepository.save(history);
    }

    // Lấy lịch sử nghe của người dùng
    @Override
    public List<Playhistory> getUserHistory(Long userId) {
        return playHistoryRepository.findByUserIdOrderByCreatedDateDesc(userId);
    }

    // Xóa lịch sử nghe của người dùng
    @Override
    public void clearHistory(Long userId) {
        playHistoryRepository.deleteByUserId(userId);
    }

    // ---------------------------------------------FAVORITE----------------------------------------------

    // Lấy danh sách yêu thích
    public List<Playhistory> getFavorites(Long userId) {
        return playHistoryRepository.findByUserIdAndType(userId, Playhistory.HistoryType.FAVORITE);
    }

    // Toggle yêu thích (thêm/xóa)
    @Transactional
    public boolean toggleFavorite(Long userId, Long songId) {
        boolean isFavorited = playHistoryRepository
            .existsByUserIdAndSongIdAndType(userId, songId, Playhistory.HistoryType.FAVORITE);
            
        if (isFavorited) {
            // Nếu đã yêu thích -> xóa
            playHistoryRepository.deleteByUserIdAndSongIdAndType(
                userId, songId, Playhistory.HistoryType.FAVORITE);
            return false;
        } else {
            // Nếu chưa yêu thích -> thêm mới
            User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
                
            Song song = songRepository.findById(songId)
                .orElseThrow(() -> new RuntimeException("Song not found"));

            Playhistory history = new Playhistory();
            history.setUser(user);
            history.setSong(song);
            history.setType(Playhistory.HistoryType.FAVORITE);
            playHistoryRepository.save(history);
            return true;
        }
    }

}
