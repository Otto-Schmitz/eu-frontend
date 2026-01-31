import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/auth_dto.dart';
import '../../utils/api_error_mapper.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers.dart';

/// Auth state: initial, loading, authenticated, unauthenticated, error.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  Future<void> checkAuth() async {
    state = const AuthLoading();
    final storage = ref.read(secureStorageProvider);
    final token = await storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      state = const AuthAuthenticated();
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login(LoginRequestDto request) async {
    state = const AuthLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.login(request);
      await ref.read(secureStorageProvider).saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );
      state = const AuthAuthenticated();
    } catch (e) {
      state = AuthError(_friendlyMessage(e));
    }
  }

  Future<void> register(RegisterRequestDto request) async {
    state = const AuthLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.register(request);
      await ref.read(secureStorageProvider).saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );
      state = const AuthAuthenticated();
    } catch (e) {
      state = AuthError(_friendlyMessage(e));
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AuthUnauthenticated();
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }

  static String _friendlyMessage(Object e) {
    return ApiErrorMapper.fromException(e);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
