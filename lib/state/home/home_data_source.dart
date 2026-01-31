import '../home_data.dart';

/// Interface for home data. Implement with mock or real repositories.
abstract class HomeDataSource {
  Future<HomeData> fetch();
}
