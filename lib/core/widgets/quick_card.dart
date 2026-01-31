import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/constants.dart';
import '../../utils/haptics.dart';

/// Quick card: filled content or empty state with 1-tap CTA.
class QuickCard extends StatelessWidget {
  const QuickCard({
    super.key,
    required this.title,
    this.value,
    this.icon,
    this.emptyMessage = 'Not set',
    this.addLabel = 'Add',
    this.onTap,
    this.onAddTap,
  });

  final String title;
  final String? value;
  final IconData? icon;
  final String emptyMessage;
  final String addLabel;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  bool get hasValue => value != null && value!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          (hasValue ? onTap : onAddTap ?? onTap)?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (hasValue)
                      Text(
                        value!,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    else
                      Row(
                        children: [
                          Text(
                            emptyMessage,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            addLabel,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
