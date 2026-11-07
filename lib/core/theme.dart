import 'package:flutter/material.dart';

class HokTheme {
  static const Color darkBackground = Color(0xFF0C1322);
  static const Color cardBackground = Color(0xFF142038);
  static const Color cardSubtle = Color(0xFF1B2B4C);
  static const Color cardBorder = Color(0xFF263C68);

  static const Color goldAccent = Color(0xFFF39C12);
  static const Color goldLight = Color(0xFFF9E79F);
  static const Color blueCyan = Color(0xFF00D2FF);
  static const Color blueAccent = Color(0xFF3498DB);
  static const Color greenAccent = Color(0xFF2ECC71);
  static const Color redAccent = Color(0xFFE74C3C);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: blueCyan,
      cardColor: cardBackground,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0E1728),
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
        primary: blueCyan,
        secondary: goldAccent,
        surface: cardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: blueCyan, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
        hintStyle: const TextStyle(color: textMuted, fontSize: 13),
      ),
    );
  }
}
