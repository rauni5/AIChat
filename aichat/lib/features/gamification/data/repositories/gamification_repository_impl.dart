import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../../domain/usecases/award_points.dart';
import '../../domain/usecases/check_badges.dart';
import '../datasources/gamification_remote_data_source.dart';
import '../models/user_stats_model.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationRemoteDataSource remoteDataSource;
  final GamificationRules rules;
  final CheckBadges checkBadges;

  GamificationRepositoryImpl({
    required this.remoteDataSource,
    GamificationRules? rules,
    CheckBadges? checkBadges,
  })  : rules = rules ?? GamificationRules(),
        checkBadges = checkBadges ?? CheckBadges();

  @override
  Future<Either<Failure, UserStatsEntity>> getStats(String uid) async {
    try {
      final stats = await remoteDataSource.getStats(uid);
      return Right(stats);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserStatsEntity>> recordInteraction(String uid) async {
    try {
      final current = await remoteDataSource.getStats(uid);
      final withPointsAndStreak = rules.apply(current, DateTime.now());
      final unlockedBadgeIds = checkBadges(withPointsAndStreak);
      final updated = withPointsAndStreak.copyWith(unlockedBadgeIds: unlockedBadgeIds);

      await remoteDataSource.saveStats(UserStatsModel.fromEntity(updated));
      return Right(updated);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
