/// Medication DTOs mirroring backend.

class MedicationListItemDto {
  MedicationListItemDto({
    this.id,
    required this.name,
    this.dosage,
    this.frequency,
    this.notes,
  });

  factory MedicationListItemDto.fromJson(Map<String, dynamic> json) {
    return MedicationListItemDto(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      dosage: json['dosage'] as String?,
      frequency: json['frequency'] as String?,
      notes: json['notes'] as String?,
    );
  }

  final String? id;
  final String name;
  final String? dosage;
  final String? frequency;
  final String? notes;
}

class CreateMedicationRequestDto {
  CreateMedicationRequestDto({
    required this.name,
    this.dosage,
    this.frequency,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (dosage != null) 'dosage': dosage,
        if (frequency != null) 'frequency': frequency,
        if (notes != null) 'notes': notes,
      };

  final String name;
  final String? dosage;
  final String? frequency;
  final String? notes;
}
