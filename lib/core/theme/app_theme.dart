import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';

/// Material 3 design system.
/// Light/Dark themes, typography scale, Apple/Google minimal style.
class AppTheme {
  AppTheme._();

  // Light palette
  static const Color _lightBackground = Color(0xFFF8F9FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightPrimary = Color(0xFF4A7C8C);
  static const Color _lightPrimaryVariant = Color(0xFF3D6B7A);
  static const Color _lightOnBackground = Color(0xFF1A1D21);
  static const Color _lightOnSurface = Color(0xFF2D3238);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOutline = Color(0xFFDDE2E6);
  static const Color _lightError = Color(0xFFB71C1C);

  // Dark palette
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkPrimary = Color(0xFF7BB3C4);
  static const Color _darkPrimaryVariant = Color(0xFF5A9AAB);
  static const Color _darkOnBackground = Color(0xFFE8E8E8);
  static const Color _darkOnSurface = Color(0xFFE0E0E0);
  static const Color _darkOnPrimary = Color(0xFF1A1D21);
  static const Color _darkOutline = Color(0xFF3D4043);
  static const Color _darkError = Color(0xFFCF6679);

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: isLight
          ? const ColorScheme.light(
              primary: _lightPrimary,
              onPrimary: _lightOnPrimary,
              primaryContainer: Color(0xFFD4E8ED),
              onPrimaryContainer: _lightPrimaryVariant,
              secondary: Color(0xFF5C6B73),
              onSecondary: _lightOnPrimary,
              surface: _lightSurface,
              onSurface: _lightOnSurface,
              surfaceContainerHighest: _lightBackground,
              onSurfaceVariant: Color(0xFF5C6B73),
              outline: _lightOutline,
              error: _lightError,
              onError: _lightOnPrimary,
            )
          : const ColorScheme.dark(
              primary: _darkPrimary,
              onPrimary: _darkOnPrimary,
              primaryContainer: Color(0xFF2D4A52),
              onPrimaryContainer: _darkPrimaryVariant,
              secondary: Color(0xFF9CA3A8),
              onSecondary: _darkOnPrimary,
              surface: _darkSurface,
              onSurface: _darkOnSurface,
              surfaceContainerHighest: _darkBackground,
              onSurfaceVariant: Color(0xFFB0B5B9),
              outline: _darkOutline,
              error: _darkError,
              onError: _darkOnPrimary,
            ),
      scaffoldBackgroundColor: isLight ? _lightBackground : _darkBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: isLight ? _lightSurface : _darkSurface,
        foregroundColor: isLight ? _lightOnSurface : _darkOnSurface,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: isLight ? _lightOnSurface : _darkOnSurface,
          fontSize: AppTypography.titleLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        elevation: AppSpacing.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
        ),
        color: isLight ? _lightSurface : _darkSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? _lightSurface : _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
          borderSide: BorderSide(color: isLight ? _lightOutline : _darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
          borderSide: BorderSide(
            color: isLight ? _lightPrimary : _darkPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
          borderSide: BorderSide(color: isLight ? _lightError : _darkError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? _lightPrimary : _darkPrimary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isLight ? _lightPrimary : _darkPrimary,
        unselectedItemColor: isLight ? const Color(0xFF5C6B73) : const Color(0xFFB0B5B9),
        elevation: 0,
      ),
      textTheme: _textTheme(isLight ? _lightOnBackground : _darkOnBackground),
    );
  }

  static TextTheme _textTheme(Color defaultColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTypography.displayLarge,
        fontWeight: FontWeight.w400,
        letterSpacing: AppTypography.letterSpacingTight,
        color: defaultColor,
      ),
      displayMedium: TextStyle(
        fontSize: AppTypography.displayMedium,
        fontWeight: FontWeight.w400,
        letterSpacing: AppTypography.letterSpacingTight,
        color: defaultColor,
      ),
      displaySmall: TextStyle(
        fontSize: AppTypography.displaySmall,
        fontWeight: FontWeight.w400,
        color: defaultColor,
      ),
      headlineLarge: TextStyle(
        fontSize: AppTypography.headlineLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: AppTypography.letterSpacingTight,
        color: defaultColor,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTypography.headlineMedium,
        fontWeight: FontWeight.w600,
        letterSpacing: AppTypography.letterSpacingTight,
        color: defaultColor,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.headlineSmall,
        fontWeight: FontWeight.w600,
        color: defaultColor,
      ),
      titleLarge: TextStyle(
        fontSize: AppTypography.titleLarge,
        fontWeight: FontWeight.w600,
        color: defaultColor,
      ),
      titleMedium: TextStyle(
        fontSize: AppTypography.titleMedium,
        fontWeight: FontWeight.w500,
        color: defaultColor,
      ),
      titleSmall: TextStyle(
        fontSize: AppTypography.titleSmall,
        fontWeight: FontWeight.w500,
        color: defaultColor,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTypography.bodyLarge,
        fontWeight: FontWeight.w400,
        color: defaultColor,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.bodyMedium,
        fontWeight: FontWeight.w400,
        color: defaultColor,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.bodySmall,
        fontWeight: FontWeight.w400,
        color: defaultColor,
      ),
      labelLarge: TextStyle(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
        color: defaultColor,
      ),
      labelMedium: TextStyle(
        fontSize: AppTypography.labelMedium,
        fontWeight: FontWeight.w500,
        color: defaultColor,
      ),
      labelSmall: TextStyle(
        fontSize: AppTypography.labelSmall,
        fontWeight: FontWeight.w500,
        letterSpacing: AppTypography.letterSpacingWide,
        color: defaultColor,
      ),
    );
  }

  static const Color emergencyBackground = Color(0xFF1A1D21);
  static const Color emergencyText = Color(0xFFFFFFFF);
  static const Color emergencyAccent = Color(0xFFB71C1C);
}
