import 'package:flutter/services.dart';

/// Haptic feedback on key actions. Improves perceived responsiveness.
class AppHaptics {
  AppHaptics._();

  /// Light tap — cards, list items, secondary actions.
  static void light() => HapticFeedback.lightImpact();

  /// Medium tap — primary buttons, important confirmations.
  static void medium() => HapticFeedback.mediumImpact();

  /// Selection — toggles, segmented control, nav items.
  static void selection() => HapticFeedback.selectionClick();

  /// Success — after save, add, etc.
  static void success() => HapticFeedback.heavyImpact();

  /// Error — validation, failed action.
  static void error() => HapticFeedback.vibrate();
}
