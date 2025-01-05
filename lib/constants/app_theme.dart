import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class AppTheme {
  static String encodeVietnamese(String text) {
    return utf8.decode(utf8.encode(text));
  }

  static TextStyle _createTextStyle(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontFeatures: [
        const FontFeature.enable('kern'),
        const FontFeature.enable('liga'),
        const FontFeature.enable('dlig'),
      ],
    );
  }

  static TextTheme textTheme = TextTheme(
    displayLarge: _createTextStyle(TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32,
      letterSpacing: -0.5,
    )),
    displayMedium: _createTextStyle(TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
    )),
    displaySmall: _createTextStyle(TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
    )),
    headlineLarge: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: 0.15,
    )),
    headlineMedium: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
    )),
    headlineSmall: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    )),
    titleLarge: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      letterSpacing: 0.15,
    )),
    titleMedium: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 0.1,
    )),
    titleSmall: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: 0.1,
    )),
    bodyLarge: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 0.5,
    )),
    bodyMedium: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 0.25,
    )),
    bodySmall: _createTextStyle(TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 0.4,
    )),
  );
}