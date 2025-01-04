package com.app.nth_mp3.controller;

import com.app.nth_mp3.model.User;
import com.app.nth_mp3.service.UserService;

import jakarta.validation.Valid;

import com.app.nth_mp3.exception.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@Slf4j
public class UserController {

    @Autowired
    private UserService userService;

    // Lấy tất cả người dùng
    @GetMapping("/list")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    // Tìm theo username
    @GetMapping("/username/{username}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        return userService.getUserByUsername(username)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Tìm theo email
    @GetMapping("/email/{email}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
        return userService.getUserByEmail(email)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Tạo người dùng mới
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> createUser(@Valid @RequestBody User user) {
        try {
            User newUser = userService.createUser(user);
            return ResponseEntity.ok(newUser);
        } catch (DuplicateResourceException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // Cập nhật người dùng
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @Valid @RequestBody User user) {
        try {
            User updatedUser = userService.updateUser(id, user);
            return ResponseEntity.ok(updatedUser);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (DuplicateResourceException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // Xóa người dùng
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.ok().build();
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Đổi mật khẩu
    @PutMapping("/{id}/change-password")
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<Void> changePassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> passwords) {
        try {
            userService.changePassword(id, 
                passwords.get("oldPassword"), 
                passwords.get("newPassword"));
            return ResponseEntity.ok().build();
        } catch (ResourceNotFoundException | InvalidPasswordException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // Cập nhật thông tin cá nhân
    @PutMapping("/{id}/profile")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<Void> updateProfile(
            @PathVariable Long id,
            @Valid @RequestBody User user) {
        try {
            userService.updateProfile(id, user);
            return ResponseEntity.ok().build();
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
} 