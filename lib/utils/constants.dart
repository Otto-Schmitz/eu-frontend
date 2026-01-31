/// Spacing, typography, and layout constants.
/// Apple/Google minimal style — generous spacing, clear hierarchy.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double cornerRadius = 12;
  static const double cornerRadiusSm = 8;
  static const double cardElevation = 1;
  static const double minTouchTarget = 44;
}

/// Typography scale — Material 3 with Apple/Google readability.
class AppTypography {
  AppTypography._();

  // Display
  static const double displayLarge = 57;
  static const double displayMedium = 45;
  static const double displaySmall = 36;

  // Headline
  static const double headlineLarge = 32;
  static const double headlineMedium = 28;
  static const double headlineSmall = 24;

  // Title
  static const double titleLarge = 22;
  static const double titleMedium = 16;
  static const double titleSmall = 14;

  // Body
  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 12;

  // Label
  static const double labelLarge = 14;
  static const double labelMedium = 12;
  static const double labelSmall = 11;

  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.5;
}
