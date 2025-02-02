import 'package:get/get.dart';
import 'package:learn_flutter/core/network/dio_client.dart';
import 'package:learn_flutter/data/repositories/auth_repository_impl.dart';
import 'package:learn_flutter/domain/repositories/auth_repository.dart';
import 'package:learn_flutter/domain/usecases/auth_usecases.dart';
import 'package:learn_flutter/presentation/controllers/auth_controller.dart';
import 'package:learn_flutter/core/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_flutter/core/services/storage_service.dart';
import 'package:learn_flutter/data/repositories/genre_repository_impl.dart';
import 'package:learn_flutter/domain/repositories/genre_repository.dart';
import 'package:learn_flutter/domain/usecases/genre_usecases.dart';
import 'package:learn_flutter/presentation/controllers/genre_controller.dart';
import 'package:learn_flutter/core/database/database_helper.dart';

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

    // Genre Repository
    final dbHelper = DatabaseHelper();
    Get.put(dbHelper, permanent: true);

    Get.put<GenreRepository>(
      GenreRepositoryImpl(
        Get.find<DioClient>(),
        Get.find<DatabaseHelper>(),
      ),
      permanent: true,
    );

    // Use Cases
    Get.put(LoginUseCase(Get.find<AuthRepository>()), permanent: true);
    Get.put(RegisterUseCase(Get.find<AuthRepository>()), permanent: true);
    Get.put(LogoutUseCase(Get.find<AuthRepository>()), permanent: true);

    // Genre Use Cases
    Get.put(GetGenresUseCase(Get.find<GenreRepository>()), permanent: true);
    Get.put(GetGenreUseCase(Get.find<GenreRepository>()), permanent: true);
    Get.put(CreateGenreUseCase(Get.find<GenreRepository>()), permanent: true);
    Get.put(UpdateGenreUseCase(Get.find<GenreRepository>()), permanent: true);
    Get.put(DeleteGenreUseCase(Get.find<GenreRepository>()), permanent: true);

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

    // Genre Controller
    Get.put(
      GenreController(
        getGenresUseCase: Get.find<GetGenresUseCase>(),
        getGenreUseCase: Get.find<GetGenreUseCase>(),
        createGenreUseCase: Get.find<CreateGenreUseCase>(),
        updateGenreUseCase: Get.find<UpdateGenreUseCase>(),
        deleteGenreUseCase: Get.find<DeleteGenreUseCase>(),
      ),
      permanent: true,
    );
  }
}
