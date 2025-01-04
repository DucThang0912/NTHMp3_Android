package com.app.nth_mp3.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import com.app.nth_mp3.exception.DuplicateResourceException;
import com.app.nth_mp3.exception.InvalidPasswordException;
import com.app.nth_mp3.exception.ResourceNotFoundException;
import com.app.nth_mp3.model.User;
import com.app.nth_mp3.repository.UserRepository;
import com.app.nth_mp3.service.UserService;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Lấy tất cả người dùng
    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Lấy người dùng theo username
    @Override
    public Optional<User> getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    // Lấy người dùng theo email
    @Override
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // Tạo người dùng mới
    @Override
    public User createUser(User user) {
        // Kiểm tra username và email đã tồn tại chưa
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new DuplicateResourceException("Username đã tồn tại");
        }
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new DuplicateResourceException("Email đã tồn tại");
        }

        // Mã hóa mật khẩu trước khi lưu
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    // Cập nhật người dùng
    @Override
    public User updateUser(Long id, User updatedUser) {
        User existingUser = userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy user"));

        // Kiểm tra username mới có bị trùng không
        if (!existingUser.getUsername().equals(updatedUser.getUsername()) 
            && userRepository.existsByUsername(updatedUser.getUsername())) {
            throw new DuplicateResourceException("Username đã tồn tại");
        }

        // Kiểm tra email mới có bị trùng không
        if (!existingUser.getEmail().equals(updatedUser.getEmail()) 
            && userRepository.existsByEmail(updatedUser.getEmail())) {
            throw new DuplicateResourceException("Email đã tồn tại");
        }

        // Cập nhật thông tin
        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setEmail(updatedUser.getEmail());
        
        // Chỉ cập nhật password nếu có password mới
        if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) {
            existingUser.setPassword(passwordEncoder.encode(updatedUser.getPassword()));
        }

        return userRepository.save(existingUser);
    }

    // Xóa người dùng
    @Override
    public void deleteUser(Long id) {
        if (!userRepository.existsById(id)) {
            throw new ResourceNotFoundException("Không tìm thấy user");
        }
        userRepository.deleteById(id);
    }


    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy user"));

        // Kiểm tra mật khẩu cũ
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new InvalidPasswordException("Mật khẩu cũ không đúng");
        }

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    @Override
    public void updateProfile(Long userId, User updatedUser) {
        User existingUser = userRepository.findById(userId)
            .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy user"));

        // Chỉ cho phép cập nhật một số thông tin cá nhân
        existingUser.setEmail(updatedUser.getEmail());
        existingUser.setFullName(updatedUser.getFullName());
        existingUser.setPhone(updatedUser.getPhone());
        existingUser.setLocation(updatedUser.getLocation());

        userRepository.save(existingUser);
    }
} 