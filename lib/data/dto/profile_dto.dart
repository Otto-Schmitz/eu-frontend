/// Profile DTOs mirroring backend.

class ProfileResponseDto {
  ProfileResponseDto({
    this.fullName,
    this.birthDate,
    this.phone,
    this.workplace,
  });

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return ProfileResponseDto(
      fullName: json['fullName'] as String?,
      birthDate: json['birthDate'] as String?,
      phone: json['phone'] as String?,
      workplace: json['workplace'] as String?,
    );
  }

  final String? fullName;
  final String? birthDate;
  final String? phone;
  final String? workplace;
}

class UpdateProfileRequestDto {
  UpdateProfileRequestDto({
    this.fullName,
    this.birthDate,
    this.phone,
    this.workplace,
  });

  Map<String, dynamic> toJson() => {
        if (fullName != null) 'fullName': fullName,
        if (birthDate != null) 'birthDate': birthDate,
        if (phone != null) 'phone': phone,
        if (workplace != null) 'workplace': workplace,
      };

  final String? fullName;
  final String? birthDate;
  final String? phone;
  final String? workplace;
}
