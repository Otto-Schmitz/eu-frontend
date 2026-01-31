/// Health DTOs mirroring backend.

class HealthInfoResponseDto {
  HealthInfoResponseDto({
    this.bloodType,
    this.allergyCount,
    this.medicationCount,
    this.medicalNotes,
  });

  factory HealthInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return HealthInfoResponseDto(
      bloodType: json['bloodType'] as String?,
      allergyCount: json['allergyCount'] as int?,
      medicationCount: json['medicationCount'] as int?,
      medicalNotes: json['medicalNotes'] as String?,
    );
  }

  final String? bloodType;
  final int? allergyCount;
  final int? medicationCount;
  final String? medicalNotes;
}

class UpdateHealthRequestDto {
  UpdateHealthRequestDto({
    this.bloodType,
    this.medicalNotes,
  });

  Map<String, dynamic> toJson() => {
        if (bloodType != null) 'bloodType': bloodType,
        if (medicalNotes != null) 'medicalNotes': medicalNotes,
      };

  final String? bloodType;
  final String? medicalNotes;
}
