import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/usecases/check_badges.dart';
import '../../domain/usecases/update_streak.dart';

class GamificationState {
  final UserStatsEntity? stats;
  final List<BadgeEntity> badges;
  final List<String> interests;
  final bool isLoading;

  const GamificationState({
    this.stats,
    this.badges = const [],
    this.interests = const [],
    this.isLoading = false,
  });

  GamificationState copyWith({
    UserStatsEntity? stats,
    List<BadgeEntity>? badges,
    List<String>? interests,
    bool? isLoading,
  }) {
    return GamificationState(
      stats: stats ?? this.stats,
      badges: badges ?? this.badges,
      interests: interests ?? this.interests,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier() : super(const GamificationState());

  final _checkBadges = CheckBadges();

  /// Loads stats once from local storage (no backend to stream from).
  /// Call on login / app start once the uid is known.
  Future<void> loadStats(String uid) async {
    state = state.copyWith(isLoading: true);
    final result = await sl.gamificationRepository.getStats(uid);
    result.fold(
      (_) => state = state.copyWith(isLoading: false),
      (stats) => state = state.copyWith(
        stats: stats,
        badges: _checkBadges.resolveEarned(stats),
        isLoading: false,
      ),
    );
  }

  void setInterests(List<String> interests) {
    state = state.copyWith(interests: interests);
  }

  /// Called after every successfully answered chat message.
  Future<void> recordInteraction(String uid) async {
    final result = await sl.recordInteraction(RecordInteractionParams(uid));
    result.fold(
      (_) {}, // Non-critical path: a failed points update shouldn't block chat.
      (stats) => state = state.copyWith(
        stats: stats,
        badges: _checkBadges.resolveEarned(stats),
      ),
    );
  }
}

final gamificationProvider =
    StateNotifierProvider<GamificationNotifier, GamificationState>(
      (ref) => GamificationNotifier(),
    );
