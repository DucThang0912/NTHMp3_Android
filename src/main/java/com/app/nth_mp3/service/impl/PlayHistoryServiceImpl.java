package com.app.nth_mp3.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Date;
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
    public Playhistory addToHistory(Long userId, String spotifyId) {
        // Kiểm tra user tồn tại
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));
            
        // Kiểm tra bài hát tồn tại bằng spotifyId
        Song song = songRepository.findBySpotifyId(spotifyId)
            .orElseThrow(() -> new RuntimeException("Song not found"));

        // Kiểm tra bài hát đã tồn tại trong lịch sử nghe chưa
        boolean historyExists = playHistoryRepository
            .existsByUserIdAndSongIdAndType(userId, song.getId(), Playhistory.HistoryType.PLAY);
            
        // Kiểm tra title đã tồn tại chưa
        boolean titleExists = playHistoryRepository.existsByUserIdAndType(userId, Playhistory.HistoryType.PLAY)
            && playHistoryRepository.findByUserIdAndType(userId, Playhistory.HistoryType.PLAY).stream()
            .anyMatch(h -> h.getSong().getTitle().equals(song.getTitle()));

        if (historyExists) {
            // Nếu đã tồn tại trong lịch sử -> cập nhật updateDate
            Playhistory existingHistory = playHistoryRepository
                .findByUserIdAndSongIdAndType(userId, song.getId(), Playhistory.HistoryType.PLAY);
            existingHistory.setUpdatedDate(new Date());
            return playHistoryRepository.save(existingHistory);
        } else if (titleExists) {
            // Nếu title đã tồn tại -> không thêm mới
            return null;
        } else {
            // Nếu chưa tồn tại -> thêm mới
            Playhistory history = new Playhistory();
            history.setUser(user);
            history.setSong(song);
            history.setType(Playhistory.HistoryType.PLAY);
            return playHistoryRepository.save(history);
        }
    }

    // Lấy lịch sử nghe của người dùng
    @Override
    public List<Playhistory> getUserHistory(Long userId) {
        return playHistoryRepository.findByUserIdAndTypeOrderByCreatedDateDesc(userId, Playhistory.HistoryType.PLAY);
    }

    // Xóa lịch sử nghe của người dùng
    @Override
    public void clearHistory(Long userId) {
        playHistoryRepository.deleteByUserId(userId);
    }

    // ---------------------------------------------FAVORITE----------------------------------------------

    // Lấy danh sách yêu thích
    @Override
    public List<Playhistory> getFavorites(Long userId) {
        return playHistoryRepository.findByUserIdAndType(userId, Playhistory.HistoryType.FAVORITE);
    }

    // Toggle yêu thích (thêm/xóa)
    @Transactional
    public boolean toggleFavorite(Long userId, String spotifyId) {
        // Kiểm tra xem bài hát có tồn tại không
        Song song = songRepository.findBySpotifyId(spotifyId)
            .orElseThrow(() -> new RuntimeException("Song not found"));
        
        // Kiểm tra xem bài hát đã tồn tại trong favorites chưa
        boolean isFavorited = playHistoryRepository
            .existsByUserIdAndSongIdAndType(userId, song.getId(), Playhistory.HistoryType.FAVORITE);
            
        // Kiểm tra title đã tồn tại chưa
        boolean titleExists = playHistoryRepository.existsByUserIdAndType(userId, Playhistory.HistoryType.FAVORITE)
            && playHistoryRepository.findByUserIdAndType(userId, Playhistory.HistoryType.FAVORITE).stream()
            .anyMatch(h -> h.getSong().getTitle().equals(song.getTitle()));

        if (isFavorited) {
            // Nếu đã yêu thích -> xóa
            playHistoryRepository.deleteByUserIdAndSongIdAndType(
                userId, song.getId(), Playhistory.HistoryType.FAVORITE);
            return false;
        } else if (titleExists) {
            // Nếu title đã tồn tại -> không thêm mới
            return true;
        } else {
            // Nếu chưa yêu thích và title chưa tồn tại -> thêm mới
            User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

            Playhistory history = new Playhistory();
            history.setUser(user);
            history.setSong(song);
            history.setType(Playhistory.HistoryType.FAVORITE);
            playHistoryRepository.save(history);
            return true;
        }
    }

}
