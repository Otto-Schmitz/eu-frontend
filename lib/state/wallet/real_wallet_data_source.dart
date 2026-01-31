import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/address_repository.dart';
import '../../data/repositories/emergency_repository.dart';
import '../../data/repositories/health_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../providers.dart';
import 'wallet_data.dart';

/// Real wallet data source using profile, health, emergency, addresses.
class RealWalletDataSource implements WalletDataSource {
  RealWalletDataSource(this._ref);

  final Ref _ref;

  @override
  Future<WalletData> fetch() async {
    final profileRepo = _ref.read(profileRepositoryProvider);
    final healthRepo = _ref.read(healthRepositoryProvider);
    final emergencyRepo = _ref.read(emergencyRepositoryProvider);
    final addressRepo = _ref.read(addressRepositoryProvider);

    final profile = await profileRepo.getProfile();
    final health = await healthRepo.getHealthInfo(includeNotes: false);
    final allergies = await healthRepo.getAllergies();
    final medications = await healthRepo.getMedications();
    final contacts = await emergencyRepo.getEmergencyContacts();
    final addresses = await addressRepo.getAddresses();

    final categories = <WalletCategory>[
      WalletCategory(
        id: 'identity',
        title: 'Identity',
        icon: Icons.person_outline,
        route: '/details/profile',
        completionLabel: _profileCompletion(profile.fullName, profile.birthDate),
        lastUpdated: null,
      ),
      WalletCategory(
        id: 'health',
        title: 'Health',
        icon: Icons.medical_information_outlined,
        route: '/details/health',
        completionLabel: _healthCompletion(
          health.bloodType,
          allergies.length,
          medications.length,
        ),
        lastUpdated: null,
      ),
      WalletCategory(
        id: 'emergency',
        title: 'Emergency contacts',
        icon: Icons.contact_emergency_outlined,
        route: '/details/emergency-contacts',
        completionLabel: contacts.isEmpty
            ? 'Empty'
            : '${contacts.length} contact${contacts.length == 1 ? '' : 's'}',
        lastUpdated: null,
      ),
      WalletCategory(
        id: 'addresses',
        title: 'Addresses',
        icon: Icons.location_on_outlined,
        route: '/details/addresses',
        completionLabel: addresses.isEmpty
            ? 'Empty'
            : '${addresses.length} address${addresses.length == 1 ? '' : 'es'}',
        lastUpdated: null,
      ),
      WalletCategory(
        id: 'medications',
        title: 'Medications',
        icon: Icons.medication_outlined,
        route: '/details/medications',
        completionLabel: medications.isEmpty
            ? 'Empty'
            : '${medications.length} medication${medications.length == 1 ? '' : 's'}',
        lastUpdated: null,
      ),
      WalletCategory(
        id: 'documents',
        title: 'Documents',
        icon: Icons.description_outlined,
        route: '/details/documents',
        completionLabel: 'Coming soon',
        lastUpdated: null,
      ),
    ];

    return WalletData(categories: categories);
  }

  String _profileCompletion(String? fullName, String? birthDate) {
    if (fullName != null && fullName.isNotEmpty && birthDate != null) {
      return 'Complete';
    }
    if (fullName != null && fullName.isNotEmpty) return 'Partial';
    return 'Empty';
  }

  String _healthCompletion(String? bloodType, int allergyCount, int medCount) {
    final hasBlood = bloodType != null &&
        bloodType.isNotEmpty &&
        bloodType != 'UNKNOWN';
    final filled = (hasBlood ? 1 : 0) + (allergyCount > 0 ? 1 : 0) + (medCount > 0 ? 1 : 0);
    return '$filled of 3';
  }
}
