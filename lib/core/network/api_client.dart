import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:pos_app/core/config/api_config.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/providers/local_storage_provider.dart';

/// HTTP client wrapper around Dio for communicating with the FastAPI backend.
class ApiClient {
  final Dio _dio;
  final LocalStorageService _localStorage;

  ApiClient(this._localStorage)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _localStorage.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          developer.log(
            'ApiClient: ${options.method} ${options.path}',
            name: 'ApiClient',
          );
          handler.next(options);
        },
        onError: (error, handler) {
          developer.log(
            'ApiClient: Error ${error.response?.statusCode} - ${error.message}',
            name: 'ApiClient',
          );
          handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST form-urlencoded (used for OAuth2 login)
  Future<dynamic> postForm(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: FormData.fromMap(data),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    String message;

    if (e.response?.data is Map<String, dynamic>) {
      message =
          (e.response!.data as Map<String, dynamic>)['detail']?.toString() ??
          e.message ??
          'Unknown error';
    } else if (e.response?.data is String) {
      message = e.response!.data as String;
    } else {
      message = e.message ?? 'Network error';
    }

    return ApiException(statusCode: statusCode, message: message);
  }
}
