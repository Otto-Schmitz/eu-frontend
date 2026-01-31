import 'wallet_data.dart';

/// Interface for wallet data. Implement with mock or real repositories.
abstract class WalletDataSource {
  Future<WalletData> fetch();
}
