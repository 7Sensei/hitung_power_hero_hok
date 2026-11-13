import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const Color textMuted = Color(0xFF8A938A);

  // Auxiliary
  static const Color redAccent = Color(0xFFEF4444);
  static const Color blueCyan = Color(0xFF38BDF8);

  static ThemeData get darkTheme {
    return FlexColorScheme.dark(
      scheme: FlexScheme.material,
      scaffoldBackground: darkBackground,
      primary: neonLime,
      primaryLightRef: neonLime,
      subThemesData: const FlexSubThemesData(
        defaultRadius: 12,
        inputDecoratorRadius: 12,
        inputDecoratorBorderType: FlexInputBorderType.underline,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: 'Inter',
    ).toTheme.copyWith(
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorder),
        ),
      ),
      textTheme: _textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardSubtle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonLime, width: 1.5),
        ),
        labelStyle: TextStyle(color: textSecondary, fontSize: 13),
        hintStyle: TextStyle(color: textMuted, fontSize: 13),
      ),
    );
  }

  static TextTheme get _textTheme {
    final bodyTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return bodyTheme.copyWith(
      displayLarge: GoogleFonts.rajdhani(
        textStyle: bodyTheme.displayLarge,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.rajdhani(
        textStyle: bodyTheme.displayMedium,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.rajdhani(
        textStyle: bodyTheme.displaySmall,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: GoogleFonts.rajdhani(
        textStyle: bodyTheme.headlineLarge,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.rajdhani(
        textStyle: bodyTheme.headlineMedium,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: GoogleFonts.rajdhani(
        textStyle: bodyTheme.headlineSmall,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.rajdhani(
        textStyle: bodyTheme.titleLarge,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static TextStyle get displayStyle =>
      GoogleFonts.rajdhani(color: textPrimary, fontWeight: FontWeight.w800);

  static TextStyle get bodyStyle => GoogleFonts.inter(color: textPrimary);

  static TextStyle get bodySecondaryStyle =>
      GoogleFonts.inter(color: textSecondary);

  static TextStyle get bodyMutedStyle => GoogleFonts.inter(color: textMuted);
}
