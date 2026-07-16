import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
/// Data layer catches exceptions and maps them to one of these,
/// so the Domain/Presentation layers never see raw exceptions.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No cached data available.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input.']);
}

class AiServiceFailure extends Failure {
  const AiServiceFailure([super.message = 'AI service is unavailable right now.']);
}
