import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_widget.dart';
import '../../core/widgets/error_widget.dart' as app;
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/allergy_dto.dart';
import '../../state/health/health_controller.dart';
import '../../utils/constants.dart';

const _severities = ['LOW', 'MEDIUM', 'HIGH'];

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
    final result = await showDialog<CreateAllergyRequestDto>(
      context: context,
      builder: (ctx) => const _AddAllergyDialog(),
    );
    if (result != null && mounted) {
      await ref.read(healthControllerProvider.notifier).addAllergy(result);
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
        HealthLoading() => const LoadingWidget(),
        HealthError(:final message) => app.ErrorDisplayWidget(
            message: message,
            onRetry: () => ref.read(healthControllerProvider.notifier).load(),
          ),
        HealthLoaded(health: _, allergies: final list) => list.isEmpty
            ? const EmptyWidget(
                message: 'No allergies added.\nTap + to add one.',
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
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Remove allergy?'),
                              content: Text(
                                  'Remove ${a.name} from your list?'),
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
                          if (ok == true &&
                              a.id != null &&
                              mounted) {
                            await ref
                                .read(healthControllerProvider.notifier)
                                .removeAllergy(a.id!);
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

class _AddAllergyDialog extends StatefulWidget {
  const _AddAllergyDialog();

  @override
  State<_AddAllergyDialog> createState() => _AddAllergyDialogState();
}

class _AddAllergyDialogState extends State<_AddAllergyDialog> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add allergy'),
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
              DropdownButtonFormField<String>(
                value: _severity,
                decoration: const InputDecoration(labelText: 'Severity (optional)'),
                items: _severities
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _severity = v),
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
                CreateAllergyRequestDto(
                  name: _nameController.text.trim(),
                  severity: _severity,
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
