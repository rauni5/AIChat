import 'package:dio/dio.dart';
import 'api_exception.dart';

/// Centralized Dio configuration used by every remote datasource
/// that talks to a REST API (Gemini). Firebase SDKs use
/// their own transport and don't go through this client.
class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  /// Wraps a request, converting Dio-level failures into our own
  /// [ApiException] hierarchy so the rest of the app never sees Dio types.
  Future<Response<T>> safeRequest<T>(
      Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeoutException();
        case DioExceptionType.connectionError:
          throw NetworkException();
        case DioExceptionType.badResponse:
          final code = e.response?.statusCode ?? 500;
          if (code == 401 || code == 403) throw UnauthorizedException();
          throw ServerException(
            e.response?.data?.toString() ?? 'Server error',
          );
        default:
          throw ServerException(e.message ?? 'Unknown error');
      }
    } catch (e) {
      throw MalformedDataException(e.toString());
    }
  }
}
