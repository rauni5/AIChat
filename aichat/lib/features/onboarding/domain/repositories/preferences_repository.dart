import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_preferences_entity.dart';

abstract class PreferencesRepository {
  Future<Either<Failure, void>> savePreferences(String uid, List<String> interests);
  Future<Either<Failure, UserPreferencesEntity>> getPreferences(String uid);
}
