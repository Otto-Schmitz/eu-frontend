import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/card_tile_widget.dart';
import '../../utils/constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          CardTileWidget(
            title: 'Profile',
            subtitle: 'Name, birth date, phone',
            leading: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            route: '/details/profile',
          ),
          const SizedBox(height: AppSpacing.sm),
          CardTileWidget(
            title: 'Health',
            subtitle: 'Blood type, medical notes',
            leading: Icon(
              Icons.medical_information_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            route: '/details/health',
          ),
          const SizedBox(height: AppSpacing.sm),
          CardTileWidget(
            title: 'Allergies',
            subtitle: 'Manage your allergies',
            leading: Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            route: '/details/allergies',
          ),
          const SizedBox(height: AppSpacing.sm),
          CardTileWidget(
            title: 'Medications',
            subtitle: 'Manage your medications',
            leading: Icon(
              Icons.medication_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            route: '/details/medications',
          ),
          const SizedBox(height: AppSpacing.sm),
          CardTileWidget(
            title: 'Emergency contacts',
            subtitle: 'People to call in an emergency',
            leading: Icon(
              Icons.contact_emergency_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            route: '/details/emergency-contacts',
          ),
          const SizedBox(height: AppSpacing.sm),
          CardTileWidget(
            title: 'Addresses',
            subtitle: 'Home, work, and other addresses',
            leading: Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            route: '/details/addresses',
          ),
        ],
      ),
    );
  }
}
