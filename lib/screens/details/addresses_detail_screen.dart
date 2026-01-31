import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_widget.dart';
import '../../core/widgets/error_widget.dart' as app;
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/address_dto.dart';
import '../../state/emergency/emergency_controller.dart';
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
      ref.read(emergencyControllerProvider.notifier).load();
    });
  }

  Future<void> _addAddress() async {
    final result = await showDialog<CreateAddressRequestDto>(
      context: context,
      builder: (ctx) => const _AddAddressDialog(),
    );
    if (result != null && mounted) {
      await ref.read(emergencyControllerProvider.notifier).addAddress(result);
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
    final state = ref.watch(emergencyControllerProvider);

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
        EmergencyLoading() => const LoadingWidget(),
        EmergencyError(:final message) => app.ErrorDisplayWidget(
            message: message,
            onRetry: () =>
                ref.read(emergencyControllerProvider.notifier).load(),
          ),
        EmergencyLoaded(addresses: final list) => list.isEmpty
            ? const EmptyWidget(
                message: 'No addresses added.\nTap + to add one.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
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
                    ),
                  );
                },
              ),
        _ => const LoadingWidget(),
      },
    );
  }
}

class _AddAddressDialog extends StatefulWidget {
  const _AddAddressDialog();

  @override
  State<_AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<_AddAddressDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add address'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
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
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
