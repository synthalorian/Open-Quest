import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestTheme {
  static const _bg = Color(0xFF0D1208);
  static const _surface = Color(0xFF1A2010);
  static const _card = Color(0xFF252D18);
  static const _green = Color(0xFF8BC34A);
  static const _amber = Color(0xFFFFB300);
  static const _textPrimary = Color(0xFFE0E8D0);

  static Color get green => _green;
  static Color get amber => _amber;
  static Color get card => _card;
  static Color get surface => _surface;
  static Color get bg => _bg;

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark, scaffoldBackgroundColor: _bg,
    colorScheme: const ColorScheme.dark(primary: _green, secondary: _amber, surface: _surface),
    cardColor: _card,
    appBarTheme: AppBarTheme(backgroundColor: _bg, elevation: 0, centerTitle: true,
      titleTextStyle: GoogleFonts.inter(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
    textTheme: GoogleFonts.interTextTheme(const TextTheme(
      headlineLarge: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: _textPrimary),
      bodyMedium: TextStyle(color: Color(0xFF8A9870)),
    )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: _green, foregroundColor: Colors.black),
  );
}
