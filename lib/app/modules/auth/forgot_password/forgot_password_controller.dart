import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final _authRepo = AuthRepository();

  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    isLoading.value = true;
    try {
      await _authRepo.sendPasswordResetEmail(emailController.text.trim());
      Get.snackbar(
        'Success',
        'Password reset email sent! Please check your inbox.',
      );
      Get.back();
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
