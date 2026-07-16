import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_preferences_entity.dart';
import '../repositories/preferences_repository.dart';

class GetPreferencesParams {
  final String uid;
  const GetPreferencesParams(this.uid);
}

class GetPreferences implements UseCase<UserPreferencesEntity, GetPreferencesParams> {
  final PreferencesRepository repository;
  GetPreferences(this.repository);

  @override
  Future<Either<Failure, UserPreferencesEntity>> call(GetPreferencesParams params) {
    return repository.getPreferences(params.uid);
  }
}
