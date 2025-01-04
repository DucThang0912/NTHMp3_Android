package com.app.nth_mp3.dto;

import com.app.nth_mp3.model.SocialProvider;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SocialLoginRequest {
    private String accessToken; // token truy cập
    private SocialProvider provider; // nhà cung cấp
} 