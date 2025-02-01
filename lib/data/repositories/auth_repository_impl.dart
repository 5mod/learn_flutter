import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart' as dio show FormData, MultipartFile;
import 'package:get/get.dart';
import 'package:learn_flutter/core/constants/api_endpoints.dart';
import 'package:learn_flutter/core/errors/exceptions.dart';
import 'package:learn_flutter/core/errors/failures.dart';
import 'package:learn_flutter/core/network/dio_client.dart';
import 'package:learn_flutter/domain/repositories/auth_repository.dart';
import 'package:learn_flutter/presentation/controllers/auth_controller.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient dioClient;

  AuthRepositoryImpl(this.dioClient);

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.instance.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return Right(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle server errors (400, 401, 500, etc)
        return Left(ServerFailure(
          message: e.response?.data['message'] ?? 'Authentication failed',
          statusCode: e.response?.statusCode,
        ));
      }
      // Handle network/connection errors
      return Left(NetworkFailure(
        message: 'Network error occurred. Please check your connection.',
      ));
    } catch (e) {
      // Handle unexpected errors
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isAdmin,
  }) async {
    try {
      final response = await dioClient.instance.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'is_admin': isAdmin,
        },
      );

      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Add token to headers
      final token = 'Bearer ${Get.find<AuthController>().user?.token}';
      dioClient.instance.options.headers['Authorization'] = token;

      await dioClient.instance.post(ApiEndpoints.logout);

      // Clear token after logout
      dioClient.instance.options.headers.remove('Authorization');

      return const Right(null);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure(
          message: e.response?.data['message'] ?? 'Logout failed',
          statusCode: e.response?.statusCode,
        ));
      }
      return Left(NetworkFailure(
        message: 'Network error occurred. Please check your connection.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'An unexpected error occurred during logout',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProfile() async {
    try {
      final response = await dioClient.instance.get(ApiEndpoints.profile);
      return Right(response.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updateAvatar({
    required String imagePath,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'avatar': await dio.MultipartFile.fromFile(imagePath),
      });

      final response = await dioClient.instance.post(
        ApiEndpoints.avatar,
        data: formData,
      );

      return Right(response.data['data']['avatar']);
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to update avatar',
          statusCode: e.response?.statusCode,
        ));
      }
      return Left(NetworkFailure(
        message: 'Network error occurred. Please check your connection.',
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'An unexpected error occurred while updating avatar',
      ));
    }
  }
}
