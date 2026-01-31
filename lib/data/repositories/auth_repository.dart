import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../dto/auth_dto.dart';
import '../../core/storage/secure_storage.dart';

/// Auth API calls. No business logic.
class AuthRepository {
  AuthRepository({required ApiClient apiClient, required SecureStorage storage})
      : _dio = apiClient.dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorage _storage;

  Future<AuthResponseDto> register(RegisterRequestDto request) async {
    final response = await _dio.post(
      'auth/register',
      data: request.toJson(),
    );
    return AuthResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<AuthResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post(
      'auth/login',
      data: request.toJson(),
    );
    return AuthResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> logout() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _dio.post(
          'auth/logout',
          data: {'refreshToken': refreshToken},
        );
      } catch (_) {
        // Best effort
      }
    }
    await _storage.clearTokens();
  }
}
