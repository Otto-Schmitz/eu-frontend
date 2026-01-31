import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/empty_widget.dart';
import '../../core/widgets/error_widget.dart' as app;
import '../../core/widgets/loading_widget.dart';
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
    final result = await showDialog<CreateEmergencyContactRequestDto>(
      context: context,
      builder: (ctx) => const _AddContactDialog(),
    );
    if (result != null && mounted) {
      await ref.read(emergencyControllerProvider.notifier).addContact(result);
    }
  }

  Future<void> _call(String phone) async {
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
        EmergencyLoading() => const LoadingWidget(),
        EmergencyError(:final message) => app.ErrorDisplayWidget(
            message: message,
            onRetry: () =>
                ref.read(emergencyControllerProvider.notifier).load(),
          ),
        EmergencyLoaded(contacts: final list) => list.isEmpty
            ? const EmptyWidget(
                message: 'No emergency contacts.\nTap + to add one.',
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
        _ => const LoadingWidget(),
      },
    );
  }
}

class _AddContactDialog extends StatefulWidget {
  const _AddContactDialog();

  @override
  State<_AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<_AddContactDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add emergency contact'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(labelText: 'Relationship (optional)'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Phone is required' : null,
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
                CreateEmergencyContactRequestDto(
                  name: _nameController.text.trim(),
                  relationship: _relationshipController.text.trim().isEmpty
                      ? null
                      : _relationshipController.text.trim(),
                  phone: _phoneController.text.trim(),
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
