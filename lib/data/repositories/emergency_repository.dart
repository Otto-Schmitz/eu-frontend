import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../dto/address_dto.dart';
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

  Future<List<AddressDto>> getAddresses() async {
    final response = await _dio.get('me/addresses');
    final list = response.data as List<dynamic>? ?? [];
    return list
        .map((e) => AddressDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AddressDto> createAddress(CreateAddressRequestDto request) async {
    final response = await _dio.post(
      'me/addresses',
      data: request.toJson(),
    );
    return AddressDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
