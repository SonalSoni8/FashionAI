import 'package:dio/dio.dart';
import '../errors/failure.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.aura.ai/v1',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {}, // Silent in production
      ),
    );
  }

  Future<Result<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) decoder,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(
        ServerFailure(message: e.toString()),
      );
    }
  }

  Future<Result<T>> post<T>({
    required String path,
    dynamic data,
    required T Function(dynamic data) decoder,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return Result.success(decoder(response.data));
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(
        ServerFailure(message: e.toString()),
      );
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error occurred.';
        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(message: message);
        }
        return ServerFailure(message: message, code: '$statusCode');
      default:
        return ServerFailure(message: error.message ?? 'Unexpected network error.');
    }
  }
}
