import '../entities/user_stats_entity.dart';

/// Pure calculation of streak/points rules for a single interaction.
/// Isolated from local storage so it's unit-testable without mocks.
class GamificationRules {
  static const int pointsPerMessage = 10;

  /// Returns the updated stats after one "meaningful interaction"
  /// (one successfully answered chat message), given the previous stats
  /// and "now". Every interaction awards a flat [pointsPerMessage].
  /// Streak logic:
  /// - same calendar day as last active -> streak unchanged
  /// - exactly 1 day after last active -> streak += 1
  /// - gap > 1 day (or no previous activity) -> streak resets to 1
  UserStatsEntity apply(UserStatsEntity previous, DateTime now) {
    final last = previous.lastActiveDate;
    int newStreak;

    if (last == null) {
      newStreak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final today = DateTime(now.year, now.month, now.day);
      final dayDiff = today.difference(lastDay).inDays;

      if (dayDiff == 0) {
        newStreak = previous.currentStreak == 0 ? 1 : previous.currentStreak;
      } else if (dayDiff == 1) {
        newStreak = previous.currentStreak + 1;
      } else {
        newStreak = 1;
      }
    }

    return previous.copyWith(
      points: previous.points + pointsPerMessage,
      currentStreak: newStreak,
      longestStreak: newStreak > previous.longestStreak ? newStreak : previous.longestStreak,
      totalMessages: previous.totalMessages + 1,
      lastActiveDate: now,
    );
  }
}
