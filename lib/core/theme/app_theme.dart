import 'package:flutter/material.dart';

class AppTheme {
  // Colors - Matrix Hacker Dark Theme
  static const Color primaryColor = Color(0xFF00FF00); // Neon Green
  static const Color secondaryColor = Color(0xFF0088FF); // Neon Blue
  static const Color backgroundColor = Color(0xFF0A0E27); // Dark Blue Black
  static const Color surfaceColor = Color(0xFF1A1F3A); // Slightly lighter dark
  static const Color textPrimaryColor = Color(0xFF00FF00); // Neon Green
  static const Color textSecondaryColor = Color(0xFF00CCAA); // Cyan Green
  static const Color errorColor = Color(0xFFFF0055); // Neon Pink
  static const Color successColor = Color(0xFF00FF88); // Bright Green
  static const Color warningColor = Color(0xFFFFAA00); // Orange

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      dialogBackgroundColor: surfaceColor,
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          letterSpacing: 2,
        ),
        displayMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
          letterSpacing: 1.5,
        ),
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
          letterSpacing: 1,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: textSecondaryColor,
          letterSpacing: 0.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: textSecondaryColor,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
          letterSpacing: 1,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: textPrimaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: textPrimaryColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: errorColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: errorColor,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: textSecondaryColor,
          letterSpacing: 0.5,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF666688),
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
          shadowColor: primaryColor,
          elevation: 8,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
