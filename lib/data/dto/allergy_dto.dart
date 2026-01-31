/// Allergy DTOs mirroring backend.

class AllergyListItemDto {
  AllergyListItemDto({
    this.id,
    required this.name,
    this.severity,
    this.notes,
  });

  factory AllergyListItemDto.fromJson(Map<String, dynamic> json) {
    return AllergyListItemDto(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      severity: json['severity'] as String?,
      notes: json['notes'] as String?,
    );
  }

  final String? id;
  final String name;
  final String? severity;
  final String? notes;
}

class CreateAllergyRequestDto {
  CreateAllergyRequestDto({
    required this.name,
    this.severity,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (severity != null) 'severity': severity,
        if (notes != null) 'notes': notes,
      };

  final String name;
  final String? severity;
  final String? notes;
}
