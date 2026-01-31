import 'package:dio/dio.dart';

import '../../core/config/env.dart';
import '../../core/storage/secure_storage.dart';
import '../dto/error_dto.dart';

/// Dio client with auth interceptors.
/// Handles 401 + refresh flow, token injection.
class ApiClient {
  ApiClient({
    required SecureStorage secureStorage,
    Dio? dio,
  })  : _secureStorage = secureStorage,
        _dio = dio ?? Dio(BaseOptions(baseUrl: Env.baseUrl)) {
    _dio.interceptors.addAll([
      _AuthInterceptor(_secureStorage, _dio),
      _ErrorInterceptor(),
    ]);
  }

  final SecureStorage _secureStorage;
  final Dio _dio;

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage, this._dio);

  final SecureStorage _storage;
  final Dio _dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthPath(options.path)) {
      return handler.next(options);
    }
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _isAuthPath(err.requestOptions.path)) {
      return handler.next(err);
    }
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      await _storage.clearTokens();
      return handler.next(err);
    }
    try {
      final response = await _dio.fetch(
        RequestOptions(
          method: 'POST',
          path: 'auth/refresh',
          baseUrl: Env.baseUrl,
          data: {'refreshToken': refreshToken},
        ),
      );
      final access = response.data['accessToken'] as String?;
      final refresh = response.data['refreshToken'] as String?;
      if (access != null && refresh != null) {
        await _storage.saveTokens(accessToken: access, refreshToken: refresh);
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $access';
        final retry = await _dio.fetch(opts);
        return handler.resolve(retry);
      }
    } catch (_) {
      await _storage.clearTokens();
    }
    handler.next(err);
  }

  bool _isAuthPath(String path) =>
      path.contains('auth/register') ||
      path.contains('auth/login') ||
      path.contains('auth/refresh');
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (err.response != null) {
      err = err.copyWith(
        error: ApiError.fromResponse(err.response!),
      );
    }
    handler.next(err);
  }
}

class ApiError implements Exception {
  ApiError({
    this.code,
    this.message = 'Something went wrong',
    this.statusCode,
  });

  factory ApiError.fromResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiError(
        code: data['code'] as String?,
        message: data['message'] as String? ?? _statusMessage(response.statusCode),
        statusCode: response.statusCode,
      );
    }
    return ApiError(
      message: _statusMessage(response.statusCode),
      statusCode: response.statusCode,
    );
  }

  static String _statusMessage(int? code) {
    switch (code) {
      case 400:
        return 'Invalid request';
      case 401:
        return 'Session expired. Please sign in again.';
      case 403:
        return 'Access denied';
      case 404:
        return 'Not found';
      case 422:
        return 'Validation failed';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  final String? code;
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
