import 'package:flutter/material.dart';

class QuestTheme {
  static const background = Color(0xFF0B0117);
  static const surface = Color(0xFF120324);
  static const card = Color(0xFF1C0638);
  static const neonPink = Color(0xFFFF00FF);
  static const neonBlue = Color(0xFF00FFFF);
  static const textPrimary = Color(0xFFF0F0F0);
  static const textSecondary = Color(0xFFB0B0B0);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: neonPink,
      secondary: neonBlue,
      surface: surface,
    ),
    cardColor: card,
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: neonPink,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: neonPink),
      ),
      labelStyle: const TextStyle(color: textSecondary),
    ),
  );
}
