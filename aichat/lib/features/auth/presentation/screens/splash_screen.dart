import 'package:flutter/material.dart';

/// Shown briefly while [authProvider] resolves the initial auth state
/// (AuthStatus.unknown) before the router redirects.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
