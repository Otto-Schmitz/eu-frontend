/// Home screen summary data. Interface for mock and real sources.
class HomeData {
  const HomeData({
    this.displayName,
    this.bloodType,
    this.allergiesSummary,
    this.mainEmergencyContact,
  });

  final String? displayName;
  final String? bloodType;
  final String? allergiesSummary;
  final MainEmergencyContact? mainEmergencyContact;

  int get filledCount => [
        bloodType != null && bloodType!.isNotEmpty && bloodType != 'UNKNOWN',
        allergiesSummary != null && allergiesSummary!.isNotEmpty,
        mainEmergencyContact != null,
      ].where((v) => v).length;

  static const int totalSlots = 3;
  bool get isComplete => filledCount >= totalSlots;
}

class MainEmergencyContact {
  const MainEmergencyContact({
    required this.name,
    this.relationship,
    required this.phone,
  });

  final String name;
  final String? relationship;
  final String phone;
}
