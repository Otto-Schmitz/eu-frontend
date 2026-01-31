import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_widget.dart';
import '../../core/widgets/error_widget.dart' as app;
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/medication_dto.dart';
import '../../state/health/health_controller.dart';
import '../../utils/constants.dart';

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
    final result = await showDialog<CreateMedicationRequestDto>(
      context: context,
      builder: (ctx) => const _AddMedicationDialog(),
    );
    if (result != null && mounted) {
      await ref.read(healthControllerProvider.notifier).addMedication(result);
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
        HealthLoading() => const LoadingWidget(),
        HealthError(:final message) => app.ErrorDisplayWidget(
            message: message,
            onRetry: () => ref.read(healthControllerProvider.notifier).load(),
          ),
        HealthLoaded(health: _, medications: final list) => list.isEmpty
            ? const EmptyWidget(
                message: 'No medications added.\nTap + to add one.',
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
                        onPressed: () async {
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
                            await ref
                                .read(healthControllerProvider.notifier)
                                .removeMedication(m.id!);
                          }
                        },
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

class _AddMedicationDialog extends StatefulWidget {
  const _AddMedicationDialog();

  @override
  State<_AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<_AddMedicationDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add medication'),
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
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosage (optional)'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _frequencyController,
                decoration:
                    const InputDecoration(labelText: 'Frequency (optional)'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
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
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
