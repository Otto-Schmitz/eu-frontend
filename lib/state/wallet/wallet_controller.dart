import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'wallet_data.dart';
import 'wallet_data_source.dart';
import 'mock_wallet_data_source.dart';

sealed class WalletState {
  const WalletState();
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  const WalletLoaded(this.data);
  final WalletData data;
}

class WalletError extends WalletState {
  const WalletError(this.message);
  final String message;
}

final walletDataSourceProvider = Provider<WalletDataSource>((ref) {
  return MockWalletDataSource();
});

class WalletController extends Notifier<WalletState> {
  @override
  WalletState build() => const WalletInitial();

  Future<void> load() async {
    state = const WalletLoading();
    try {
      final source = ref.read(walletDataSourceProvider);
      final data = await source.fetch();
      state = WalletLoaded(data);
    } catch (e) {
      state = WalletError(_friendlyMessage(e));
    }
  }

  static String _friendlyMessage(Object e) {
    final str = e.toString();
    if (str.contains('401')) return 'Session expired. Please sign in again.';
    if (str.contains('Connection')) return 'Unable to connect.';
    return 'Something went wrong. Please try again.';
  }
}

final walletControllerProvider =
    NotifierProvider<WalletController, WalletState>(WalletController.new);
