import 'package:flutter/material.dart';
import 'package:learn_flutter/config/themes.dart';
import 'package:learn_flutter/core/constants/app_strings.dart';
import 'package:learn_flutter/core/widgets/custom_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _handleLogin() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.comingSoon,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: AppColors.darkBlue,
        duration: const Duration(seconds: 3), 
        behavior: SnackBarBehavior.floating, 
        margin: const EdgeInsets.all(20), 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paleBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
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
                      color: AppColors.paleBlue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.welcome,
                      style: TextStyle(
                        color: AppColors.paleBlue,
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
                  nameController: _nameController,
                  onLoginPressed: _handleLogin,
                ),
              ),
              
              const SizedBox(height: 24),
              
              TextButton(
                onPressed: () {
                },
                child: Text(
                  AppStrings.createAccount,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
} 