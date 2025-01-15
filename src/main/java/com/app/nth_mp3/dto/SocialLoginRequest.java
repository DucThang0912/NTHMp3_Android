package com.app.nth_mp3.dto;

import com.app.nth_mp3.model.SocialProvider;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SocialLoginRequest {
    private String idToken;  // Đổi từ accessToken sang idToken
    private SocialProvider provider;
} 