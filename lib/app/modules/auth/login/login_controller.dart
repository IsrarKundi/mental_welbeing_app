import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _authRepo = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      await _authRepo.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      Get.offAllNamed(Routes.MAIN_NAV);
    } on AuthException catch (e) {
      Get.snackbar('Login Failed', e.message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() => Get.toNamed(Routes.SIGNUP);
  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
