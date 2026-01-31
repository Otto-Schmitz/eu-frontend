import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/emergency_repository.dart';
import '../../data/repositories/health_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../providers.dart';
import 'home_data.dart';
import 'home_data_source.dart';

/// Real home data source using profile, health, emergency repositories.
/// Use by overriding homeDataSourceProvider:
///   homeDataSourceProvider = Provider((ref) => RealHomeDataSource(ref))
class RealHomeDataSource implements HomeDataSource {
  RealHomeDataSource(this._ref);

  final Ref _ref;

  @override
  Future<HomeData> fetch() async {
    final profileRepo = _ref.read(profileRepositoryProvider);
    final healthRepo = _ref.read(healthRepositoryProvider);
    final emergencyRepo = _ref.read(emergencyRepositoryProvider);

    final profile = await profileRepo.getProfile();
    final health = await healthRepo.getHealthInfo(includeNotes: false);
    final allergies = await healthRepo.getAllergies();
    final contacts = await emergencyRepo.getEmergencyContacts();

    String? allergiesSummary;
    if (allergies.isNotEmpty) {
      allergiesSummary = allergies.length == 1
          ? allergies.first.name
          : '${allergies.first.name} +${allergies.length - 1}';
    }

    MainEmergencyContact? mainContact;
    if (contacts.isNotEmpty) {
      final c = contacts.first;
      mainContact = MainEmergencyContact(
        name: c.name,
        relationship: c.relationship,
        phone: c.phone,
      );
    }

    String? bloodType = health.bloodType;
    if (bloodType == 'UNKNOWN' || bloodType == null || bloodType.isEmpty) {
      bloodType = null;
    }

    return HomeData(
      displayName: profile.fullName,
      bloodType: bloodType,
      allergiesSummary: allergiesSummary,
      mainEmergencyContact: mainContact,
    );
  }
}
