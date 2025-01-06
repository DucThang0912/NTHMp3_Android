package com.app.nth_mp3.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.app.nth_mp3.model.Playhistory;
import java.util.List;

@Repository
public interface PlayHistoryRepository extends JpaRepository<Playhistory, Long> {
    List<Playhistory> findByUserIdOrderByCreatedDateDesc(Long userId);
    void deleteByUserId(Long userId);
    boolean existsByUserIdAndSongIdAndType(Long userId, Long songId, Playhistory.HistoryType type);
    List<Playhistory> findByUserIdAndType(Long userId, Playhistory.HistoryType type);
    void deleteByUserIdAndSongIdAndType(Long userId, Long songId, Playhistory.HistoryType type);
}