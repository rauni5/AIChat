import 'dart:convert';
import '../../domain/entities/user_stats_entity.dart';

class UserStatsModel extends UserStatsEntity {
  const UserStatsModel({
    required super.uid,
    super.points,
    super.currentStreak,
    super.longestStreak,
    super.totalMessages,
    super.lastActiveDate,
    super.unlockedBadgeIds,
  });

  factory UserStatsModel.initial(String uid) => UserStatsModel(uid: uid);

  factory UserStatsModel.fromJsonString(String uid, String jsonStr) {
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return UserStatsModel(
      uid: uid,
      points: json['points'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      totalMessages: json['totalMessages'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'] as String)
          : null,
      unlockedBadgeIds: List<String>.from(json['unlockedBadgeIds'] as List? ?? []),
    );
  }

  String toJsonString() {
    return jsonEncode({
      'points': points,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalMessages': totalMessages,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'unlockedBadgeIds': unlockedBadgeIds,
    });
  }

  factory UserStatsModel.fromEntity(UserStatsEntity e) => UserStatsModel(
        uid: e.uid,
        points: e.points,
        currentStreak: e.currentStreak,
        longestStreak: e.longestStreak,
        totalMessages: e.totalMessages,
        lastActiveDate: e.lastActiveDate,
        unlockedBadgeIds: e.unlockedBadgeIds,
      );
}
