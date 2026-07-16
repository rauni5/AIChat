import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Every use case in every feature implements this. `Type` is the success
/// return type, `Params` is the input. Returning `Either<Failure, Type>`
/// forces callers to explicitly handle the error path.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// For use cases that take no parameters.
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
