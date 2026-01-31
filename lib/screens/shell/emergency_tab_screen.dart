import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../utils/constants.dart';

/// Dummy Emergency tab. High-contrast style.
class EmergencyTabScreen extends StatelessWidget {
  const EmergencyTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Emergency',
      body: Container(
        color: AppTheme.emergencyBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical ID',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.emergencyText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Emergency information will appear here. Large text, high contrast, read-only.',
                  style: TextStyle(
                    color: AppTheme.emergencyText.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
