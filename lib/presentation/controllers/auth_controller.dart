import 'package:get/get.dart';
import 'package:learn_flutter/core/errors/failures.dart';
import 'package:learn_flutter/data/models/user_model.dart';
import 'package:learn_flutter/domain/usecases/auth_usecases.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/core/services/storage_service.dart';
import 'package:learn_flutter/core/network/dio_client.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final StorageService storageService;

  final _isLoading = false.obs;
  final _error = Rxn<String>();
  final _user = Rxn<UserModel>();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  UserModel? get user => _user.value;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.storageService,
  });

  @override
  void onReady() {
    super.onReady();
    // Restore user session
    final savedUser = storageService.getUser();
    if (savedUser != null) {
      print('Restored user: ${savedUser.toJson()}');
      _user.value = savedUser;
      
      // Update DioClient headers with the saved token
      final dioClient = Get.find<DioClient>();
      dioClient.instance.options.headers['Authorization'] = 'Bearer ${savedUser.token}';
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _error.value = null;

    final result = await loginUseCase.execute(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => _error.value = failure.message,
      (data) {
        print('Login Response: $data');
        try {
          if (data['data'] == null) {
            _error.value = 'No data received from server';
            return;
          }
          _user.value = UserModel.fromJson(data['data']);
          print('User parsed successfully: ${_user.value?.toJson()}');
          
          // Save user data
          storageService.saveUser(_user.value!);
          
          // Update DioClient headers
          final dioClient = Get.find<DioClient>();
          dioClient.instance.options.headers['Authorization'] = 'Bearer ${_user.value!.token}';
          
          Get.offAllNamed('/home');
        } catch (e, stackTrace) {
          print('Error parsing user data: $e');
          print('Stack trace: $stackTrace');
          _error.value = 'Failed to parse user data: $e';
        }
      },
    );

    _isLoading.value = false;
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required bool isAdmin,
  }) async {
    _isLoading.value = true;
    _error.value = null;

    final result = await registerUseCase.execute(
      name: name,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isAdmin: isAdmin,
    );

    result.fold(
      (failure) => _error.value = failure.message,
      (data) {
        _user.value = UserModel.fromJson(data['data']);
        Get.offAllNamed('/home'); // Navigate to home screen
      },
    );

    _isLoading.value = false;
  }

  Future<void> logout() async {
    _isLoading.value = true;
    _error.value = null;

    final result = await logoutUseCase.execute();

    result.fold(
      (failure) {
        _error.value = failure.message;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      },
      (_) {
        _user.value = null;
        // Clear stored user data
        storageService.removeUser();
        Get.offAllNamed('/login');
        Get.snackbar(
          'Success',
          'Logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      },
    );

    _isLoading.value = false;
  }

  void setUser(UserModel user) {
    _user.value = user;
  }
} 