import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/address_dto.dart';
import '../../data/dto/emergency_contact_dto.dart';
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
  const EmergencyLoaded({
    required this.contacts,
    required this.addresses,
  });
  final List<EmergencyContactDto> contacts;
  final List<AddressDto> addresses;
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
      final addresses = await repo.getAddresses();
      state = EmergencyLoaded(contacts: contacts, addresses: addresses);
    } catch (e) {
      state = EmergencyError(_friendlyMessage(e));
    }
  }

  Future<void> addContact(CreateEmergencyContactRequestDto request) async {
    try {
      await ref.read(emergencyRepositoryProvider).createEmergencyContact(request);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addAddress(CreateAddressRequestDto request) async {
    try {
      await ref.read(emergencyRepositoryProvider).createAddress(request);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  static String _friendlyMessage(Object e) {
    final str = e.toString();
    if (str.contains('401')) return 'Session expired. Please sign in again.';
    if (str.contains('Connection')) return 'Unable to connect.';
    return 'Something went wrong. Please try again.';
  }
}

final emergencyControllerProvider =
    NotifierProvider<EmergencyController, EmergencyState>(
        EmergencyController.new);
