import 'package:flutter/material.dart';

class AppColors {
  // Màu chính
  static const Color primary = Color(0xFFB16CEA);
  static const Color background = Color(0xFF17153C);
  static const Color surface = Color(0xFF2B1F5C);
  static const Color accent = Color(0xFFFF5E69);
  
  // Gradient chính
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF17153C), // Tím đậm
      Color(0xFF2B1F5C), // Tím nhạt
    ],
  );

  // Gradient cho buttons
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFFB16CEA), // Tím nhạt
      Color(0xFFFF5E69), // Hồng
      Color(0xFFFF8A56), // Cam
      Color(0xFFFFA84B), // Vàng cam
    ],
  );

  // Màu cho text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textHint = Colors.grey;

  // Màu cho các hiệu ứng
  static const Map<String, Color> glowColors = {
    'purple': Color(0xFF9C27B0),
    'blue': Color(0xFF2196F3),
    'pink': Color(0xFFE91E63),
  };
} 