import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/error_widget.dart' as app;
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/health_dto.dart';
import '../../state/health/health_controller.dart';
import '../../utils/constants.dart';

const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'UNKNOWN'];

class HealthDetailScreen extends ConsumerStatefulWidget {
  const HealthDetailScreen({super.key});

  @override
  ConsumerState<HealthDetailScreen> createState() => _HealthDetailScreenState();
}

class _HealthDetailScreenState extends ConsumerState<HealthDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  String? _bloodType;
  bool _hasPopulated = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(healthControllerProvider.notifier).load(includeNotes: true);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _populate(HealthInfoResponseDto h) {
    _bloodType = h.bloodType;
    _notesController.text = h.medicalNotes ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(healthControllerProvider.notifier).updateHealth(
          UpdateHealthRequestDto(
            bloodType: _bloodType ?? 'UNKNOWN',
            medicalNotes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthControllerProvider);

    if (state is HealthLoaded && !_hasPopulated) {
      _hasPopulated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populate(state.health);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: switch (state) {
        HealthLoading() => const LoadingWidget(),
        HealthError(:final message) => app.ErrorDisplayWidget(
            message: message,
            onRetry: () => ref.read(healthControllerProvider.notifier).load(),
          ),
        HealthLoaded() => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _bloodType ?? 'UNKNOWN',
                    decoration: const InputDecoration(labelText: 'Blood type'),
                    items: _bloodTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => _bloodType = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Medical notes (optional)',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        _ => const LoadingWidget(),
      },
    );
  }
}
