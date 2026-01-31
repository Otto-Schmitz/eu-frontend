import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Empty state with icon, heading, message, and optional action.
/// Accessible: semantic structure, supports font scaling.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.heading,
    this.icon,
    this.action,
  });

  final String message;
  final String? heading;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 56,
              color: iconColor,
              semanticLabel: heading ?? 'Empty',
            ),
            const SizedBox(height: AppSpacing.lg),
            if (heading != null) ...[
              Text(
                heading!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    height: 1.4,
                  ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Semantics(
                button: true,
                child: action!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
