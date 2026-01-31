import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/dto/address_dto.dart';
import '../../state/addresses/addresses_controller.dart';
import '../../utils/constants.dart';

const _labels = ['HOME', 'WORK', 'OTHER'];

class AddressesDetailScreen extends ConsumerStatefulWidget {
  const AddressesDetailScreen({super.key});

  @override
  ConsumerState<AddressesDetailScreen> createState() =>
      _AddressesDetailScreenState();
}

class _AddressesDetailScreenState extends ConsumerState<AddressesDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressesControllerProvider.notifier).load();
    });
  }

  Future<void> _addAddress() async {
    final result = await showModalBottomSheet<CreateAddressRequestDto>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddAddressSheet(
        onAdd: (dto) => Navigator.pop(ctx, dto),
        onCancel: () => Navigator.pop(ctx),
      ),
    );
    if (result != null && mounted) {
      try {
        await ref.read(addressesControllerProvider.notifier).addAddress(result);
      } catch (_) {
        // Controller sets ErrorState; screen will rebuild and show ErrorState
      }
    }
  }

  Future<void> _deleteAddress(AddressDto a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove address?'),
        content: const Text('Remove this address from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true && a.id != null && mounted) {
      await ref.read(addressesControllerProvider.notifier).deleteAddress(a.id!);
    }
  }

  String _formatAddress(AddressDto a) {
    final parts = [
      a.street,
      a.number,
      a.city,
      a.state,
      a.zip,
      a.country,
    ].whereType<String>().where((s) => s.isNotEmpty);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAddress,
          ),
        ],
      ),
      body: switch (state) {
        AddressesLoading() => const Center(child: CircularProgressIndicator()),
        AddressesError(:final message) => ErrorState(
            message: message,
            onRetry: () =>
                ref.read(addressesControllerProvider.notifier).load(),
          ),
        AddressesLoaded(:final addresses) => addresses.isEmpty
            ? EmptyState(
                message: 'No addresses added.\nTap + to add one.',
                icon: Icons.location_on_outlined,
                action: FilledButton.icon(
                  onPressed: _addAddress,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add address'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: addresses.length,
                itemBuilder: (_, i) {
                  final a = addresses[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(a.label ?? 'Address'),
                      subtitle: Text(_formatAddress(a)),
                      leading: a.isPrimary
                          ? Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteAddress(a),
                      ),
                    ),
                  );
                },
              ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet({
    required this.onAdd,
    required this.onCancel,
  });

  final void Function(CreateAddressRequestDto) onAdd;
  final VoidCallback onCancel;

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  String _label = 'HOME';
  bool _isPrimary = false;
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      CreateAddressRequestDto(
        label: _label,
        isPrimary: _isPrimary,
        street: _streetController.text.trim().isEmpty
            ? null
            : _streetController.text.trim(),
        number: _numberController.text.trim().isEmpty
            ? null
            : _numberController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        state: _stateController.text.trim().isEmpty
            ? null
            : _stateController.text.trim(),
        zip: _zipController.text.trim().isEmpty
            ? null
            : _zipController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DropdownButtonFormField<String>(
                    value: _label,
                    decoration: const InputDecoration(labelText: 'Label'),
                    items: _labels
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) => setState(() => _label = v ?? 'HOME'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CheckboxListTile(
                    title: const Text('Primary address'),
                    value: _isPrimary,
                    onChanged: (v) => setState(() => _isPrimary = v ?? false),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Street'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _numberController,
                    decoration: const InputDecoration(labelText: 'Number'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(labelText: 'ZIP'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FilledButton(
                          onPressed: _submit,
                          child: const Text('Add'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
