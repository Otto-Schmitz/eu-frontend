import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../data/dto/medication_dto.dart';
import '../../state/health/health_controller.dart';
import '../../utils/constants.dart';

/// Medications: add/delete. Bottom sheet for add flow.
class MedicationsDetailScreen extends ConsumerStatefulWidget {
  const MedicationsDetailScreen({super.key});

  @override
  ConsumerState<MedicationsDetailScreen> createState() =>
      _MedicationsDetailScreenState();
}

class _MedicationsDetailScreenState extends ConsumerState<MedicationsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(healthControllerProvider.notifier).load();
    });
  }

  Future<void> _addMedication() async {
    final result = await showModalBottomSheet<CreateMedicationRequestDto>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddMedicationSheet(
        onAdd: (dto) => Navigator.pop(ctx, dto),
        onCancel: () => Navigator.pop(ctx),
      ),
    );
    if (result != null && mounted) {
      await ref.read(healthControllerProvider.notifier).addMedication(result);
    }
  }

  Future<void> _deleteMedication(MedicationListItemDto m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove medication?'),
        content: Text('Remove ${m.name}?'),
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
    if (ok == true && m.id != null && mounted) {
      await ref.read(healthControllerProvider.notifier).removeMedication(m.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMedication,
          ),
        ],
      ),
      body: switch (state) {
        HealthLoading() => const Center(child: CircularProgressIndicator()),
        HealthError(:final message) => ErrorState(
            message: message,
            onRetry: () => ref.read(healthControllerProvider.notifier).load(),
          ),
        HealthLoaded(health: _, medications: final list) => list.isEmpty
            ? EmptyState(
                heading: 'No medications listed',
                message:
                    'Add current medications to help healthcare providers. Tap the button below or + in the app bar.',
                icon: Icons.medication_outlined,
                action: FilledButton.icon(
                  onPressed: _addMedication,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add medication'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final m = list[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(m.name),
                      subtitle: [
                        if (m.dosage != null) m.dosage!,
                        if (m.frequency != null) m.frequency!,
                      ].isNotEmpty
                          ? Text([m.dosage, m.frequency]
                              .whereType<String>()
                              .join(' • '))
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteMedication(m),
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

class _AddMedicationSheet extends StatefulWidget {
  const _AddMedicationSheet({
    required this.onAdd,
    required this.onCancel,
  });

  final void Function(CreateMedicationRequestDto) onAdd;
  final VoidCallback onCancel;

  @override
  State<_AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<_AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      CreateMedicationRequestDto(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim().isEmpty
            ? null
            : _dosageController.text.trim(),
        frequency: _frequencyController.text.trim().isEmpty
            ? null
            : _frequencyController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
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
                    'Add medication',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Ibuprofen',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _dosageController,
                    decoration: const InputDecoration(
                      labelText: 'Dosage (optional)',
                      hintText: 'e.g. 200mg',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _frequencyController,
                    decoration: const InputDecoration(
                      labelText: 'Frequency (optional)',
                      hintText: 'e.g. Twice daily',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                    ),
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
