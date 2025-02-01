import 'package:get/get.dart';
import 'package:learn_flutter/core/network/dio_client.dart';
import 'package:learn_flutter/data/repositories/auth_repository_impl.dart';
import 'package:learn_flutter/domain/repositories/auth_repository.dart';
import 'package:learn_flutter/domain/usecases/auth_usecases.dart';
import 'package:learn_flutter/presentation/controllers/auth_controller.dart';
import 'package:learn_flutter/core/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_flutter/core/services/storage_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Network
    Get.put(DioClient(), permanent: true);

    // Repositories
    Get.put<AuthRepository>(
      AuthRepositoryImpl(Get.find<DioClient>()),
      permanent: true,
    );

    // Use Cases
    Get.put(LoginUseCase(Get.find<AuthRepository>()), permanent: true);
    Get.put(RegisterUseCase(Get.find<AuthRepository>()), permanent: true);
    Get.put(LogoutUseCase(Get.find<AuthRepository>()), permanent: true);

    // Auth Controller with stored user
    final storageService = Get.find<StorageService>();
    final savedUser = storageService.getUser();

    final authController = AuthController(
      loginUseCase: Get.find<LoginUseCase>(),
      registerUseCase: Get.find<RegisterUseCase>(),
      logoutUseCase: Get.find<LogoutUseCase>(),
      storageService: storageService,
    );

    // Set saved user if exists
    if (savedUser != null) {
      authController.setUser(savedUser);

      // Set auth token in DioClient
      final dioClient = Get.find<DioClient>();
      dioClient.instance.options.headers['Authorization'] =
          'Bearer ${savedUser.token}';
    }

    Get.put(authController, permanent: true);
  }
}
