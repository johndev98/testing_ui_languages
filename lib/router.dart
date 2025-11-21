import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'onboarding/onboarding_main.dart';
import 'onboarding/summary_screen.dart';
import 'onboarding/providers/user_profile_provider.dart';

// Provider for GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  // Read profile once to determine initial location
  final initialProfile = ref.read(userProfileProvider);
  final initialLocation = _isOnboardingCompleted(initialProfile)
      ? '/summary'
      : '/';

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'onboarding',
        pageBuilder: (context, state) =>
            const CupertinoPage(child: OnboardingMain()),
      ),
      GoRoute(
        path: '/summary',
        name: 'summary',
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SummaryScreen()),
      ),
    ],
    redirect: (context, state) {
      // Check if user explicitly wants to edit (from "Cập nhật" button)
      final isEditMode = state.uri.queryParameters['edit'] == 'true';

      // Don't redirect if in edit mode
      if (isEditMode) {
        return null;
      }

      // Only check when navigating between main routes
      // Don't interfere with PageView navigation inside OnboardingMain
      final userProfile = ref.read(userProfileProvider);
      final isOnboardingCompleted = _isOnboardingCompleted(userProfile);
      final isOnOnboardingPage = state.matchedLocation == '/';

      // If onboarding completed and user is on onboarding page, redirect to summary
      if (isOnboardingCompleted && isOnOnboardingPage) {
        return '/summary';
      }

      // If onboarding not completed and user tries to access summary, redirect to onboarding
      if (!isOnboardingCompleted && !isOnOnboardingPage) {
        return '/';
      }

      return null; // No redirect needed
    },
  );
});

// Helper function to check if onboarding is completed
bool _isOnboardingCompleted(dynamic userProfile) {
  if (userProfile == null) return false;

  // Check if all required fields are filled
  return userProfile.gender != null &&
      userProfile.weight != null &&
      userProfile.height != null &&
      userProfile.birthYear != null &&
      userProfile.activityLevel != null &&
      userProfile.goal != null &&
      userProfile.diet != null;
}
