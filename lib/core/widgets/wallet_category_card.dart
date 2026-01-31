import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'pressable_card.dart';
import '../../utils/constants.dart';

/// Wallet category card with completion state and last updated.
class WalletCategoryCard extends StatelessWidget {
  const WalletCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.completionLabel,
    this.lastUpdated,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String? completionLabel;
  final DateTime? lastUpdated;
  final VoidCallback onTap;

  String _formatLastUpdated(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            _IconContainer(
              icon: icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (completionLabel != null || lastUpdated != null)
                    Text(
                      [
                        if (completionLabel != null) completionLabel!,
                        if (lastUpdated != null) _formatLastUpdated(lastUpdated!),
                      ].join(' · '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
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
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusSm),
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }
}
