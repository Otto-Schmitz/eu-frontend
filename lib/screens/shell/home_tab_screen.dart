import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/quick_card.dart';
import '../../core/widgets/loading_skeleton.dart';
import '../../core/widgets/error_banner.dart';
import '../../state/home/home_controller.dart';
import '../../state/home/home_data.dart';
import '../../utils/constants.dart';

/// Home: greeting, completion indicator, 3 quick cards with empty states.
class HomeTabScreen extends ConsumerStatefulWidget {
  const HomeTabScreen({super.key});

  @override
  ConsumerState<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends ConsumerState<HomeTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).load();
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);

    return AppScaffold(
      title: 'Home',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state is HomeError)
            ErrorBanner(
              message: state.message,
              onRetry: () => ref.read(homeControllerProvider.notifier).load(),
            ),
          Expanded(
            child: switch (state) {
              HomeLoading() => const HomeSkeleton(),
              HomeError() => Center(
                  child: TextButton(
                    onPressed: () =>
                        ref.read(homeControllerProvider.notifier).load(),
                    child: const Text('Tap to retry'),
                  ),
                ),
              HomeLoaded(:final data) => _HomeContent(
                  greeting: _greeting(),
                  displayName: data.displayName,
                  filledCount: data.filledCount,
                  totalSlots: HomeData.totalSlots,
                  isComplete: data.isComplete,
                  bloodType: data.bloodType,
                  allergiesSummary: data.allergiesSummary,
                  mainContact: data.mainEmergencyContact,
                  onRefresh: () =>
                      ref.read(homeControllerProvider.notifier).load(),
                ),
              _ => const HomeSkeleton(),
            },
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.greeting,
    this.displayName,
    required this.filledCount,
    required this.totalSlots,
    required this.isComplete,
    this.bloodType,
    this.allergiesSummary,
    this.mainContact,
    required this.onRefresh,
  });

  final String greeting;
  final String? displayName;
  final int filledCount;
  final int totalSlots;
  final bool isComplete;
  final String? bloodType;
  final String? allergiesSummary;
  final MainEmergencyContact? mainContact;
  final VoidCallback onRefresh;

  String? get _bloodTypeDisplay {
    if (bloodType == null || bloodType!.isEmpty) return null;
    if (bloodType == 'UNKNOWN') return null;
    return bloodType;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName != null && displayName!.isNotEmpty
                  ? '$greeting, $displayName'
                  : greeting,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  isComplete ? Icons.check_circle : Icons.info_outline,
                  size: 18,
                  color: isComplete
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  isComplete
                      ? 'Profile complete'
                      : '$filledCount of $totalSlots sections filled',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            QuickCard(
              title: 'Blood type',
              value: _bloodTypeDisplay,
              icon: Icons.bloodtype,
              emptyMessage: 'Add your blood type for emergencies',
              addLabel: 'Add',
              onTap: () => context.push('/details/health'),
              onAddTap: () => context.push('/details/health'),
            ),
            const SizedBox(height: AppSpacing.sm),
            QuickCard(
              title: 'Allergies',
              value: allergiesSummary,
              icon: Icons.warning_amber_outlined,
              emptyMessage: 'Important for first responders',
              addLabel: 'Add',
              onTap: () => context.push('/details/allergies'),
              onAddTap: () => context.push('/details/allergies'),
            ),
            const SizedBox(height: AppSpacing.sm),
            QuickCard(
              title: 'Emergency contact',
              value: mainContact?.name,
              icon: Icons.contact_emergency_outlined,
              emptyMessage: 'Who to call in an emergency',
              addLabel: 'Add',
              onTap: () => context.push('/details/emergency-contacts'),
              onAddTap: () => context.push('/details/emergency-contacts'),
            ),
          ],
        ),
      ),
    );
  }
}
