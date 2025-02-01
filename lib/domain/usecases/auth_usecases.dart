import 'package:dartz/dartz.dart';
import 'package:learn_flutter/core/errors/failures.dart';
import 'package:learn_flutter/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isAdmin,
  }) async {
    return await repository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isAdmin: isAdmin,
    );
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> execute() async {
    return await repository.logout();
  }
} 