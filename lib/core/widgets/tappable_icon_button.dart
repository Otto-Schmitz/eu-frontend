import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/haptics.dart';

/// IconButton with min 48dp touch target for accessibility (WCAG).
class TappableIconButton extends StatelessWidget {
  const TappableIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.useMediumHaptic = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool useMediumHaptic;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed == null ? null : () {
        if (useMediumHaptic) {
          AppHaptics.medium();
        } else {
          AppHaptics.light();
        }
        onPressed!();
      },
      tooltip: tooltip,
      style: IconButton.styleFrom(
        minimumSize: const Size(
          AppSpacing.minTouchTarget,
          AppSpacing.minTouchTarget,
        ),
      ),
    );
    return tooltip != null
        ? Tooltip(message: tooltip!, child: button)
        : button;
  }
}
