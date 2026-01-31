import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../dto/profile_dto.dart';

class ProfileRepository {
  ProfileRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  Future<ProfileResponseDto> getProfile() async {
    final response = await _dio.get('me/profile');
    return ProfileResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<ProfileResponseDto> updateProfile(UpdateProfileRequestDto request) async {
    final response = await _dio.put(
      'me/profile',
      data: request.toJson(),
    );
    return ProfileResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
