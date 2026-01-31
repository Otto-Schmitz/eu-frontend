import 'dart:async';

import 'package:flutter/material.dart';

import 'wallet_data.dart';
import 'wallet_data_source.dart';

/// Mock wallet data source.
class MockWalletDataSource implements WalletDataSource {
  MockWalletDataSource({this.delay = const Duration(milliseconds: 400)});

  final Duration delay;

  @override
  Future<WalletData> fetch() async {
    await Future<void>.delayed(delay);
    final now = DateTime.now();
    return WalletData(
      categories: [
        WalletCategory(
          id: 'identity',
          title: 'Identity',
          icon: Icons.person_outline,
          route: '/details/profile',
          completionLabel: 'Complete',
          lastUpdated: now.subtract(const Duration(hours: 2)),
        ),
        WalletCategory(
          id: 'health',
          title: 'Health',
          icon: Icons.medical_information_outlined,
          route: '/details/health',
          completionLabel: '1 of 3',
          lastUpdated: now.subtract(const Duration(days: 1)),
        ),
        WalletCategory(
          id: 'emergency',
          title: 'Emergency contacts',
          icon: Icons.contact_emergency_outlined,
          route: '/details/emergency-contacts',
          completionLabel: 'Empty',
          lastUpdated: null,
        ),
        WalletCategory(
          id: 'addresses',
          title: 'Addresses',
          icon: Icons.location_on_outlined,
          route: '/details/addresses',
          completionLabel: '2 addresses',
          lastUpdated: now.subtract(const Duration(days: 3)),
        ),
        WalletCategory(
          id: 'medications',
          title: 'Medications',
          icon: Icons.medication_outlined,
          route: '/details/medications',
          completionLabel: '1 medication',
          lastUpdated: now.subtract(const Duration(hours: 5)),
        ),
        WalletCategory(
          id: 'documents',
          title: 'Documents',
          icon: Icons.description_outlined,
          route: '/details/documents',
          completionLabel: 'Coming soon',
          lastUpdated: null,
        ),
      ],
    );
  }
}
