import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';

class Mood {
  final String emoji;
  final String label;
  final LinearGradient gradient;

  Mood({required this.emoji, required this.label, required this.gradient});
}

class DailyAction {
  final String title;
  final String imageUrl;

  DailyAction({required this.title, required this.imageUrl});
}

class HomeController extends GetxController {
  final userName = 'Mustafa'.obs;
  final currentMoodIndex = 1.obs; // Default to Calm

  final moods = [
    Mood(emoji: '😊', label: 'Happy', gradient: AppColors.happyGradient),
    Mood(emoji: '😌', label: 'Calm', gradient: AppColors.calmGradient),
    Mood(emoji: '😔', label: 'Sad', gradient: AppColors.sadGradient),
    Mood(emoji: '😠', label: 'Angry', gradient: AppColors.angryGradient),
  ];

  final dailyActions = [
    DailyAction(
      title: 'Morning Meditation',
      imageUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=500&q=60',
    ),
    DailyAction(
      title: 'Sleep Stories',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=500&q=60',
    ),
    DailyAction(
      title: 'Breathing Exercise',
      imageUrl:
          'https://images.unsplash.com/photo-1545389336-cf090694435e?auto=format&fit=crop&w=500&q=60',
    ),
    DailyAction(
      title: 'Gratitude Journal',
      imageUrl:
          'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=500&q=60',
    ),
    DailyAction(
      title: 'Mindful Walk',
      imageUrl:
          'https://images.unsplash.com/photo-1502904550040-7534597429ae?auto=format&fit=crop&w=500&q=60',
    ),
    DailyAction(
      title: 'Yoga Session',
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=500&q=60',
    ),
  ];

  LinearGradient get currentGradient => moods[currentMoodIndex.value].gradient;

  void setMood(int index) {
    currentMoodIndex.value = index;
  }
}
