import 'package:equatable/equatable.dart';

enum UserLevel { beginner, explorer, pro }

class UserStatsEntity extends Equatable {
  final String uid;
  final int points;
  final int currentStreak;
  final int longestStreak;
  final int totalMessages;
  final DateTime? lastActiveDate;
  final List<String> unlockedBadgeIds;

  const UserStatsEntity({
    required this.uid,
    this.points = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalMessages = 0,
    this.lastActiveDate,
    this.unlockedBadgeIds = const [],
  });

  UserLevel get level {
    if (points >= 500) return UserLevel.pro;
    if (points >= 100) return UserLevel.explorer;
    return UserLevel.beginner;
  }

  /// Points needed to reach the next level; null if already at max level.
  int? get pointsToNextLevel {
    switch (level) {
      case UserLevel.beginner:
        return 100 - points;
      case UserLevel.explorer:
        return 500 - points;
      case UserLevel.pro:
        return null;
    }
  }

  UserStatsEntity copyWith({
    int? points,
    int? currentStreak,
    int? longestStreak,
    int? totalMessages,
    DateTime? lastActiveDate,
    List<String>? unlockedBadgeIds,
  }) {
    return UserStatsEntity(
      uid: uid,
      points: points ?? this.points,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalMessages: totalMessages ?? this.totalMessages,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    );
  }

  @override
  List<Object?> get props =>
      [uid, points, currentStreak, longestStreak, totalMessages, lastActiveDate, unlockedBadgeIds];
}
