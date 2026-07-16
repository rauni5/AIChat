import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_stats_entity.dart';

/// Local-only stats: points, streak, badges, level. There is no shared
/// backend, so there's intentionally no leaderboard-across-users method
/// here — a real leaderboard needs data visible to more than one device.
abstract class GamificationRepository {
  Future<Either<Failure, UserStatsEntity>> getStats(String uid);

  /// Applies points/streak/badge updates for one interaction and returns
  /// the resulting stats.
  Future<Either<Failure, UserStatsEntity>> recordInteraction(String uid);
}
