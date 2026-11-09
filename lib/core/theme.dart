import 'package:flutter/material.dart';

class HokTheme {
  // Gameland Dark Minimalist Palette (Pitch Black + Electric Neon Lime)
  static const Color darkBackground = Color(0xFF070A07);
  static const Color darkSurface = Color(0xFF0E130E);
  static const Color cardBackground = Color(0xFF121812);
  static const Color cardSubtle = Color(0xFF172017);
  static const Color cardBorder = Color(0xFF223022);
  static const Color cardBorderGlow = Color(0x44A3E635);

  // Neon Lime & Accent Colors (Gameland Vibe)
  static const Color neonLime = Color(
    0xFFD4F82A,
  ); // Electric Lime for active buttons/pills
  static const Color neonLimeLight = Color(0xFFE2F952);
  static const Color limeAccent = Color(
    0xFFA3E635,
  ); // Glowing border & highlights
  static const Color limeMuted = Color(0xFF4D7C0F);

  static const Color darkText = Color(0xFF070A07); // Text on neon lime pills
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Auxiliary
  static const Color redAccent = Color(0xFFEF4444);
  static const Color blueCyan = Color(0xFF38BDF8);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: neonLime,
      cardColor: cardBackground,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: neonLime,
        secondary: limeAccent,
        surface: cardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardSubtle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonLime, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
        hintStyle: const TextStyle(color: textMuted, fontSize: 13),
      ),
    );
  }
}
