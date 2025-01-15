package com.app.nth_mp3.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import com.app.nth_mp3.service.PlayHistoryService;
import com.app.nth_mp3.model.Playhistory;
import com.app.nth_mp3.security.UserDetailsImpl;

@RestController
@RequestMapping("/api/history")
public class PlayHistoryController {

    @Autowired
    private PlayHistoryService playHistoryService;

    // Thêm bài hát vào lịch sử nghe (ADMIN, USER)
    @PostMapping("/add/{spotifyId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> addToHistory(
            @PathVariable String spotifyId,
            Authentication authentication) {
        try {
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            Playhistory history = playHistoryService.addToHistory(userDetails.getId(), spotifyId);
            return ResponseEntity.ok(history);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // Lấy lịch sử nghe của người dùng
    @GetMapping("/user")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> getUserHistory(Authentication authentication) {
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        return ResponseEntity.ok(playHistoryService.getUserHistory(userDetails.getId()));
    }

    // Xóa lịch sử nghe của người dùng
    @DeleteMapping("/clear")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> clearHistory(Authentication authentication) {
        try {
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            playHistoryService.clearHistory(userDetails.getId());
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // API toggle yêu thích
    @PostMapping("/favorite/toggle/{spotifyId}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> toggleFavorite(
            @PathVariable String spotifyId,
            Authentication authentication) {
        try {
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            boolean isFavorited = playHistoryService.toggleFavorite(userDetails.getId(), spotifyId);
            return ResponseEntity.ok(isFavorited);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // API lấy danh sách yêu thích
    @GetMapping("/favorites")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> getFavorites(Authentication authentication) {
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        return ResponseEntity.ok(playHistoryService.getFavorites(userDetails.getId()));
    }
    
}
