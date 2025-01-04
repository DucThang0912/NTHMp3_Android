package com.app.nth_mp3.service;

import java.util.List;
import java.util.Optional;

import com.app.nth_mp3.model.User;

public interface UserService {
    List<User> getAllUsers();
    Optional<User> getUserByUsername(String username);
    Optional<User> getUserByEmail(String email);
    User createUser(User user);
    User updateUser(Long id, User user);
    void deleteUser(Long id);
    void changePassword(Long userId, String oldPassword, String newPassword);
    void updateProfile(Long userId, User updatedUser);
} 