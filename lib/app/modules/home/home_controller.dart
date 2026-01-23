import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_pages.dart';
import '../mood_history/mood_history_controller.dart';

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

  void setMood(int index) {
    currentMoodIndex.value = index;
    final mood = moods[index];

    // Add to history
    try {
      final historyController = Get.find<MoodHistoryController>();
      historyController.logMood(
        mood.emoji,
        mood.label,
        mood.gradient.colors.first.value,
      );
    } catch (e) {
      // MoodHistoryController might not be in memory if we aren't in MainNav
      print('MoodHistoryController not found: $e');
    }
  }

  void openActivity(DailyAction action) {
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
