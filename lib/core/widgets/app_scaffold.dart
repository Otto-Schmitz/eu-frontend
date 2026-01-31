import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Standard app scaffold with optional title and actions.
/// Consistent padding and safe area.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.actions,
    this.leading,
    required this.body,
    this.floatingActionButton,
  });

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              leading: leading,
              actions: actions,
            )
          : null,
      body: SafeArea(
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Scrollable body with consistent padding.
class AppScaffoldBody extends StatelessWidget {
  const AppScaffoldBody({
    super.key,
    required this.child,
    this.padding,
    this.refreshIndicator,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Future<void> Function()? refreshIndicator;

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    );
    if (refreshIndicator != null) {
      return RefreshIndicator(onRefresh: refreshIndicator!, child: content);
    }
    return content;
  }
}
