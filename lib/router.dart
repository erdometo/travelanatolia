import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelanatolia/features/onboarding/onboarding_screen.dart';
import 'package:travelanatolia/features/assistant/chat_screen.dart';
import 'package:travelanatolia/features/auth/login_screen.dart';
import 'package:travelanatolia/features/auth/auth_provider.dart';
import 'package:travelanatolia/features/explore/explore_screen.dart';
import 'package:travelanatolia/features/profile/profile_screen.dart';
import 'package:travelanatolia/features/itinerary/itinerary_screen.dart';
import 'package:travelanatolia/ui/scaffold_with_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final onboardingCompletedProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return Stream.value(false);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return false;
        final data = snapshot.data();
        return data?['identityProfileUpdated'] == true;
      });
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    // Use the authState and onboardingState to trigger re-evaluations
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider) != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isOnboarding = state.matchedLocation == '/onboarding';

      final onboardingState = ref.read(onboardingCompletedProvider);
      final hasCompletedOnboarding = onboardingState.value ?? false;

      debugPrint('Router Redirect: isLoggedIn=$isLoggedIn, hasCompletedOnboarding=$hasCompletedOnboarding, location=${state.matchedLocation}');

      if (!isLoggedIn) {
        if (!isLoggingIn) return '/login';
        return null;
      }

      // Logged in
      if (isLoggingIn) {
        return hasCompletedOnboarding ? '/' : '/onboarding';
      }

      if (!hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }

      if (hasCompletedOnboarding && isOnboarding) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(child: ChatScreen()),
          ),
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) => const NoTransitionPage(child: ExploreScreen()),
          ),
          GoRoute(
            path: '/itinerary',
            pageBuilder: (context, state) => const NoTransitionPage(child: ItineraryScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authProvider, (previous, next) {
      debugPrint('Auth state changed, updating router');
      notifyListeners();
    });
    ref.listen(onboardingCompletedProvider, (previous, next) {
      debugPrint('Onboarding state changed, updating router');
      notifyListeners();
    });
  }
}
