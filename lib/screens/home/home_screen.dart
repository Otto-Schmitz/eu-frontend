import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/card_tile_widget.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/error_widget.dart' as app;
import '../../state/auth/auth_controller.dart';
import '../../state/emergency/emergency_controller.dart';
import '../../state/health/health_controller.dart';
import '../../state/profile/profile_controller.dart';
import '../../utils/constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    ref.read(profileControllerProvider.notifier).load();
    ref.read(healthControllerProvider.notifier).load();
    ref.read(emergencyControllerProvider.notifier).load();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final health = ref.watch(healthControllerProvider);
    final emergency = ref.watch(emergencyControllerProvider);

    final isLoading =
        profile is ProfileLoading || health is HealthLoading || emergency is EmergencyLoading;
    final hasError =
        profile is ProfileError || health is HealthError || emergency is EmergencyError;
    final errorMsg = profile is ProfileError
        ? profile.message
        : health is HealthError
            ? health.message
            : emergency is EmergencyError
                ? emergency.message
                : '';

    if (isLoading && profile is! ProfileLoaded && health is! HealthLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: const LoadingWidget(),
      );
    }

    if (hasError && profile is! ProfileLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: app.ErrorDisplayWidget(message: errorMsg, onRetry: _load),
      );
    }

    final name = profile is ProfileLoaded
        ? (profile.profile.fullName ?? '')
        : '';
    final healthData = health is HealthLoaded ? health : null;
    final emergencyData = emergency is EmergencyLoaded ? emergency : null;

    final bloodType = healthData?.health.bloodType;
    final mainAllergy = healthData?.allergies.isNotEmpty == true
        ? healthData!.allergies.first.name
        : null;
    final mainContact = emergencyData?.contacts.isNotEmpty == true
        ? emergencyData!.contacts.first
        : null;

    final completeCount = [
      profile is ProfileLoaded && (profile.profile.fullName != null && profile.profile.fullName!.isNotEmpty) ? 1 : 0,
      healthData?.health.bloodType != null ? 1 : 0,
      healthData?.allergies.isNotEmpty == true ? 1 : 0,
      emergencyData?.contacts.isNotEmpty == true ? 1 : 0,
    ].reduce((a, b) => a + b);
    final totalSlots = 4;
    final isComplete = completeCount >= totalSlots;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency),
            onPressed: () => context.push('/emergency'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isNotEmpty ? '$_greeting(), $name' : _greeting(),
                style: Theme.of(context).textTheme.headlineSmall,
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
                    isComplete ? 'Profile complete' : '$completeCount of $totalSlots sections filled',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              CardTileWidget(
                title: 'Blood type',
                subtitle: bloodType ?? 'Not set',
                leading: Icon(
                  Icons.bloodtype,
                  color: Theme.of(context).colorScheme.primary,
                ),
                route: '/details/health',
              ),
              const SizedBox(height: AppSpacing.sm),
              CardTileWidget(
                title: 'Main allergy',
                subtitle: mainAllergy ?? 'None added',
                leading: Icon(
                  Icons.warning_amber_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                route: '/details/allergies',
              ),
              const SizedBox(height: AppSpacing.sm),
              CardTileWidget(
                title: 'Emergency contact',
                subtitle: mainContact != null ? mainContact.name : 'None added',
                leading: Icon(
                  Icons.contact_emergency_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                route: '/details/emergency-contacts',
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => context.push('/wallet'),
                icon: const Icon(Icons.wallet),
                label: const Text('View full wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
