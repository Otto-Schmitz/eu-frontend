import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/auth/auth_controller.dart';
import '../../state/providers.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/shell/home_tab_screen.dart';
import '../../screens/shell/wallet_tab_screen.dart';
import '../../screens/shell/emergency_tab_screen.dart';
import '../../screens/shell/profile_tab_screen.dart';
import '../../screens/details/health_detail_screen.dart';
import '../../screens/details/allergies_detail_screen.dart';
import '../../screens/details/emergency_contacts_detail_screen.dart';
import '../../screens/details/profile_detail_screen.dart';
import '../../screens/details/addresses_detail_screen.dart';
import '../../screens/details/documents_placeholder_screen.dart';
import '../../screens/details/medications_detail_screen.dart';
import '../../core/widgets/navigation_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) async {
      final auth = ref.read(authControllerProvider);
      final onboarding = ref.read(onboardingStorageProvider);
      final completed = await onboarding.isCompleted();
      final isSplash = state.matchedLocation == '/splash';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isAuth = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');

      if (isSplash) return null;

      if (!completed && !isOnboarding) {
        return '/onboarding';
      }

      if (auth is AuthInitial || auth is AuthLoading) {
        return null;
      }

      if (auth is AuthUnauthenticated && !isAuth && !isOnboarding) {
        return '/login';
      }

      if (auth is AuthAuthenticated && isAuth) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/details/health',
        builder: (_, __) => const HealthDetailScreen(),
      ),
      GoRoute(
        path: '/details/allergies',
        builder: (_, __) => const AllergiesDetailScreen(),
      ),
      GoRoute(
        path: '/details/medications',
        builder: (_, __) => const MedicationsDetailScreen(),
      ),
      GoRoute(
        path: '/details/emergency-contacts',
        builder: (_, __) => const EmergencyContactsDetailScreen(),
      ),
      GoRoute(
        path: '/details/profile',
        builder: (_, __) => const ProfileDetailScreen(),
      ),
      GoRoute(
        path: '/details/addresses',
        builder: (_, __) => const AddressesDetailScreen(),
      ),
      GoRoute(
        path: '/details/documents',
        builder: (_, __) => const DocumentsPlaceholderScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeTabScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: WalletTabScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/emergency',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: EmergencyTabScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileTabScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter(ref);
  ref.listen<AuthState>(authControllerProvider, (_, __) {
    router.refresh();
  });
  return router;
});
