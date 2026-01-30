import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_pages.dart';
import '../mood_history/mood_history_controller.dart';
import '../../data/repositories/mood_repository.dart';

enum ActivityType {
  breathing,
  meditation,
  journal,
  sleepStories,
  mindfulWalk,
  yoga,
}

class Mood {
  final String emoji;
  final String label;
  final LinearGradient gradient;
  final String iconUrl;

  Mood({
    required this.emoji,
    required this.label,
    required this.gradient,
    required this.iconUrl,
  });
}

class DailyAction {
  final String title;
  final String imageUrl;
  final ActivityType type;
  final String duration;
  final String difficulty;
  final String? route;

  DailyAction({
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.duration,
    required this.difficulty,
    this.route,
  });
}

class HomeController extends GetxController {
  final userName = 'Israr'.obs;
  final currentMoodIndex = 1.obs; // Default to Calm

  final moods = [
    Mood(
      emoji: '😊',
      label: 'Happy',
      gradient: AppColors.happyGradient,
      iconUrl: 'assets/images/characters/happy.png',
    ),
    Mood(
      emoji: '😌',
      label: 'Calm',
      gradient: AppColors.calmGradient,
      iconUrl: 'assets/images/characters/calm.png',
    ),
    Mood(
      emoji: '😔',
      label: 'Sad',
      gradient: AppColors.sadGradient,
      iconUrl: 'assets/images/characters/sad.png',
    ),
    Mood(
      emoji: '😠',
      label: 'Angry',
      gradient: AppColors.angryGradient,
      iconUrl: 'assets/images/characters/angry.png',
    ),
    Mood(
      emoji: '🥰',
      label: 'Loved',
      gradient: AppColors.lovedGradient,
      iconUrl: 'assets/images/characters/loved.png',
    ),
    Mood(
      emoji: '😴',
      label: 'Tired',
      gradient: AppColors.tiredGradient,
      iconUrl: 'assets/images/characters/tired.png',
    ),
  ];

  final dailyActions = [
    DailyAction(
      title: 'Breathing Exercise',
      imageUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=500&q=60',
      type: ActivityType.breathing,
      duration: '5 min',
      difficulty: 'Easy',
      route: Routes.BREATHING,
    ),
    DailyAction(
      title: 'Morning Meditation',
      imageUrl:
          'https://images.unsplash.com/photo-1545389336-cf090694435e?auto=format&fit=crop&w=500&q=60',
      type: ActivityType.meditation,
      duration: '10 min',
      difficulty: 'Beginner',
      route: Routes.MEDITATION,
    ),
    DailyAction(
      title: 'Gratitude Journal',
      imageUrl:
          'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=500&q=60',
      type: ActivityType.journal,
      duration: '5 min',
      difficulty: 'Easy',
      route: Routes.JOURNAL,
    ),
    DailyAction(
      title: 'Sleep Stories',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=500&q=60',
      type: ActivityType.sleepStories,
      duration: '15 min',
      difficulty: 'Relaxing',
      route: Routes.SLEEP_STORIES,
    ),
    DailyAction(
      title: 'Mindful Walk',
      imageUrl:
          'https://images.unsplash.com/photo-1502904550040-7534597429ae?auto=format&fit=crop&w=500&q=60',
      type: ActivityType.mindfulWalk,
      duration: '20 min',
      difficulty: 'Moderate',
      route: Routes.MINDFUL_WALK,
    ),
    DailyAction(
      title: 'Yoga Session',
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=500&q=60',
      type: ActivityType.yoga,
      duration: '15 min',
      difficulty: 'Intermediate',
      route: Routes.YOGA,
    ),
  ];

  LinearGradient get currentGradient => moods[currentMoodIndex.value].gradient;

  Future<void> setMood(int index) async {
    currentMoodIndex.value = index;
    final mood = moods[index];

    // Add to history
    try {
      // We can use the repository directly or via history controller
      // Direct use is better for Home specific logging
      final moodRepo = MoodRepository();
      await moodRepo.logMood(
        emoji: mood.emoji,
        label: mood.label,
        color: mood.gradient.colors.first.value,
        note: 'Logged from Home',
      );

      // Notify history controller to refresh if it exists
      if (Get.isRegistered<MoodHistoryController>()) {
        Get.find<MoodHistoryController>().onInit(); // Simple refresh
      }

      Get.snackbar(
        'Success',
        'Your mood "${mood.label}" has been logged!',
        backgroundColor: Colors.white.withOpacity(0.2),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error logging mood: $e');
      Get.snackbar('Error', 'Failed to save mood to your history.');
    }
  }

  Future<void> openActivity(DailyAction action) async {
    if (action.route != null) {
      Get.toNamed(action.route!);
    } else {
      // Show coming soon for activities not yet implemented
      Get.snackbar(
        'Coming Soon',
        '${action.title} will be available soon!',
        backgroundColor: Colors.white.withOpacity(0.2),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
      );
    }
  }
}
