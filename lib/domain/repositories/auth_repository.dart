import 'package:dartz/dartz.dart';
import 'package:learn_flutter/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isAdmin,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, Map<String, dynamic>>> getProfile();

  Future<Either<Failure, String>> updateAvatar({
    required String imagePath,
  });
}
