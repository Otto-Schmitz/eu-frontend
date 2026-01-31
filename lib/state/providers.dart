import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/storage/onboarding_storage.dart';
import '../core/storage/secure_storage.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/emergency_repository.dart';
import '../data/repositories/health_repository.dart';
import '../data/repositories/profile_repository.dart';
import 'auth/auth_controller.dart';
import 'profile/profile_controller.dart';
import 'health/health_controller.dart';
import 'emergency/emergency_controller.dart';

/// Core providers
final secureStorageProvider = Provider<SecureStorage>((_) => SecureStorage());
final onboardingStorageProvider =
    Provider<OnboardingStorage>((_) => OnboardingStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: storage);
});

/// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ref.watch(apiClientProvider));
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository(apiClient: ref.watch(apiClientProvider));
});

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return EmergencyRepository(apiClient: ref.watch(apiClientProvider));
});
