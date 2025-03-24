import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const gradientBackgroundStart = Color(0xFFEBD1FB);
const gradientBackgroundEnd = Color(0xFFFBFBF9);
const primaryDark = Color(0xFF151638);

final randomTheme = ThemeData(
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    centerTitle: true,
    foregroundColor: Color(0xFF222345),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF151638),
    dragHandleColor: Color(0xFF50516D),
    dragHandleSize: Size(64, 8),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFFFBFBF9),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF222345),
    onPrimary: Color(0xFFF1F6F9),
    secondary: Color(0x7750516D),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Colors.black12,
    error: Colors.redAccent,
    onError: Color(0xFFFFFFFF),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.righteous(
      textStyle: const TextStyle(fontSize: 28, color: Color(0xFF222345)),
    ),
    titleMedium: GoogleFonts.montserrat(
      textStyle: const TextStyle(
          color: Color(0xFF000B1A), fontSize: 28, fontWeight: FontWeight.bold),
    ),
    titleSmall: GoogleFonts.montserrat(
      textStyle: const TextStyle(fontSize: 18, color: Color(0xFF222345)),
    ),
    bodyLarge: GoogleFonts.montserrat(
      textStyle: const TextStyle(color: Color(0xFF000B1A), fontSize: 24),
    ),
    bodyMedium: GoogleFonts.lato(
        textStyle: const TextStyle(color: Color(0xFF000B1A), fontSize: 18)),
    bodySmall: GoogleFonts.lato(
      textStyle: const TextStyle(color: Color(0x7750516D), fontSize: 16),
    ),
    labelLarge: GoogleFonts.lato(),
    labelMedium: GoogleFonts.montserrat(
      textStyle: const TextStyle(color: Color(0xFF000B1A), fontSize: 18),
    ),
    labelSmall: GoogleFonts.lato(
      textStyle: const TextStyle(color: Color(0xFF000B1A), fontSize: 16),
    ),
  ),
);
