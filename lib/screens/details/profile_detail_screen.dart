import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/empty_widget.dart';
import '../../core/widgets/error_widget.dart' as app;
import '../../core/widgets/loading_widget.dart';
import '../../data/dto/profile_dto.dart';
import '../../state/profile/profile_controller.dart';
import '../../utils/constants.dart';

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  ConsumerState<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  late TextEditingController _phoneController;
  late TextEditingController _workplaceController;
  DateTime? _birthDate;
  bool _hasPopulated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthDateController = TextEditingController();
    _phoneController = TextEditingController();
    _workplaceController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _workplaceController.dispose();
    super.dispose();
  }

  void _populateFromProfile(ProfileResponseDto p) {
    _nameController.text = p.fullName ?? '';
    _birthDate = p.birthDate != null ? DateTime.tryParse(p.birthDate!) : null;
    _birthDateController.text = _birthDate != null
        ? DateFormat.yMMMd().format(_birthDate!)
        : '';
    _phoneController.text = p.phone ?? '';
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
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: switch (state) {
        ProfileLoading() => const LoadingWidget(),
        ProfileError(:final message) => app.ErrorDisplayWidget(
            message: message,
            onRetry: () => ref.read(profileControllerProvider.notifier).load(),
          ),
        ProfileLoaded(:final profile) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full name'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Birth date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickDate,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone (optional)'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _workplaceController,
                    decoration: const InputDecoration(labelText: 'Workplace (optional)'),
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
