/// Auth request/response DTOs mirroring backend.

class LoginRequestDto {
  LoginRequestDto({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RegisterRequestDto {
  RegisterRequestDto({
    required this.email,
    required this.password,
    this.fullName,
  });

  final String email;
  final String password;
  final String? fullName;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        if (fullName != null) 'fullName': fullName,
      };
}

class AuthResponseDto {
  AuthResponseDto({
    this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      userId: json['userId'] as String?,
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  final String? userId;
  final String accessToken;
  final String refreshToken;
}

class RefreshRequestDto {
  RefreshRequestDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class RefreshResponseDto {
  RefreshResponseDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponseDto.fromJson(Map<String, dynamic> json) {
    return RefreshResponseDto(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  final String accessToken;
  final String refreshToken;
}
