import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/interest_chip.dart';

class InterestSelectionScreen extends ConsumerWidget {
  const InterestSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final authState = ref.watch(authProvider);

    ref.listen(onboardingProvider, (previous, next) {
      if (next.isSaved && previous?.isSaved != true) {
        // Flip auth state so go_router redirects into the chat shell.
        ref.read(authProvider.notifier).markOnboardingComplete();
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('What are you into?')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pick a few interests so your AI companion can personalize its advice.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.availableInterests.map((interest) {
                return InterestChip(
                  label: interest,
                  selected: state.selectedInterests.contains(interest),
                  onTap: () => ref.read(onboardingProvider.notifier).toggleInterest(interest),
                );
              }).toList(),
            ),
            const Spacer(),
            FilledButton(
              onPressed: state.isLoading || authState.user == null
                  ? null
                  : () => ref.read(onboardingProvider.notifier).submit(authState.user!.uid),
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
