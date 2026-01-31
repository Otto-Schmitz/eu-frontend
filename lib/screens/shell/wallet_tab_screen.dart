import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/wallet_category_card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_banner.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../state/wallet/wallet_controller.dart';
import '../../state/wallet/wallet_data.dart';
import '../../utils/constants.dart';

/// Wallet: category cards with completion state and last updated.
class WalletTabScreen extends ConsumerStatefulWidget {
  const WalletTabScreen({super.key});

  @override
  ConsumerState<WalletTabScreen> createState() => _WalletTabScreenState();
}

class _WalletTabScreenState extends ConsumerState<WalletTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(walletControllerProvider);

    return AppScaffold(
      title: 'Wallet',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state is WalletError)
            ErrorBanner(
              message: state.message,
              onRetry: () => ref.read(walletControllerProvider.notifier).load(),
            ),
          Expanded(
            child: switch (state) {
              WalletLoading() => const WalletSkeleton(),
              WalletError() => Center(
                  child: TextButton(
                    onPressed: () =>
                        ref.read(walletControllerProvider.notifier).load(),
                    child: const Text('Tap to retry'),
                  ),
                ),
              WalletLoaded(:final data) => data.categories.isEmpty
                  ? EmptyState(
                      heading: 'Nothing here yet',
                      message:
                          'Your information wallet will show categories once data loads. Pull to refresh.',
                      icon: Icons.wallet_outlined,
                    )
                  : _WalletContent(
                      categories: data.categories,
                      onRefresh: () =>
                          ref.read(walletControllerProvider.notifier).load(),
                    ),
              _ => const WalletSkeleton(),
            },
          ),
        ],
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  const _WalletContent({
    required this.categories,
    required this.onRefresh,
  });

  final List<WalletCategory> categories;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return WalletCategoryCard(
            title: cat.title,
            icon: cat.icon,
            completionLabel: cat.completionLabel,
            lastUpdated: cat.lastUpdated,
            onTap: () => context.push(cat.route),
          );
        },
      ),
    );
  }
}

class WalletSkeleton extends StatelessWidget {
  const WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, __) => const SkeletonCard(),
    );
  }
}
