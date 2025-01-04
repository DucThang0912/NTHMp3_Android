package com.app.nth_mp3.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.app.nth_mp3.dto.SocialUserInfo;
import com.app.nth_mp3.exception.OAuth2AuthenticationException;
import com.app.nth_mp3.model.SocialProvider;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;

import java.util.Collections;
import java.util.Map;

@Service
@Slf4j
public class SocialLoginService {

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    @Value("${spring.security.oauth2.client.registration.facebook.client-id}")
    private String facebookAppId;

    @Autowired
    private RestTemplate restTemplate;

    public SocialUserInfo verifyToken(String token, SocialProvider provider) {
        try {
            switch (provider) {
                case GOOGLE:
                    return verifyGoogleToken(token);
                case FACEBOOK:
                    return verifyFacebookToken(token);
                default:
                    throw new IllegalArgumentException("Unsupported provider: " + provider);
            }
        } catch (Exception e) {
            log.error("Error verifying social token", e);
            throw new OAuth2AuthenticationException("Failed to verify token", e);
        }
    }

    private SocialUserInfo verifyGoogleToken(String token) {
        try {
            NetHttpTransport transport = GoogleNetHttpTransport.newTrustedTransport();
            GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, GsonFactory.getDefaultInstance())
                    .setAudience(Collections.singletonList(googleClientId))
                    .build();

            GoogleIdToken idToken = verifier.verify(token);
            if (idToken != null) {
                GoogleIdToken.Payload payload = idToken.getPayload();
                
                SocialUserInfo userInfo = new SocialUserInfo();
                userInfo.setId(payload.getSubject());
                userInfo.setEmail(payload.getEmail());
                userInfo.setName((String) payload.get("name"));
                userInfo.setPicture((String) payload.get("picture"));
                userInfo.setFirstName((String) payload.get("given_name"));
                userInfo.setLastName((String) payload.get("family_name"));
                
                return userInfo;
            } else {
                throw new OAuth2AuthenticationException("Invalid ID token");
            }
        } catch (Exception e) {
            log.error("Error verifying Google token", e);
            throw new OAuth2AuthenticationException("Failed to verify Google token", e);
        }
    }

    private SocialUserInfo verifyFacebookToken(String token) {
        String facebookGraphApiUrl = String.format(
            "https://graph.facebook.com/me?fields=id,email,first_name,last_name,name,picture&access_token=%s",
            token);

        try {
            ResponseEntity<Map> response = restTemplate.getForEntity(
                facebookGraphApiUrl, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> fbUser = response.getBody();
                
                SocialUserInfo userInfo = new SocialUserInfo();
                userInfo.setId((String) fbUser.get("id"));
                userInfo.setEmail((String) fbUser.get("email"));
                userInfo.setName((String) fbUser.get("name"));
                userInfo.setFirstName((String) fbUser.get("first_name"));
                userInfo.setLastName((String) fbUser.get("last_name"));
                
                // Xử lý ảnh đại diện từ Facebook
                if (fbUser.containsKey("picture")) {
                    @SuppressWarnings("unchecked")
                    Map<String, Object> picture = (Map<String, Object>) fbUser.get("picture");
                    @SuppressWarnings("unchecked")
                    Map<String, Object> data = (Map<String, Object>) picture.get("data");
                    userInfo.setPicture((String) data.get("url"));
                }
                
                return userInfo;
            } else {
                throw new OAuth2AuthenticationException("Failed to get Facebook user info");
            }
        } catch (Exception e) {
            throw new OAuth2AuthenticationException("Failed to verify Facebook token", e);
        }
    }
} 