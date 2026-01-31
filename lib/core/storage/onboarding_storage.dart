import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores onboarding completion. Kept separate from sensitive tokens.
class OnboardingStorage {
  OnboardingStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _keyCompleted = 'onboarding_completed';

  Future<bool> isCompleted() async {
    final value = await _storage.read(key: _keyCompleted);
    return value == 'true';
  }

  Future<void> setCompleted() async {
    await _storage.write(key: _keyCompleted, value: 'true');
  }
}
