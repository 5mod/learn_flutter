import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/config/themes.dart';

class ThemeController extends GetxController {
  // Initial theme mode
  var isDarkMode = false.obs;

  // Toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  // Get current theme
  ThemeData get currentTheme {
    return isDarkMode.value ? _darkTheme : _lightTheme;
  }

  // Define light theme
  ThemeData get _lightTheme {
    return ThemeData(
      primaryColor: AppColors.darkBlue,
      scaffoldBackgroundColor: AppColors.paleBlue,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBlue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.darkBlue,
        secondary: AppColors.greyBlue,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkBlue),
        bodyMedium: TextStyle(color: AppColors.greyBlue),
      ),
      // Add more theme properties as needed
    );
  }

  // Define dark theme
  ThemeData get _darkTheme {
    return ThemeData(
      primaryColor: AppColors.lightBlue,
      scaffoldBackgroundColor: AppColors.darkBlue,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBlue,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.lightBlue,
        secondary: AppColors.greyBlue,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: AppColors.greyBlue),
      ),
      // Add more theme properties as needed
    );
  }
}
