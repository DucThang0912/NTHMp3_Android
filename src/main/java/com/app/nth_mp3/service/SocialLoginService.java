package com.app.nth_mp3.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.nth_mp3.dto.SocialUserInfo;
import com.app.nth_mp3.exception.OAuth2AuthenticationException;
import com.app.nth_mp3.model.SocialProvider;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;

import java.util.Collections;
import java.util.Arrays;


@Service
@Slf4j
public class SocialLoginService {

    @Value("${google.client.android-id}")
    private String androidClientId;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String webClientId;

    private GoogleIdTokenVerifier verifier;

    @PostConstruct
    public void init() throws Exception {
        NetHttpTransport transport = GoogleNetHttpTransport.newTrustedTransport();
        this.verifier = new GoogleIdTokenVerifier.Builder(transport, GsonFactory.getDefaultInstance())
            .setAudience(Arrays.asList(androidClientId, webClientId))
            .build();
    }

    public SocialUserInfo verifyToken(String idToken, SocialProvider provider) {
        if (provider == SocialProvider.GOOGLE) {
            return verifyGoogleToken(idToken);
        }
        throw new OAuth2AuthenticationException("Unsupported provider");
    }

    public SocialUserInfo verifyGoogleToken(String idToken) throws OAuth2AuthenticationException {
        try {
            log.debug("Verifying token with client ID: {}", androidClientId);
            
            GoogleIdToken googleIdToken = verifier.verify(idToken);
            if (googleIdToken == null) {
                log.error("Token verification failed. Token is null");
                throw new OAuth2AuthenticationException("Invalid ID token");
            }
            
            GoogleIdToken.Payload payload = googleIdToken.getPayload();
            
            log.debug("Token payload - aud: {}, azp: {}, iss: {}", 
                payload.getAudience(), 
                payload.getAuthorizedParty(),
                payload.getIssuer());
            
            return new SocialUserInfo(
                payload.getEmail(),
                (String) payload.get("name"),
                (String) payload.get("picture")
            );
        } catch (Exception e) {
            log.error("Token verification failed: {}", e.getMessage(), e);
            throw new OAuth2AuthenticationException("Token verification failed: " + e.getMessage());
        }
    }
} 