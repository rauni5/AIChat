import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/preferences_repository.dart';

class SavePreferencesParams {
  final String uid;
  final List<String> interests;
  const SavePreferencesParams({required this.uid, required this.interests});
}

class SavePreferences implements UseCase<void, SavePreferencesParams> {
  final PreferencesRepository repository;
  SavePreferences(this.repository);

  @override
  Future<Either<Failure, void>> call(SavePreferencesParams params) {
    if (params.interests.isEmpty) {
      return Future.value(
        const Left(ValidationFailure('Select at least one interest to continue.')),
      );
    }
    return repository.savePreferences(params.uid, params.interests);
  }
}
