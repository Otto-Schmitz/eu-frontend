import 'package:flutter/material.dart';

import '../../utils/constants.dart';

/// Full-screen loading indicator.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
