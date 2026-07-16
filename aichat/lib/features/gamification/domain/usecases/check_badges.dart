import '../entities/badge_entity.dart';
import '../entities/user_stats_entity.dart';

/// Pure rule set mapping stats thresholds -> badge ids. Kept separate from
/// [GamificationRules] (points/streak math) for single-responsibility and
/// independent testability.
class CheckBadges {
  List<String> call(UserStatsEntity stats) {
    final unlocked = <String>{...stats.unlockedBadgeIds};

    if (stats.totalMessages >= 1) unlocked.add('first_question');
    if (stats.totalMessages >= 5) unlocked.add('five_questions');
    if (stats.totalMessages >= 25) unlocked.add('twenty_five_questions');
    if (stats.longestStreak >= 3) unlocked.add('three_day_streak');
    if (stats.longestStreak >= 7) unlocked.add('seven_day_streak');

    return unlocked.toList();
  }

  /// Only the badges the user has actually earned — no locked placeholders.
  List<BadgeEntity> resolveEarned(UserStatsEntity stats) {
    final unlockedIds = call(stats).toSet();
    return BadgeCatalog.all.where((b) => unlockedIds.contains(b.id)).toList();
  }
}
