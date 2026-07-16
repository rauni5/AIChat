import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/user_preferences_entity.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../datasources/preferences_remote_data_source.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferencesRemoteDataSource remoteDataSource;
  PreferencesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> savePreferences(String uid, List<String> interests) async {
    try {
      await remoteDataSource.savePreferences(uid, interests);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> getPreferences(String uid) async {
    try {
      final prefs = await remoteDataSource.getPreferences(uid);
      return Right(prefs);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
