import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/local_storage_service.dart';
import '../../../../core/network/api_exception.dart';
import '../models/user_stats_model.dart';

/// Local-only stats storage — no backend, no cross-device sync.
abstract class GamificationRemoteDataSource {
  Future<UserStatsModel> getStats(String uid);
  Future<void> saveStats(UserStatsModel stats);
}

class GamificationRemoteDataSourceImpl implements GamificationRemoteDataSource {
  final LocalStorageService _localStorage;
  GamificationRemoteDataSourceImpl({LocalStorageService? localStorage})
      : _localStorage = localStorage ?? LocalStorageService();

  @override
  Future<UserStatsModel> getStats(String uid) async {
    try {
      final raw = await _localStorage.getString(AppConstants.statsKey(uid));
      if (raw == null) return UserStatsModel.initial(uid);
      return UserStatsModel.fromJsonString(uid, raw);
    } catch (e) {
      throw ServerException('Failed to load stats: $e');
    }
  }

  @override
  Future<void> saveStats(UserStatsModel stats) async {
    try {
      await _localStorage.setString(
        AppConstants.statsKey(stats.uid),
        stats.toJsonString(),
      );
    } catch (e) {
      throw ServerException('Failed to save stats: $e');
    }
  }
}
