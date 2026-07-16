import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/gamification/presentation/screens/profile_screen.dart';
import '../../features/onboarding/presentation/screens/interest_selection_screen.dart';

/// Central route table + auth-aware redirect. This is the single place
/// that decides which screen a given [AuthStatus] is allowed to see —
/// individual screens don't need to guard themselves.
///
/// IMPORTANT: this provider must build the GoRouter exactly once. It must
/// NOT `ref.watch(authProvider)` at the top level — doing so recreates the
/// entire GoRouter (and resets it to `initialLocation: '/'`, the splash
/// screen) on every auth change, which is what caused the "stuck on
/// loading after onboarding" bug: a fresh router landed on '/' with no
/// rule to route it anywhere else. Instead, `redirect` reads the *current*
/// auth status via `ref.read` each time it runs, and `refreshListenable`
/// is what tells the *same* router instance to re-run `redirect` whenever
/// auth state changes.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthStatusListenable(ref),
    redirect: (context, state) {
      final status = ref.read(authProvider).status;
      final location = state.matchedLocation;

      if (status == AuthStatus.unknown) {
        // Still resolving the initial Firebase Auth state — stay on splash.
        return null;
      }

      if (status == AuthStatus.unauthenticated) {
        return location == '/login' ? null : '/login';
      }

      if (status == AuthStatus.authenticatedNeedsOnboarding) {
        return location == '/onboarding' ? null : '/onboarding';
      }

      // status == authenticated: leave splash/login/onboarding for /chat.
      // Explicitly including '/' here is what fixes the stuck-splash bug.
      if (location == '/' ||
          location == '/login' ||
          location == '/onboarding') {
        return '/chat';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const InterestSelectionScreen(),
      ),
      GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
      GoRoute(
          path: '/profile', builder: (context, state) => const ProfileScreen()),
    ],
  );
});

/// Bridges Riverpod's provider updates into a [Listenable] go_router can
/// subscribe to via `refreshListenable`, without causing the provider
/// itself to rebuild (see note above on why that matters).
class _AuthStatusListenable extends ChangeNotifier {
  _AuthStatusListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
