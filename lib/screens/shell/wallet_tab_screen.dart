import 'package:flutter/material.dart';

import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/empty_state.dart';
import '../../utils/constants.dart';

/// Dummy Wallet tab.
class WalletTabScreen extends StatelessWidget {
  const WalletTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Wallet',
      body: AppScaffoldBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your wallet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xxl),
            const EmptyState(
              message: 'Wallet content will appear here.\nHealth, contacts, addresses.',
              icon: Icons.wallet_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
