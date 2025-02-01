import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/core/bindings/app_bindings.dart';
import 'package:learn_flutter/core/routes/app_pages.dart';
import 'package:learn_flutter/core/routes/app_routes.dart';
import 'package:learn_flutter/core/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_flutter/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  final prefs = await SharedPreferences.getInstance();
  Get.put(prefs, permanent: true);

  // Initialize storage service
  final storageService = StorageService(prefs);
  Get.put(storageService, permanent: true);

  // Initialize theme controller
  final themeController = ThemeController();
  Get.put(themeController, permanent: true);

  // Check for saved user
  final savedUser = storageService.getUser();
  print('Checking saved user on startup: ${savedUser?.toJson()}');

  // Determine initial route based on saved user
  final initialRoute = savedUser != null ? AppRoutes.home : AppRoutes.login;

  print('Setting initial route to: $initialRoute');
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'AnimeTower',
          initialBinding: AppBindings(),
          initialRoute: initialRoute,
          getPages: AppPages.pages,
          theme: Get.find<ThemeController>().currentTheme,
        ));
  }
}
