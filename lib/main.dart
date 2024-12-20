import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/presentation/screens/login/login_screen.dart';
import 'package:learn_flutter/core/controllers/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ThemeController
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: themeController.currentTheme,
        home: const LoginScreen(),
      );
    });
  }
}
