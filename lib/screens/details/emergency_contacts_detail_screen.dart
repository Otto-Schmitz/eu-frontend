import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/empty_state.dart';
import '../../utils/haptics.dart';
import '../../core/widgets/error_state.dart';
import '../../data/dto/emergency_contact_dto.dart';
import '../../state/emergency/emergency_controller.dart';
import '../../utils/constants.dart';

class EmergencyContactsDetailScreen extends ConsumerStatefulWidget {
  const EmergencyContactsDetailScreen({super.key});

  @override
  ConsumerState<EmergencyContactsDetailScreen> createState() =>
      _EmergencyContactsDetailScreenState();
}

class _EmergencyContactsDetailScreenState
    extends ConsumerState<EmergencyContactsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emergencyControllerProvider.notifier).load();
    });
  }

  Future<void> _addContact() async {
    final result = await showModalBottomSheet<CreateEmergencyContactRequestDto>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddContactSheet(
        onAdd: (dto) => Navigator.pop(ctx, dto),
        onCancel: () => Navigator.pop(ctx),
      ),
    );
    if (result != null && mounted) {
      try {
        await ref.read(emergencyControllerProvider.notifier).addContact(result);
      } catch (_) {
        // Controller sets ErrorState; screen will rebuild and show ErrorState
      }
    }
  }

  Future<void> _call(String phone) async {
    AppHaptics.medium();
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emergencyControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency contacts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addContact,
          ),
        ],
      ),
      body: switch (state) {
        EmergencyLoading() => const Center(child: CircularProgressIndicator()),
        EmergencyError(:final message) => ErrorState(
            message: message,
            onRetry: () =>
                ref.read(emergencyControllerProvider.notifier).load(),
          ),
        EmergencyLoaded(contacts: final list) => list.isEmpty
            ? EmptyState(
                heading: 'No emergency contacts',
                message:
                    'Add someone to call in an emergency. This info appears on your Medical ID tab for quick access.',
                icon: Icons.contact_emergency_outlined,
                action: FilledButton.icon(
                  onPressed: _addContact,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add contact'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final c = list[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(c.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (c.relationship != null) Text(c.relationship!),
                          Text(c.phone),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () => _call(c.phone),
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

class _AddContactSheet extends StatefulWidget {
  const _AddContactSheet({
    required this.onAdd,
    required this.onCancel,
  });

  final void Function(CreateEmergencyContactRequestDto) onAdd;
  final VoidCallback onCancel;

  @override
  State<_AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<_AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      CreateEmergencyContactRequestDto(
        name: _nameController.text.trim(),
        relationship: _relationshipController.text.trim().isEmpty
            ? null
            : _relationshipController.text.trim(),
        phone: _phoneController.text.trim(),
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add emergency contact',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _relationshipController,
                  decoration: const InputDecoration(
                      labelText: 'Relationship (optional)'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Phone is required' : null,
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
    );
  }
}
