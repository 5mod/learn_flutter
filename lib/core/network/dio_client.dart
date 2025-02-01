import 'package:dio/dio.dart';
import 'package:learn_flutter/core/constants/api_endpoints.dart';
import 'package:learn_flutter/core/errors/exceptions.dart';

class DioClient {
  late Dio _dio;
  
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
    
    _initializeInterceptors();
  }
  
  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // You can modify request here (add headers, tokens, etc.)
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            throw NetworkException(
              message: 'Connection timeout. Please check your internet connection.',
            );
          }

          if (e.response != null) {
            throw ServerException(
              message: e.response?.data['message'] ?? 'Something went wrong',
              statusCode: e.response?.statusCode,
            );
          }

          throw NetworkException(
            message: 'Network error occurred. Please check your internet connection.',
          );
        },
      ),
    );
  }
  
  Dio get instance => _dio;
} 