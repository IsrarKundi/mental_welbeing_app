import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/auth_text_field.dart';
import '../../../widgets/branded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Text(
                  'Welcome Back',
                  style: GoogleFonts.poppins(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Sign in to continue your journey',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 40.h),

                _buildLabel('Email Address'),
                SizedBox(height: 8.h),
                AuthTextField(
                  controller: controller.emailController,
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 20.h),

                _buildLabel('Password'),
                SizedBox(height: 8.h),
                Obx(
                  () => AuthTextField(
                    controller: controller.passwordController,
                    hintText: 'Enter your password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: !controller.isPasswordVisible.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                  ),
                ),

                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.goToForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(
                        color: AppColors.cyanAccent,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                Obx(
                  () => BrandedButton(
                    text: 'Sign In',
                    onTap: controller.login,
                    isLoading: controller.isLoading.value,
                  ),
                ),

                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToSignup,
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          color: AppColors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }
}
