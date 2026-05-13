import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF9c3f00);
  static const onPrimary = Color(0xFFffffff);
  static const primaryContainer = Color(0xFFc45100);
  static const onPrimaryContainer = Color(0xFFffffff);
  
  static const secondary = Color(0xFF2e628c);
  static const onSecondary = Color(0xFFffffff);
  static const secondaryContainer = Color(0xFF9dcefe);
  static const onSecondaryContainer = Color(0xFF215882);
  
  static const tertiary = Color(0xFF964141);
  static const onTertiary = Color(0xFFffffff);
  static const tertiaryContainer = Color(0xFFb55958);
  static const onTertiaryContainer = Color(0xFFfffbff);
  
  static const background = Color(0xFFfef8f3);
  static const onBackground = Color(0xFF1d1b19);
  
  static const surface = Color(0xFFfef8f3);
  static const onSurface = Color(0xFF1d1b19);
  static const surfaceVariant = Color(0xFFe7e1dd);
  static const onSurfaceVariant = Color(0xFF584238);
  
  static const outline = Color(0xFF8c7166);
  static const outlineVariant = Color(0xFFe0c0b2);
  
  static const error = Color(0xFFba1a1a);
  static const onError = Color(0xFFffffff);
  static const errorContainer = Color(0xFFffdad6);
  static const onErrorContainer = Color(0xFF93000a);
}

final ThemeData travelAnatoliaTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.plusJakartaSansTextTheme(),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    iconTheme: const IconThemeData(color: AppColors.primary),
    titleTextStyle: GoogleFonts.notoSerif(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
    ),
  ),
);

