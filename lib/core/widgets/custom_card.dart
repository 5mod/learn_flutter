import 'package:flutter/material.dart';
import 'package:learn_flutter/config/themes.dart';
import 'package:learn_flutter/core/constants/app_strings.dart';

class CustomLoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;

  const CustomLoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.greyBlue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.login,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Email TextField
            CustomTextField(
              controller: emailController,
              hintText: AppStrings.email,
              icon: Icons.email,
            ),
            const SizedBox(height: 16),

            // Password TextField
            CustomTextField(
              controller: passwordController,
              hintText: AppStrings.password,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 24),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: onLoginPressed,
                text: AppStrings.login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.greyBlue : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: hintText,
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDark ? Colors.white24 : Colors.grey[200]!,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: isDark ? AppColors.greyBlue : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: isDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
