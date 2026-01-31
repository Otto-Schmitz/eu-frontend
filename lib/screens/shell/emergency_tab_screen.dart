import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../data/dto/allergy_dto.dart';
import '../../state/emergency/emergency_controller.dart';
import '../../state/health/health_controller.dart';
import '../../state/profile/profile_controller.dart';
import '../../utils/constants.dart';

/// Emergency tab: read-only, high contrast, large type. No edit actions.
class EmergencyTabScreen extends ConsumerStatefulWidget {
  const EmergencyTabScreen({super.key});

  @override
  ConsumerState<EmergencyTabScreen> createState() => _EmergencyTabScreenState();
}

class _EmergencyTabScreenState extends ConsumerState<EmergencyTabScreen> {
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

  static int? _ageFromBirthDate(String? birthDateStr) {
    if (birthDateStr == null) return null;
    final d = DateTime.tryParse(birthDateStr);
    if (d == null) return null;
    final now = DateTime.now();
    var age = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) {
      age--;
    }
    return age >= 0 ? age : null;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final health = ref.watch(healthControllerProvider);
    final emergency = ref.watch(emergencyControllerProvider);

    final isLoading = profile is ProfileLoading ||
        health is HealthLoading ||
        emergency is EmergencyLoading;

    if (isLoading &&
        profile is! ProfileLoaded &&
        health is! HealthLoaded &&
        emergency is! EmergencyLoaded) {
      return Scaffold(
        backgroundColor: AppTheme.emergencyBackground,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.emergencyText,
            strokeWidth: 2,
          ),
        ),
      );
    }

    final hasName = profile is ProfileLoaded &&
        profile.profile.fullName != null &&
        profile.profile.fullName!.isNotEmpty;
    final hasBloodType = health is HealthLoaded &&
        health.health.bloodType != null &&
        health.health.bloodType != 'UNKNOWN';
    final hasContacts =
        emergency is EmergencyLoaded && emergency.contacts.isNotEmpty;

    final isIncomplete = !hasName || !hasBloodType || !hasContacts;

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
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
              ),
              if (isIncomplete) ...[
                const SizedBox(height: AppSpacing.md),
                _IncompleteNotice(),
                const SizedBox(height: AppSpacing.lg),
              ] else
                const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Name',
                value: profile is ProfileLoaded && profile.profile.fullName != null
                    ? profile.profile.fullName!
                    : '—',
                valueFontSize: 22,
              ),
              _Section(
                title: 'Age',
                value: profile is ProfileLoaded
                    ? (_ageFromBirthDate(profile.profile.birthDate) != null
                        ? '${_ageFromBirthDate(profile.profile.birthDate)} years'
                        : '—')
                    : '—',
                valueFontSize: 22,
              ),
              _Section(
                title: 'Blood type',
                value: health is HealthLoaded &&
                        health.health.bloodType != null &&
                        health.health.bloodType != 'UNKNOWN'
                    ? health.health.bloodType!
                    : '—',
                valueFontSize: 22,
              ),
              if (health is HealthLoaded && health.allergies.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                _AllergiesSection(allergies: health.allergies),
              ] else
                _Section(
                  title: 'Allergies',
                  value: 'None listed',
                  valueFontSize: 20,
                ),
              if (health is HealthLoaded && health.medications.isNotEmpty)
                _Section(
                  title: 'Medications',
                  value: health.medications.map((m) => m.name).join(', '),
                  valueFontSize: 20,
                )
              else
                _Section(
                  title: 'Medications',
                  value: 'None listed',
                  valueFontSize: 20,
                ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Emergency contacts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.emergencyText,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
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
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    'No contacts added',
                    style: TextStyle(
                      color: AppTheme.emergencyText.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IncompleteNotice extends StatelessWidget {
  const _IncompleteNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.emergencyText.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusSm),
        border: Border.all(
          color: AppTheme.emergencyText.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.emergencyText.withOpacity(0.9),
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Data may be incomplete. Update your profile in the app.',
              style: TextStyle(
                color: AppTheme.emergencyText.withOpacity(0.95),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.value,
    this.valueFontSize = 20,
  });

  final String title;
  final String value;
  final double valueFontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppTheme.emergencyText.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.emergencyText,
              fontSize: valueFontSize,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllergiesSection extends StatelessWidget {
  const _AllergiesSection({
    required this.allergies,
  });

  final List<AllergyListItemDto> allergies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allergies'.toUpperCase(),
            style: TextStyle(
              color: AppTheme.emergencyAccent,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppTheme.emergencyAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.cornerRadiusSm),
              border: Border.all(
                color: AppTheme.emergencyAccent.withOpacity(0.6),
                width: 2,
              ),
            ),
            child: Text(
              allergies.map((a) => a.name).join(', '),
              style: const TextStyle(
                color: AppTheme.emergencyText,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
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
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.emergencyText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (relationship != null && relationship!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    relationship!,
                    style: TextStyle(
                      color: AppTheme.emergencyText.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  phone,
                  style: const TextStyle(
                    color: AppTheme.emergencyText,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Material(
            color: AppTheme.emergencyAccent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onCall,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Icon(
                  Icons.call,
                  color: AppTheme.emergencyText,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
