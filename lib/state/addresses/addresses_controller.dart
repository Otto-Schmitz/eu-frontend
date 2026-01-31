import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/address_dto.dart';
import '../../utils/api_error_mapper.dart';
import '../providers.dart';

sealed class AddressesState {
  const AddressesState();
}

class AddressesInitial extends AddressesState {
  const AddressesInitial();
}

class AddressesLoading extends AddressesState {
  const AddressesLoading();
}

class AddressesLoaded extends AddressesState {
  const AddressesLoaded(this.addresses);
  final List<AddressDto> addresses;
}

class AddressesError extends AddressesState {
  const AddressesError(this.message);
  final String message;
}

class AddressesController extends Notifier<AddressesState> {
  @override
  AddressesState build() => const AddressesInitial();

  Future<void> load() async {
    state = const AddressesLoading();
    try {
      final repo = ref.read(addressRepositoryProvider);
      final addresses = await repo.getAddresses();
      state = AddressesLoaded(addresses);
    } catch (e) {
      state = AddressesError(ApiErrorMapper.fromException(e));
    }
  }

  Future<void> addAddress(CreateAddressRequestDto request) async {
    try {
      await ref.read(addressRepositoryProvider).createAddress(request);
      await load();
    } catch (e) {
      state = AddressesError(ApiErrorMapper.fromException(e));
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await ref.read(addressRepositoryProvider).deleteAddress(id);
      await load();
    } catch (e) {
      state = AddressesError(ApiErrorMapper.fromException(e));
      rethrow;
    }
  }
}

final addressesControllerProvider =
    NotifierProvider<AddressesController, AddressesState>(
        AddressesController.new);
