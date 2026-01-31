import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/api_error_mapper.dart';
import 'wallet_data.dart';
import 'wallet_data_source.dart';
import 'real_wallet_data_source.dart';

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
  return RealWalletDataSource(ref);
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
    return ApiErrorMapper.fromException(e);
  }
}

final walletControllerProvider =
    NotifierProvider<WalletController, WalletState>(WalletController.new);
