import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/api_error_mapper.dart';
import 'home_data.dart';
import 'home_data_source.dart';
import 'real_home_data_source.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded(this.data);
  final HomeData data;
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
}

/// Home controller. Uses mock source by default.
/// To switch to real: return RealHomeDataSource(ref) in override.
final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return RealHomeDataSource(ref);
});

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeInitial();

  Future<void> load() async {
    state = const HomeLoading();
    try {
      final source = ref.read(homeDataSourceProvider);
      final data = await source.fetch();
      state = HomeLoaded(data);
    } catch (e) {
      state = HomeError(_friendlyMessage(e));
    }
  }

  static String _friendlyMessage(Object e) {
    return ApiErrorMapper.fromException(e);
  }
}

final homeControllerProvider =
    NotifierProvider<HomeController, HomeState>(HomeController.new);
