package com.app.nth_mp3.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SocialUserInfo {
    private String id;
    private String email;
    private String name;
    private String picture;
    private String firstName;
    private String lastName;
} 