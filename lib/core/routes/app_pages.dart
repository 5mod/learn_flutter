import 'package:get/get.dart';
import 'package:learn_flutter/core/routes/app_routes.dart';
import 'package:learn_flutter/presentation/screens/login/login_screen.dart';
import 'package:learn_flutter/presentation/screens/home/home_screen.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    // Add more pages here as you create them
  ];
}
