import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFFC88D67); // Ochre/Sandstone
  static const Color secondary = Color(0xFF2D3E4E); // Deep Navy
  static const Color tertiary = Color(0xFF8B4513); // Saddle Brown
  
  // Neutral Colors
  static const Color background = Color(0xFFFBF8F6); // Soft Cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3EDE8);
  static const Color onSurface = Color(0xFF1A1C1E);
  static const Color onSurfaceVariant = Color(0xFF44474E);
  
  // Semantic Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color outline = Color(0xFF74777F);
  static const Color outlineVariant = Color(0xFFC4C6CF);
}

final ThemeData travelAnatoliaTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    tertiary: AppColors.tertiary,
    onTertiary: Colors.white,
    surface: AppColors.background,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    error: AppColors.error,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.outfit(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: AppColors.onSurface,
    ),
    displayMedium: GoogleFonts.outfit(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
    displaySmall: GoogleFonts.outfit(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
    headlineLarge: GoogleFonts.notoSerif(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    headlineMedium: GoogleFonts.notoSerif(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    titleLarge: GoogleFonts.notoSerif(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
    titleMedium: GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.onSurface,
    ),
    bodyLarge: GoogleFonts.outfit(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.onSurface,
    ),
    bodyMedium: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.onSurfaceVariant,
    ),
    labelLarge: GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.primary,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
    ),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.secondary,
  ),
);
