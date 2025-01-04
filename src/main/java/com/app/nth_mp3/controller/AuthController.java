package com.app.nth_mp3.controller;

import com.app.nth_mp3.dto.JwtResponse;
import com.app.nth_mp3.dto.LoginRequest;
import com.app.nth_mp3.dto.SignupRequest;
import com.app.nth_mp3.dto.SocialLoginRequest;
import com.app.nth_mp3.dto.SocialUserInfo;
import com.app.nth_mp3.model.Role;
import com.app.nth_mp3.model.User;
import com.app.nth_mp3.repository.RoleRepository;
import com.app.nth_mp3.repository.UserRepository;
import com.app.nth_mp3.security.JwtUtils;
import com.app.nth_mp3.security.UserDetailsImpl;
import com.app.nth_mp3.service.SocialLoginService;

import jakarta.validation.Valid;

import com.app.nth_mp3.exception.OAuth2AuthenticationException;
import com.app.nth_mp3.dto.MessageResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import java.util.UUID;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/auth")
@Slf4j
public class AuthController {

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    SocialLoginService socialLoginService;
    @Autowired
    RoleRepository roleRepository;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    // API đăng nhập
    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);
        
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        String role = userDetails.getAuthorities().stream()
                .findFirst()
                .map(item -> item.getAuthority())
                .orElse("ROLE_USER"); // Nếu không tìm thấy role, sẽ mặc định là ROLE_USER

        return ResponseEntity.ok(new JwtResponse(jwt,
                                             userDetails.getId(), 
                                             userDetails.getUsername(), 
                                             userDetails.getEmail(), 
                                             role));
    }

    // API đăng ký
    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@RequestBody SignupRequest signUpRequest) {
        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body("Error: Username is already taken!");
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body("Error: Email is already in use!");
        }

        // Create new user account
        User user = new User();
        user.setUsername(signUpRequest.getUsername());
        user.setEmail(signUpRequest.getEmail());
        user.setPassword(encoder.encode(signUpRequest.getPassword()));

        Role userRole = roleRepository.findByName("ROLE_USER") 
                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
        user.setRole(userRole);

        userRepository.save(user);

        return ResponseEntity.ok("User registered successfully!");
    }

    @PostMapping("/social/login")
    public ResponseEntity<?> socialLogin(@Valid @RequestBody SocialLoginRequest request) {
        try {
            // Xác thực token và lấy thông tin user
            SocialUserInfo socialUser = socialLoginService.verifyToken(
                request.getAccessToken(), 
                request.getProvider()
            );
            
            // Tìm user theo email
            User user = userRepository.findByEmail(socialUser.getEmail())
                .orElseGet(() -> {
                    // Tạo user mới nếu chưa tồn tại
                    User newUser = new User();
                    newUser.setEmail(socialUser.getEmail());
                    newUser.setUsername(generateUsername(socialUser.getEmail())); 
                    newUser.setFullName(socialUser.getName());
                    newUser.setAvatar(socialUser.getPicture());
                    
                    // Tạo mật khẩu ngẫu nhiên cho tài khoản social
                    String randomPassword = UUID.randomUUID().toString();
                    newUser.setPassword(encoder.encode(randomPassword));
                    
                    // Gán role mặc định
                    Role userRole = roleRepository.findByName("ROLE_USER")
                        .orElseThrow(() -> new RuntimeException("Error: Role not found"));
                    newUser.setRole(userRole);
                    
                    return userRepository.save(newUser);
                });

            // Tạo JWT token
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword())
            );
            
            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = jwtUtils.generateJwtToken(authentication);
            
            return ResponseEntity.ok(new JwtResponse(jwt,
                    user.getId(),
                    user.getUsername(),
                    user.getEmail(),
                    user.getRole().getName()));
                
        } catch (OAuth2AuthenticationException e) {
            log.error("Social login failed", e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new MessageResponse("Error: Invalid social token"));
        } catch (Exception e) {
            log.error("Social login error", e);
            return ResponseEntity.badRequest()
                .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    private String generateUsername(String email) {
        // Tạo username từ email, thêm số ngẫu nhiên nếu trùng
        String baseUsername = email.split("@")[0];
        String username = baseUsername;
        int counter = 1;
        
        while (userRepository.existsByUsername(username)) {
            username = baseUsername + counter++;
        }
        
        return username;
    }
} 