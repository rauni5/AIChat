import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/save_preferences.dart';

class OnboardingState {
  final Set<String> selectedInterests;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;

  const OnboardingState({
    this.selectedInterests = const {},
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    Set<String>? selectedInterests,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
  }) {
    return OnboardingState(
      selectedInterests: selectedInterests ?? this.selectedInterests,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void toggleInterest(String interest) {
    final updated = Set<String>.from(state.selectedInterests);
    if (updated.contains(interest)) {
      updated.remove(interest);
    } else {
      updated.add(interest);
    }
    state = state.copyWith(selectedInterests: updated, errorMessage: null);
  }

  Future<void> submit(String uid) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await sl.savePreferences(
      SavePreferencesParams(uid: uid, interests: state.selectedInterests.toList()),
    );
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message),
      (_) => state = state.copyWith(isLoading: false, isSaved: true),
    );
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);
