package com.app.nth_mp3.exception;
public class OAuth2AuthenticationException extends RuntimeException {
    public OAuth2AuthenticationException(String message) {
        super(message);
    }
    
    public OAuth2AuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
} 