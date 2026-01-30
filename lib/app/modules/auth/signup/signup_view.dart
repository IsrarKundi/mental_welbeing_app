import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/auth_text_field.dart';
import '../../../widgets/branded_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

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
                SizedBox(height: 32.h),
                GestureDetector(
                  onTap: controller.goToLogin,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Start your journey to mental wellness',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 32.h),

                _buildLabel('Full Name'),
                SizedBox(height: 8.h),
                AuthTextField(
                  controller: controller.fullNameController,
                  hintText: 'Enter your full name',
                  icon: Icons.person_outline,
                ),

                SizedBox(height: 20.h),

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
                    hintText: 'Create a password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: !controller.isPasswordVisible.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                  ),
                ),

                SizedBox(height: 20.h),

                _buildLabel('Confirm Password'),
                SizedBox(height: 8.h),
                Obx(
                  () => AuthTextField(
                    controller: controller.confirmPasswordController,
                    hintText: 'Confirm your password',
                    icon: Icons.lock_clock_outlined,
                    isPassword: true,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    onToggleVisibility:
                        controller.toggleConfirmPasswordVisibility,
                  ),
                ),

                SizedBox(height: 32.h),

                Obx(
                  () => BrandedButton(
                    text: 'Sign Up',
                    onTap: controller.signup,
                    isLoading: controller.isLoading.value,
                  ),
                ),

                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.poppins(
                          color: AppColors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
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
