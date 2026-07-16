import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_sign_in_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.auto_awesome, size: 72, color: Colors.indigo),
              const SizedBox(height: 16),
              Text(
                'Your Personalized AI Companion',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to get chat advice tailored to your interests.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              SocialSignInButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                isLoading: authState.isLoading,
                onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
              ),
              const SizedBox(height: 12),
              SocialSignInButton(
                label: 'Continue with Facebook',
                icon: Icons.facebook,
                backgroundColor: const Color(0xFF1877F2),
                foregroundColor: Colors.white,
                isLoading: authState.isLoading,
                onPressed: () => ref.read(authProvider.notifier).signInWithFacebook(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
