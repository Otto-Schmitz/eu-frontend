import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/detail_form_scaffold.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/profile_dto.dart';
import '../../state/profile/profile_controller.dart';
import '../../utils/constants.dart';

/// Profile: name, birthdate, workplace. Minimal form, sticky save.
class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  ConsumerState<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _workplaceController;
  DateTime? _birthDate;
  bool _hasPopulated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthDateController = TextEditingController();
    _workplaceController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _workplaceController.dispose();
    super.dispose();
  }

  void _populateFromProfile(ProfileResponseDto p) {
    _nameController.text = p.fullName ?? '';
    _birthDate = p.birthDate != null ? DateTime.tryParse(p.birthDate!) : null;
    _birthDateController.text = _birthDate != null
        ? DateFormat.yMMMd().format(_birthDate!)
        : '';
    _workplaceController.text = p.workplace ?? '';
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        _birthDate = d;
        _birthDateController.text = DateFormat.yMMMd().format(d);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(profileControllerProvider.notifier).update(
          UpdateProfileRequestDto(
            fullName: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            birthDate: _birthDate != null
                ? DateFormat('yyyy-MM-dd').format(_birthDate!)
                : null,
            workplace: _workplaceController.text.trim().isEmpty
                ? null
                : _workplaceController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);

    if (state is ProfileLoaded && !_hasPopulated) {
      _hasPopulated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _populateFromProfile(state.profile);
      });
    }

    final isInitialLoading = state is ProfileLoading && !_hasPopulated;
    final isSaving = state is ProfileLoading && _hasPopulated;

    if (isInitialLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state is ProfileError) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: ErrorState(
            message: state.message,
            onRetry: () => ref.read(profileControllerProvider.notifier).load(),
          ),
        );
    }

    return DetailFormScaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          form: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Field(
                  controller: _nameController,
                  label: 'Name',
                  hint: 'Your full name',
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: AppSpacing.md),
                Field(
                  controller: _birthDateController,
                  label: 'Birth date',
                  readOnly: true,
                  onTap: _pickDate,
                  suffixIcon: const Icon(Icons.calendar_today, size: 20),
                ),
                const SizedBox(height: AppSpacing.md),
                Field(
                  controller: _workplaceController,
                  label: 'Workplace',
                  hint: 'Company or employer (optional)',
                  textCapitalization: TextCapitalization.words,
                ),
              ],
            ),
          ),
          onSave: _save,
          saving: isSaving,
        );
  }
}
