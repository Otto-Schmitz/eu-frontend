import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Detail screen layout: scrollable form + sticky save button.
class DetailFormScaffold extends StatelessWidget {
  const DetailFormScaffold({
    super.key,
    required this.appBar,
    required this.form,
    required this.onSave,
    this.saveLabel = 'Save',
    this.saving = false,
  });

  final PreferredSizeWidget appBar;
  final Widget form;
  final VoidCallback onSave;
  final String saveLabel;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: form,
            ),
          ),
          _StickySaveBar(
            onSave: onSave,
            label: saveLabel,
            saving: saving,
          ),
        ],
      ),
    );
  }
}

class _StickySaveBar extends StatelessWidget {
  const _StickySaveBar({
    required this.onSave,
    required this.label,
    this.saving = false,
  });

  final VoidCallback onSave;
  final String label;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: saving ? null : onSave,
            child: saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(label),
          ),
        ),
      ),
    );
  }
}
