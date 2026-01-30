import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final contents = [
    OnboardingContent(
      title: 'Your Safe Space',
      description: 'A secure place to express yourself freely and privately.',
      icon: Icons.shield_outlined,
    ),
    OnboardingContent(
      title: 'Talk to AI 24/7',
      description: 'Our compassionate AI is here to listen whenever you need.',
      icon: Icons.smart_toy_outlined,
    ),
    OnboardingContent(
      title: 'Track your Mood',
      description: 'Monitor your emotional well-being and identify patterns.',
      icon: Icons.insights_outlined,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void getStarted() {
    Get.toNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
