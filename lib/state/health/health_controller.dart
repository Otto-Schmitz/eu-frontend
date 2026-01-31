import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/allergy_dto.dart';
import '../../utils/api_error_mapper.dart';
import '../../data/dto/health_dto.dart';
import '../../data/dto/medication_dto.dart';
import '../providers.dart';

sealed class HealthState {
  const HealthState();
}

class HealthInitial extends HealthState {
  const HealthInitial();
}

class HealthLoading extends HealthState {
  const HealthLoading();
}

class HealthLoaded extends HealthState {
  const HealthLoaded({
    required this.health,
    required this.allergies,
    required this.medications,
  });
  final HealthInfoResponseDto health;
  final List<AllergyListItemDto> allergies;
  final List<MedicationListItemDto> medications;
}

class HealthError extends HealthState {
  const HealthError(this.message);
  final String message;
}

class HealthController extends Notifier<HealthState> {
  @override
  HealthState build() => const HealthInitial();

  Future<void> load({bool includeNotes = false}) async {
    state = const HealthLoading();
    try {
      final repo = ref.read(healthRepositoryProvider);
      final health = await repo.getHealthInfo(includeNotes: includeNotes);
      final allergies = await repo.getAllergies();
      final medications = await repo.getMedications();
      state = HealthLoaded(
        health: health,
        allergies: allergies,
        medications: medications,
      );
    } catch (e) {
      state = HealthError(_friendlyMessage(e));
    }
  }

  Future<void> addAllergy(CreateAllergyRequestDto request) async {
    try {
      await ref.read(healthRepositoryProvider).createAllergy(request);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> removeAllergy(String id) async {
    try {
      await ref.read(healthRepositoryProvider).deleteAllergy(id);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> addMedication(CreateMedicationRequestDto request) async {
    try {
      await ref.read(healthRepositoryProvider).createMedication(request);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> removeMedication(String id) async {
    try {
      await ref.read(healthRepositoryProvider).deleteMedication(id);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateHealth(UpdateHealthRequestDto request) async {
    try {
      await ref.read(healthRepositoryProvider).updateHealthInfo(request);
      await load();
    } catch (_) {
      rethrow;
    }
  }

  static String _friendlyMessage(Object e) {
    return ApiErrorMapper.fromException(e);
  }
}

final healthControllerProvider =
    NotifierProvider<HealthController, HealthState>(HealthController.new);
