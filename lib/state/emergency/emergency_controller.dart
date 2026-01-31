import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/emergency_contact_dto.dart';
import '../../utils/api_error_mapper.dart';
import '../providers.dart';

sealed class EmergencyState {
  const EmergencyState();
}

class EmergencyInitial extends EmergencyState {
  const EmergencyInitial();
}

class EmergencyLoading extends EmergencyState {
  const EmergencyLoading();
}

class EmergencyLoaded extends EmergencyState {
  const EmergencyLoaded(this.contacts);
  final List<EmergencyContactDto> contacts;
}

class EmergencyError extends EmergencyState {
  const EmergencyError(this.message);
  final String message;
}

class EmergencyController extends Notifier<EmergencyState> {
  @override
  EmergencyState build() => const EmergencyInitial();

  Future<void> load() async {
    state = const EmergencyLoading();
    try {
      final repo = ref.read(emergencyRepositoryProvider);
      final contacts = await repo.getEmergencyContacts();
      state = EmergencyLoaded(contacts);
    } catch (e) {
      state = EmergencyError(ApiErrorMapper.fromException(e));
    }
  }

  Future<void> addContact(CreateEmergencyContactRequestDto request) async {
    try {
      await ref.read(emergencyRepositoryProvider).createEmergencyContact(request);
      await load();
    } catch (e) {
      state = EmergencyError(ApiErrorMapper.fromException(e));
      rethrow;
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await ref.read(emergencyRepositoryProvider).deleteEmergencyContact(id);
      await load();
    } catch (e) {
      state = EmergencyError(ApiErrorMapper.fromException(e));
      rethrow;
    }
  }
}

final emergencyControllerProvider =
    NotifierProvider<EmergencyController, EmergencyState>(
        EmergencyController.new);
