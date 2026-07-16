import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_stats_entity.dart';
import '../repositories/gamification_repository.dart';

/// Records one meaningful interaction (chat message answered). The
/// repository implementation combines [GamificationRules] + [CheckBadges]
/// against the locally stored stats.
class RecordInteractionParams {
  final String uid;
  const RecordInteractionParams(this.uid);
}

class RecordInteraction implements UseCase<UserStatsEntity, RecordInteractionParams> {
  final GamificationRepository repository;
  RecordInteraction(this.repository);

  @override
  Future<Either<Failure, UserStatsEntity>> call(RecordInteractionParams params) {
    return repository.recordInteraction(params.uid);
  }
}
