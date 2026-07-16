/// Raw exceptions thrown by the Data layer (datasources).
/// Repositories catch these and translate them into [Failure]s
/// so Domain stays framework/transport agnostic.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ServerException extends ApiException {
  ServerException([super.message = 'Server error']);
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'No internet connection']);
}

class TimeoutException extends ApiException {
  TimeoutException([super.message = 'Connection timed out']);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Unauthorized'])
      : super(statusCode: 401);
}

class MalformedDataException extends ApiException {
  MalformedDataException([super.message = 'Malformed response data']);
}
