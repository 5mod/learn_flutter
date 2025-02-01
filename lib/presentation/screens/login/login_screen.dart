import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/config/themes.dart';
import 'package:learn_flutter/core/constants/app_strings.dart';
import 'package:learn_flutter/core/widgets/custom_card.dart';
import 'package:learn_flutter/presentation/controllers/auth_controller.dart';
import 'package:learn_flutter/core/controllers/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (authController.error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Login',
          style: TextStyle(
            color:
                themeController.isDarkMode.value ? Colors.black : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeController.isDarkMode.value
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: themeController.isDarkMode.value
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 80,
                            color: themeController.isDarkMode.value
                                ? Colors.black
                                : Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.welcome,
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomLoginCard(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onLoginPressed: _handleLogin,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        // Navigate to register screen
                        Get.toNamed('/register');
                      },
                      child: Text(
                        AppStrings.createAccount,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (authController.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
