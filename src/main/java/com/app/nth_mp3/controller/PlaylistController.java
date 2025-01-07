package com.app.nth_mp3.controller;

import com.app.nth_mp3.model.Playlist;
import com.app.nth_mp3.model.User;
import com.app.nth_mp3.security.UserDetailsImpl;
import com.app.nth_mp3.service.PlaylistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/playlists")
public class PlaylistController {

    @Autowired
    private PlaylistService playlistService;

    // API lấy tất cả playlist
    @GetMapping("/list")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Playlist>> getAllPlaylists() {
        try {
            List<Playlist> playlists = playlistService.getAllPlaylists();
            return new ResponseEntity<>(playlists, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy playlist theo id
    @GetMapping("/get-by/{id}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<Playlist> getPlaylistById(@PathVariable Long id) {
        try {
            return playlistService.getPlaylistById(id)
                    .map(playlist -> new ResponseEntity<>(playlist, HttpStatus.OK))
                    .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API tạo playlist mới
    @PostMapping("/create")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<?> createPlaylist(@RequestBody Playlist playlist, Authentication authentication) {
        try {
            // Debug log
            System.out.println("Authentication: " + authentication);
            
            if (authentication == null) {
                return new ResponseEntity<>("User not authenticated", HttpStatus.UNAUTHORIZED);
            }

            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            System.out.println("User ID: " + userDetails.getId());
            
            // Set user trực tiếp
            User user = new User();
            user.setId(userDetails.getId());
            playlist.setUser(user);

            Playlist createdPlaylist = playlistService.createPlaylist(playlist);
            return new ResponseEntity<>(createdPlaylist, HttpStatus.CREATED);
        } catch (Exception e) {
            System.out.println("Error creating playlist: " + e.getMessage());
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    // API cập nhật playlist
    @PutMapping("/update/{id}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<Playlist> updatePlaylist(@PathVariable Long id, @RequestBody Playlist playlist) {
        try {
            Playlist updatedPlaylist = playlistService.updatePlaylist(id, playlist);
            return new ResponseEntity<>(updatedPlaylist, HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API xóa playlist
    @DeleteMapping("/delete/{id}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<HttpStatus> deletePlaylist(@PathVariable Long id) {
        try {
            playlistService.deletePlaylist(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy playlist theo user id
    @GetMapping("/user/id/{userId}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<List<Playlist>> getPlaylistsByUserId(@PathVariable Long userId) {
        try {
            // Thêm log để debug
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            System.out.println("Current user roles: " + auth.getAuthorities());
            System.out.println("Is user authenticated: " + auth.isAuthenticated());
            
            List<Playlist> playlists = playlistService.getPlaylistsByUserId(userId);
            return new ResponseEntity<>(playlists, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace(); // In ra stack trace để debug
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy playlist theo username 
    @GetMapping("/user/name/{username}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<List<Playlist>> getPlaylistsByUsername(@PathVariable String username) {   
        try {
            List<Playlist> playlists = playlistService.getPlaylistsByUsername(username);
            return new ResponseEntity<>(playlists, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API lấy các playlist công khai
    @GetMapping("/public")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")    
    public ResponseEntity<List<Playlist>> getPublicPlaylists() {
        try {
            List<Playlist> playlists = playlistService.getPublicPlaylists();
            return new ResponseEntity<>(playlists, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // API chuyển đổi trạng thái công khai/riêng tư
    @PutMapping("/toggle-visibility/{id}")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<HttpStatus> togglePlaylistVisibility(@PathVariable Long id) {
        try {
            playlistService.togglePlaylistVisibility(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
} 