import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/profile_dto.dart';
import '../providers.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);
  final ProfileResponseDto profile;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
}

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileInitial();

  Future<void> load() async {
    state = const ProfileLoading();
    try {
      final repo = ref.read(profileRepositoryProvider);
      final profile = await repo.getProfile();
      state = ProfileLoaded(profile);
    } catch (e) {
      state = ProfileError(_friendlyMessage(e));
    }
  }

  Future<void> update(UpdateProfileRequestDto request) async {
    if (state is! ProfileLoaded) return;
    state = const ProfileLoading();
    try {
      final repo = ref.read(profileRepositoryProvider);
      final profile = await repo.updateProfile(request);
      state = ProfileLoaded(profile);
    } catch (e) {
      state = ProfileError(_friendlyMessage(e));
    }
  }

  static String _friendlyMessage(Object e) {
    final str = e.toString();
    if (str.contains('401')) return 'Session expired. Please sign in again.';
    if (str.contains('Connection')) return 'Unable to connect.';
    return 'Something went wrong. Please try again.';
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);
