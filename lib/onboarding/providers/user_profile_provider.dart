import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_profile.dart';
import '../services/isar_service.dart';

// Provider to track if profile is still loading
final isProfileLoadingProvider = StateProvider<bool>((ref) => true);

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
      (ref) => UserProfileNotifier(ref),
    );

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;

  UserProfileNotifier(this.ref) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final loaded = await IsarService.getUserProfile();
    state = loaded; // Can be null if user hasn't started onboarding

    // Mark loading as complete
    ref.read(isProfileLoadingProvider.notifier).state = false;
  }

  Future<void> _save() async {
    if (state == null) return;
    await IsarService.saveUserProfile(state!);
    // update state reference (in case Isar mutated id)
    state = await IsarService.getUserProfile();
  }

  // Update helpers
  Future<void> updateGender(String g) async {
    state = (state ?? UserProfile())..gender = g;
    await _save();
  }

  Future<void> updateWeight(double w) async {
    final oldWeight = state?.weight;
    final oldTargetWeight = state?.targetWeight;

    state = (state ?? UserProfile())..weight = w;

    // If targetWeight was null or equal to old weight (maintain mode),
    // update targetWeight to match new weight
    if (oldTargetWeight == null || oldTargetWeight == oldWeight) {
      state!.targetWeight = w;
    }

    await _save();
  }

  Future<void> updateHeight(int h) async {
    state = (state ?? UserProfile())..height = h;
    await _save();
  }

  Future<void> updateBirthYear(int y) async {
    state = (state ?? UserProfile())..birthYear = y;
    await _save();
  }

  Future<void> updateGoal(String g) async {
    state = (state ?? UserProfile())..goal = g;
    // keep targetWeight consistent
    if (state!.targetWeight == null && state!.weight != null) {
      state!.targetWeight = state!.weight;
    }
    await _save();
  }

  Future<void> updateTargetWeight(double t) async {
    state = (state ?? UserProfile())..targetWeight = t;
    // update goal based on relation to current weight
    final current = state!.weight ?? t;
    if (t == current) {
      state!.goal = 'maintain';
    } else if (t < current) {
      state!.goal = 'lose';
    } else {
      state!.goal = 'gain';
    }
    await _save();
  }

  Future<void> updateDiet(String d) async {
    state = (state ?? UserProfile())..diet = d;
    await _save();
  }

  Future<void> updateSpeed(double s) async {
    state = (state ?? UserProfile())..speed = s;
    await _save();
  }

  Future<void> updateActivityLevel(int ac) async {
    state = (state ?? UserProfile())..activityLevel = ac;
    await _save();
  }

  // Extras for google
  Future<void> updateGoogleInfo({
    String? googleId,
    String? name,
    String? avatarUrl,
  }) async {
    state = (state ?? UserProfile())
      ..googleId = googleId ?? state!.googleId
      ..name = name ?? state!.name
      ..avatarUrl = avatarUrl ?? state!.avatarUrl;
    await _save();
  }
}
