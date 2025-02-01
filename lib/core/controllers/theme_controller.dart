import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/config/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String THEME_KEY = 'is_dark_mode';

  var isDarkMode = false.obs;
  late SharedPreferences _prefs;

  @override
  void onInit() async {
    super.onInit();
    await _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = Get.find<SharedPreferences>();
    isDarkMode.value = _prefs.getBool(THEME_KEY) ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeStatus();
  }

  Future<void> _saveThemeStatus() async {
    await _prefs.setBool(THEME_KEY, isDarkMode.value);
  }

  ThemeData get currentTheme {
    return isDarkMode.value ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primaryColor: AppColors.darkBlue,
      scaffoldBackgroundColor: AppColors.paleBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBlue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.darkBlue,
        secondary: AppColors.greyBlue,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkBlue),
        bodyMedium: TextStyle(color: AppColors.greyBlue),
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      primaryColor: AppColors.lightBlue,
      scaffoldBackgroundColor: AppColors.darkBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBlue,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lightBlue,
        secondary: AppColors.greyBlue,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: AppColors.greyBlue),
      ),
    );
  }
}
