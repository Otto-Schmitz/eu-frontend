import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/allergy_dto.dart';
import '../../state/health/health_controller.dart';
import '../../utils/constants.dart';

const _severities = ['LOW', 'MEDIUM', 'HIGH'];

/// Allergies: add/delete. Bottom sheet for add flow.
class AllergiesDetailScreen extends ConsumerStatefulWidget {
  const AllergiesDetailScreen({super.key});

  @override
  ConsumerState<AllergiesDetailScreen> createState() =>
      _AllergiesDetailScreenState();
}

class _AllergiesDetailScreenState extends ConsumerState<AllergiesDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(healthControllerProvider.notifier).load();
    });
  }

  Future<void> _addAllergy() async {
    final result = await showModalBottomSheet<CreateAllergyRequestDto>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddAllergySheet(
        onAdd: (dto) => Navigator.pop(ctx, dto),
        onCancel: () => Navigator.pop(ctx),
      ),
    );
    if (result != null && mounted) {
      await ref.read(healthControllerProvider.notifier).addAllergy(result);
    }
  }

  Future<void> _deleteAllergy(AllergyListItemDto a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove allergy?'),
        content: Text('Remove ${a.name} from your list?'),
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
      await ref.read(healthControllerProvider.notifier).removeAllergy(a.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAllergy,
          ),
        ],
      ),
      body: switch (state) {
        HealthLoading() => const Center(child: CircularProgressIndicator()),
        HealthError(:final message) => ErrorState(
            message: message,
            onRetry: () => ref.read(healthControllerProvider.notifier).load(),
          ),
        HealthLoaded(health: _, allergies: final list) => list.isEmpty
            ? EmptyState(
                heading: 'No allergies listed',
                message:
                    'Add allergies so first responders know what to avoid. Tap the button below or + in the app bar.',
                icon: Icons.warning_amber_outlined,
                action: FilledButton.icon(
                  onPressed: _addAllergy,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add allergy'),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(a.name),
                      subtitle: a.severity != null
                          ? Text('Severity: ${a.severity}')
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteAllergy(a),
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

class _AddAllergySheet extends StatefulWidget {
  const _AddAllergySheet({
    required this.onAdd,
    required this.onCancel,
  });

  final void Function(CreateAllergyRequestDto) onAdd;
  final VoidCallback onCancel;

  @override
  State<_AddAllergySheet> createState() => _AddAllergySheetState();
}

class _AddAllergySheetState extends State<_AddAllergySheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  String? _severity;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      CreateAllergyRequestDto(
        name: _nameController.text.trim(),
        severity: _severity,
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add allergy',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g. Penicillin',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _severity,
                  decoration: const InputDecoration(
                    labelText: 'Severity (optional)',
                  ),
                  items: _severities
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _severity = v),
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
    );
  }
}
