import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  final _authRepo = AuthRepository();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  Future<void> signup() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    isLoading.value = true;
    try {
      await _authRepo.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
        fullNameController.text.trim(),
      );
      Get.snackbar(
        'Success',
        'Account created! Please check your email for verification.',
      );
      Get.offNamed(Routes.LOGIN);
    } on AuthException catch (e) {
      Get.snackbar('Signup Failed', e.message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.back();

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
