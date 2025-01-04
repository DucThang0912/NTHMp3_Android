package com.app.nth_mp3.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestTemplateConfig {
    
    // RestTemplate là một lớp cung cấp các phương thức để gửi và nhận các yêu cầu HTTP.
    // Nó được sử dụng để gửi các yêu cầu HTTP đến các API khác nhau.
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
} 