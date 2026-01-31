import 'package:flutter/material.dart';

/// Wallet category summary for display.
class WalletCategory {
  const WalletCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.completionLabel,
    this.lastUpdated,
  });

  final String id;
  final String title;
  final IconData icon;
  final String route;
  final String? completionLabel;
  final DateTime? lastUpdated;
}

/// Wallet screen data. Interface for mock and real sources.
class WalletData {
  const WalletData({required this.categories});

  final List<WalletCategory> categories;
}
