import 'dart:async';

import 'home_data.dart';
import 'home_data_source.dart';

/// Mock home data source. Simulates network delay.
/// Replace with real implementation using profile/health/emergency repositories.
class MockHomeDataSource implements HomeDataSource {
  MockHomeDataSource({this.delay = const Duration(milliseconds: 800)});

  final Duration delay;

  @override
  Future<HomeData> fetch() async {
    await Future<void>.delayed(delay);
    return const HomeData(
      displayName: 'Alex',
      bloodType: 'O+',
      allergiesSummary: null,
      mainEmergencyContact: null,
    );
  }
}
