package com.app.nth_mp3.config;

import com.app.nth_mp3.model.Role;
import com.app.nth_mp3.repository.RoleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import java.util.Arrays;
import java.util.List;

@Component
@Order(1)
public class RoleDataInitializer implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Override
    public void run(String... args) {
        // Danh sách các role
        List<String> roleNames = Arrays.asList(
            "ROLE_ADMIN",      // Quản trị viên
            "ROLE_USER",            // Người dùng 
            "ROLE_ARTIST",          // Nghệ sĩ
            "ROLE_PREMIUM"          // Người dùng premium
        );

        // Kiểm tra và thêm từng role
        for (String name : roleNames) {
            if (!roleRepository.existsByName(name)) {
                Role role = new Role();
                role.setName(name);
                roleRepository.save(role);
            }
        }
    }
} 