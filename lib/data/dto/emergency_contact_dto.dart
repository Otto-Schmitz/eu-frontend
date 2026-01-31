/// Emergency contact DTOs mirroring backend.

class EmergencyContactDto {
  EmergencyContactDto({
    this.id,
    required this.name,
    this.relationship,
    required this.phone,
    this.priority,
  });

  factory EmergencyContactDto.fromJson(Map<String, dynamic> json) {
    return EmergencyContactDto(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String?,
      phone: json['phone'] as String? ?? '',
      priority: json['priority'] as int?,
    );
  }

  final String? id;
  final String name;
  final String? relationship;
  final String phone;
  final int? priority;
}

class CreateEmergencyContactRequestDto {
  CreateEmergencyContactRequestDto({
    required this.name,
    this.relationship,
    required this.phone,
    this.priority,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (relationship != null) 'relationship': relationship,
        'phone': phone,
        if (priority != null) 'priority': priority,
      };

  final String name;
  final String? relationship;
  final String phone;
  final int? priority;
}

class UpdateEmergencyContactRequestDto {
  UpdateEmergencyContactRequestDto({
    this.name,
    this.relationship,
    this.phone,
    this.priority,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (relationship != null) 'relationship': relationship,
        if (phone != null) 'phone': phone,
        if (priority != null) 'priority': priority,
      };

  final String? name;
  final String? relationship;
  final String? phone;
  final int? priority;
}
