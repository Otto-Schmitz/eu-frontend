import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../utils/constants.dart';

/// Documents placeholder. Coming soon.
class DocumentsPlaceholderScreen extends StatelessWidget {
  const DocumentsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: EmptyState(
        heading: 'Coming soon',
        message:
            'Store and access important documents securely. This feature is in development.',
        icon: Icons.description_outlined,
      ),
    );
  }
}
