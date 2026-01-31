import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../dto/emergency_contact_dto.dart';

class EmergencyRepository {
  EmergencyRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  Future<List<EmergencyContactDto>> getEmergencyContacts() async {
    final response = await _dio.get('me/emergency-contacts');
    final list = response.data as List<dynamic>? ?? [];
    return list
        .map((e) => EmergencyContactDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<EmergencyContactDto> createEmergencyContact(
    CreateEmergencyContactRequestDto request,
  ) async {
    final response = await _dio.post(
      'me/emergency-contacts',
      data: request.toJson(),
    );
    return EmergencyContactDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<EmergencyContactDto> updateEmergencyContact(
    String id,
    UpdateEmergencyContactRequestDto request,
  ) async {
    final response = await _dio.put(
      'me/emergency-contacts/$id',
      data: request.toJson(),
    );
    return EmergencyContactDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> deleteEmergencyContact(String id) async {
    await _dio.delete('me/emergency-contacts/$id');
  }
}
