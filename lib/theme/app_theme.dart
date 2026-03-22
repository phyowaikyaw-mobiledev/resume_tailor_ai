import 'package:flutter/material.dart';

class AppColors {
  // Deep dark background with warm undertones
  static const Color background = Color(0xFF0D0D12);
  static const Color surface = Color(0xFF15151E);
  static const Color surfaceElevated = Color(0xFF1C1C28);
  static const Color surfaceBorder = Color(0xFF2A2A38);

  // Accent - electric cyan/teal
  static const Color accent = Color(0xFF00E5C8);
  static const Color accentDim = Color(0xFF00E5C820);
  static const Color accentMid = Color(0xFF00E5C850);

  // Secondary accent - warm gold
  static const Color gold = Color(0xFFFFB547);
  static const Color goldDim = Color(0xFFFFB54720);

  // Text
  static const Color textPrimary = Color(0xFFF0F0F8);
  static const Color textSecondary = Color(0xFFCCCCDD);
  static const Color textMuted = Color(0xFF4A4A62);

  // Gradient colors
  static const Color gradientStart = Color(0xFF00E5C8);
  static const Color gradientEnd = Color(0xFF0066FF);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      fontFamily: 'Courier',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
        labelSmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
