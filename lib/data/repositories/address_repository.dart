import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../dto/address_dto.dart';

class AddressRepository {
  AddressRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

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
    return AddressDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AddressDto> updateAddress(
    String id,
    UpdateAddressRequestDto request,
  ) async {
    final response = await _dio.put(
      'me/addresses/$id',
      data: request.toJson(),
    );
    return AddressDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteAddress(String id) async {
    await _dio.delete('me/addresses/$id');
  }
}
