import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/haptics.dart';

/// Card with press feedback (scale) and ink splash.
class PressableCard extends StatefulWidget {
  const PressableCard({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onPointerUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onPointerCancel: widget.onTap != null ? (_) => _controller.reverse() : null,
      behavior: HitTestBehavior.translucent,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap != null
                ? () {
                    AppHaptics.light();
                    widget.onTap!();
                  }
                : null,
            borderRadius: BorderRadius.circular(AppSpacing.cornerRadius),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
