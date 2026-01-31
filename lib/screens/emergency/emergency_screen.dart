import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../state/emergency/emergency_controller.dart';
import '../../state/health/health_controller.dart';
import '../../state/profile/profile_controller.dart';
import '../../utils/constants.dart';

/// Read-only emergency view. High contrast, large text. No edit actions.
class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).load();
      ref.read(healthControllerProvider.notifier).load(includeNotes: true);
      ref.read(emergencyControllerProvider.notifier).load();
    });
  }

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final health = ref.watch(healthControllerProvider);
    final emergency = ref.watch(emergencyControllerProvider);

    final isLoading =
        profile is ProfileLoading || health is HealthLoading || emergency is EmergencyLoading;

    if (isLoading &&
        profile is! ProfileLoaded &&
        health is! HealthLoaded &&
        emergency is! EmergencyLoaded) {
      return Scaffold(
        backgroundColor: AppTheme.emergencyBackground,
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.emergencyText),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.emergencyBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Medical ID',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.emergencyText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Name',
                value: profile is ProfileLoaded && profile.profile.fullName != null
                    ? profile.profile.fullName!
                    : '—',
              ),
              _Section(
                title: 'Blood type',
                value: health is HealthLoaded && health.health.bloodType != null
                    ? health.health.bloodType!
                    : '—',
              ),
              if (health is HealthLoaded && health.health.medicalNotes != null) ...[
                _Section(
                  title: 'Medical notes',
                  value: health.health.medicalNotes!,
                ),
              ],
              if (health is HealthLoaded && health.allergies.isNotEmpty) ...[
                _Section(
                  title: 'Allergies',
                  value: health.allergies.map((a) => a.name).join(', '),
                ),
              ],
              if (health is HealthLoaded && health.medications.isNotEmpty) ...[
                _Section(
                  title: 'Medications',
                  value: health.medications.map((m) => m.name).join(', '),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Emergency contacts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.emergencyText,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (emergency is EmergencyLoaded && emergency.contacts.isNotEmpty)
                ...emergency.contacts.map((c) => _ContactTile(
                      name: c.name,
                      phone: c.phone,
                      relationship: c.relationship,
                      onCall: () => _call(c.phone),
                    )),
              if (emergency is! EmergencyLoaded || emergency.contacts.isEmpty)
                Text(
                  'No contacts added',
                  style: TextStyle(color: AppTheme.emergencyText.withOpacity(0.7)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppTheme.emergencyText.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.emergencyText,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.name,
    required this.phone,
    this.relationship,
    required this.onCall,
  });

  final String name;
  final String phone;
  final String? relationship;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.emergencyText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (relationship != null) ...[
                  Text(
                    relationship!,
                    style: TextStyle(
                      color: AppTheme.emergencyText.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
                Text(
                  phone,
                  style: const TextStyle(
                    color: AppTheme.emergencyText,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filled(
            onPressed: onCall,
            icon: const Icon(Icons.call),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.emergencyAccent,
              foregroundColor: AppTheme.emergencyText,
            ),
          ),
        ],
      ),
    );
  }
}
