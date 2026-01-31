/// Address DTOs mirroring backend.

class AddressDto {
  AddressDto({
    this.id,
    this.label,
    this.isPrimary,
    this.street,
    this.number,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      id: json['id'] as String?,
      label: json['label'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      street: json['street'] as String?,
      number: json['number'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      country: json['country'] as String?,
    );
  }

  final String? id;
  final String? label;
  final bool isPrimary;
  final String? street;
  final String? number;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
}

class UpdateAddressRequestDto {
  UpdateAddressRequestDto({
    this.label,
    this.isPrimary,
    this.street,
    this.number,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  Map<String, dynamic> toJson() => {
        if (label != null) 'label': label,
        if (isPrimary != null) 'isPrimary': isPrimary,
        if (street != null) 'street': street,
        if (number != null) 'number': number,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zip != null) 'zip': zip,
        if (country != null) 'country': country,
      };

  final String? label;
  final bool? isPrimary;
  final String? street;
  final String? number;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
}

class CreateAddressRequestDto {
  CreateAddressRequestDto({
    required this.label,
    this.isPrimary,
    this.street,
    this.number,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        if (isPrimary != null) 'isPrimary': isPrimary,
        if (street != null) 'street': street,
        if (number != null) 'number': number,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zip != null) 'zip': zip,
        if (country != null) 'country': country,
      };

  final String label;
  final bool? isPrimary;
  final String? street;
  final String? number;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
}
