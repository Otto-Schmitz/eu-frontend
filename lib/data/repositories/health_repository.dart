import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../dto/allergy_dto.dart';
import '../dto/health_dto.dart';
import '../dto/medication_dto.dart';

class HealthRepository {
  HealthRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  Future<HealthInfoResponseDto> getHealthInfo({bool includeNotes = false}) async {
    final response = await _dio.get(
      'me/health',
      queryParameters: {'includeNotes': includeNotes},
    );
    return HealthInfoResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<HealthInfoResponseDto> updateHealthInfo(
    UpdateHealthRequestDto request,
  ) async {
    final response = await _dio.put(
      'me/health',
      data: request.toJson(),
    );
    return HealthInfoResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<List<AllergyListItemDto>> getAllergies() async {
    final response = await _dio.get('me/allergies');
    final list = response.data as List<dynamic>? ?? [];
    return list
        .map((e) => AllergyListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AllergyListItemDto> createAllergy(
    CreateAllergyRequestDto request,
  ) async {
    final response = await _dio.post(
      'me/allergies',
      data: request.toJson(),
    );
    return AllergyListItemDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteAllergy(String id) async {
    await _dio.delete('me/allergies/$id');
  }

  Future<List<MedicationListItemDto>> getMedications() async {
    final response = await _dio.get('me/medications');
    final list = response.data as List<dynamic>? ?? [];
    return list
        .map((e) => MedicationListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MedicationListItemDto> createMedication(
    CreateMedicationRequestDto request,
  ) async {
    final response = await _dio.post(
      'me/medications',
      data: request.toJson(),
    );
    return MedicationListItemDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteMedication(String id) async {
    await _dio.delete('me/medications/$id');
  }
}
