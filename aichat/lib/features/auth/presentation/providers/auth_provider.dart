import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticatedNeedsOnboarding,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    sl.authRepository.authStateChanges().listen((user) {
      if (user == null) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else if (!user.hasCompletedOnboarding) {
        state = AuthState(
          status: AuthStatus.authenticatedNeedsOnboarding,
          user: user,
        );
      } else {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      }
    });
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await sl.signInWithGoogle(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (user) => state = AuthState(
        status: user.hasCompletedOnboarding
            ? AuthStatus.authenticated
            : AuthStatus.authenticatedNeedsOnboarding,
        user: user,
        isLoading: false,
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await sl.signInWithFacebook(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (user) => state = AuthState(
        status: user.hasCompletedOnboarding
            ? AuthStatus.authenticated
            : AuthStatus.authenticatedNeedsOnboarding,
        user: user,
        isLoading: false,
      ),
    );
  }

  Future<void> signOut() async {
    await sl.signOut(const NoParams());
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Called by the onboarding flow once preferences are saved.
  void markOnboardingComplete() {
    if (state.user == null) return;
    state = AuthState(
      status: AuthStatus.authenticated,
      user: UserEntity(
        uid: state.user!.uid,
        email: state.user!.email,
        displayName: state.user!.displayName,
        photoUrl: state.user!.photoUrl,
        hasCompletedOnboarding: true,
      ),
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
