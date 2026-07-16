import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../providers/gamification_provider.dart';
import '../widgets/badge_tile.dart';
import '../widgets/streak_indicator.dart';

String _levelLabel(UserLevel level) {
  switch (level) {
    case UserLevel.beginner:
      return 'Beginner';
    case UserLevel.explorer:
      return 'Explorer';
    case UserLevel.pro:
      return 'Pro';
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamState = ref.watch(gamificationProvider);
    final stats = gamState.stats;
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: stats == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level: ${_levelLabel(stats.level)}',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('${stats.points} points'),
                        const SizedBox(height: 8),
                        StreakIndicator(currentStreak: stats.currentStreak),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Badges', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (gamState.badges.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No badges earned yet — keep chatting!'),
                  )
                else
                  ...gamState.badges.map((b) => BadgeTile(badge: b)),
              ],
            ),
    );
  }
}
