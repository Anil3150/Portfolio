import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const navy = Color(0xFF0B1020);
  static const ink = Color(0xFF111827);
  static const surfaceDark = Color(0xFF151B2F);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const cyan = Color(0xFF38BDF8);
  static const mint = Color(0xFF34D399);
  static const amber = Color(0xFFF59E0B);
  static const rose = Color(0xFFFB7185);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: navy,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyan,
        brightness: Brightness.dark,
        primary: cyan,
        secondary: mint,
        surface: surfaceDark,
      ),
      textTheme: GoogleFonts.interTextTheme(
        base.textTheme,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      cardTheme: _cardTheme(surfaceDark.withOpacity(.72), Colors.white10),
      elevatedButtonTheme: _buttonTheme,
    );
  }

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: cyan,
        brightness: Brightness.light,
        primary: const Color(0xFF0369A1),
        secondary: const Color(0xFF047857),
        surface: surfaceLight,
      ),
      textTheme: GoogleFonts.interTextTheme(
        base.textTheme,
      ).apply(bodyColor: ink, displayColor: ink),
      cardTheme: _cardTheme(surfaceLight.withOpacity(.86), Colors.black12),
      elevatedButtonTheme: _buttonTheme,
    );
  }

  static CardTheme _cardTheme(Color color, Color borderColor) => CardTheme(
    elevation: 0,
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: borderColor),
    ),
  );

  static final ElevatedButtonThemeData _buttonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  );
}
