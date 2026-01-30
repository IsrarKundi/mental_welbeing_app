import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_pages.dart';
import '../mood_history/mood_history_controller.dart';
import '../../data/repositories/mood_repository.dart';
import '../../data/repositories/profile_repository.dart';

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
  final String? suggestedActivityTitle;
  final String? suggestedActivityRoute;
  final String? suggestedActivityMessage;

  Mood({
    required this.emoji,
    required this.label,
    required this.gradient,
    required this.iconUrl,
    this.suggestedActivityTitle,
    this.suggestedActivityRoute,
    this.suggestedActivityMessage,
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
  final userName = ''.obs;
  final profileImageUrl = ''.obs;
  final currentMoodIndex = 1.obs; // Default to Calm
  final isLoading = true.obs;
  final showSuggestedAction = false.obs;
  final suggestedActionDismissed = false.obs;
  final moodStreak = 0.obs;

  final _profileRepo = ProfileRepository();
  final _moodRepo = MoodRepository();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    _calculateMoodStreak();
  }

  Future<void> _calculateMoodStreak() async {
    try {
      final moods = await _moodRepo.getMoods();
      if (moods.isEmpty) {
        moodStreak.value = 0;
        return;
      }

      // Get unique dates (sorted newest first from repo)
      final dates = <DateTime>{};
      for (final mood in moods) {
        dates.add(
          DateTime(
            mood.createdAt.year,
            mood.createdAt.month,
            mood.createdAt.day,
          ),
        );
      }

      final sortedDates = dates.toList()..sort((a, b) => b.compareTo(a));

      int streak = 0;
      DateTime checkDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      for (final date in sortedDates) {
        if (date == checkDate) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else if (date.isBefore(checkDate)) {
          break;
        }
      }

      moodStreak.value = streak;
    } catch (e) {
      print('Error calculating streak: $e');
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final profile = await _profileRepo.getProfile();
      userName.value = profile.fullName ?? 'User';
      profileImageUrl.value = profile.avatarUrl ?? '';
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  final moods = [
    Mood(
      emoji: '😊',
      label: 'Happy',
      gradient: AppColors.happyGradient,
      iconUrl: 'assets/images/characters/happy.png',
      suggestedActivityTitle: 'Gratitude Journal',
      suggestedActivityRoute: Routes.JOURNAL,
      suggestedActivityMessage:
          'Capture this moment! Write down what made you happy.',
    ),
    Mood(
      emoji: '😌',
      label: 'Calm',
      gradient: AppColors.calmGradient,
      iconUrl: 'assets/images/characters/calm.png',
      suggestedActivityTitle: 'Morning Meditation',
      suggestedActivityRoute: Routes.MEDITATION,
      suggestedActivityMessage: 'Deepen your peace with a quick meditation.',
    ),
    Mood(
      emoji: '😔',
      label: 'Sad',
      gradient: AppColors.sadGradient,
      iconUrl: 'assets/images/characters/sad.png',
      suggestedActivityTitle: 'Calming Meditation',
      suggestedActivityRoute: Routes.MEDITATION,
      suggestedActivityMessage: 'A gentle meditation to lift your spirits.',
    ),
    Mood(
      emoji: '😠',
      label: 'Angry',
      gradient: AppColors.angryGradient,
      iconUrl: 'assets/images/characters/angry.png',
      suggestedActivityTitle: 'Breathing Exercise',
      suggestedActivityRoute: Routes.BREATHING,
      suggestedActivityMessage: 'Release tension with deep breathing.',
    ),
    Mood(
      emoji: '🥰',
      label: 'Loved',
      gradient: AppColors.lovedGradient,
      iconUrl: 'assets/images/characters/loved.png',
      suggestedActivityTitle: 'Gratitude Journal',
      suggestedActivityRoute: Routes.JOURNAL,
      suggestedActivityMessage:
          'Share the love! Write about what you appreciate.',
    ),
    Mood(
      emoji: '😴',
      label: 'Tired',
      gradient: AppColors.tiredGradient,
      iconUrl: 'assets/images/characters/tired.png',
      suggestedActivityTitle: 'Sleep Stories',
      suggestedActivityRoute: Routes.SLEEP_STORIES,
      suggestedActivityMessage: 'Rest your mind with a soothing story.',
    ),
    Mood(
      emoji: '😰',
      label: 'Anxious',
      gradient: AppColors.anxiousGradient,
      iconUrl: 'assets/images/characters/anxious.png',
      suggestedActivityTitle: 'Breathing Exercise',
      suggestedActivityRoute: Routes.BREATHING,
      suggestedActivityMessage: 'Slow, deep breaths to calm your nerves.',
    ),
    Mood(
      emoji: '😩',
      label: 'Stressed',
      gradient: AppColors.stressedGradient,
      iconUrl: 'assets/images/characters/stressed.png',
      suggestedActivityTitle: 'Mindful Walk',
      suggestedActivityRoute: Routes.MINDFUL_WALK,
      suggestedActivityMessage: 'Step outside and clear your mind.',
    ),
    Mood(
      emoji: '😐',
      label: 'Neutral',
      gradient: AppColors.neutralGradient,
      iconUrl: 'assets/images/characters/neutral.png',
      suggestedActivityTitle: 'Daily Journal',
      suggestedActivityRoute: Routes.JOURNAL,
      suggestedActivityMessage:
          'Reflect on your day - any thoughts to capture?',
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

  // Called when user taps a mood - just updates UI, doesn't log yet
  void selectMood(int index) {
    currentMoodIndex.value = index;
    suggestedActionDismissed.value = false;
    showSuggestedAction.value = false; // Hide until after logging
  }

  // Called after bottom sheet completes (with or without note)
  Future<void> logMoodWithNote(String? note) async {
    final mood = moods[currentMoodIndex.value];

    // Show suggested action after logging
    suggestedActionDismissed.value = false;
    showSuggestedAction.value = true;

    // Add to history
    try {
      await _moodRepo.logMood(
        emoji: mood.emoji,
        label: mood.label,
        color: mood.gradient.colors.first.value,
        note: note,
      );

      if (Get.isRegistered<MoodHistoryController>()) {
        Get.find<MoodHistoryController>().onInit(); // Simple refresh
      }

      // Update streak
      _calculateMoodStreak();
    } catch (e) {
      print('Error logging mood: $e');
      Get.snackbar('Error', 'Failed to save mood to your history.');
    }
  }

  // Legacy method for backward compatibility (logs without note)
  Future<void> setMood(int index) async {
    currentMoodIndex.value = index;
    final mood = moods[index];

    // Reset and show suggested action
    suggestedActionDismissed.value = false;
    showSuggestedAction.value = true;

    // Add to history
    try {
      await _moodRepo.logMood(
        emoji: mood.emoji,
        label: mood.label,
        color: mood.gradient.colors.first.value,
        note: null,
      );

      if (Get.isRegistered<MoodHistoryController>()) {
        Get.find<MoodHistoryController>().onInit(); // Simple refresh
      }
    } catch (e) {
      print('Error logging mood: $e');
      Get.snackbar('Error', 'Failed to save mood to your history.');
    }
  }

  void dismissSuggestedAction() {
    showSuggestedAction.value = false;
    suggestedActionDismissed.value = true;
  }

  void openSuggestedActivity() {
    final mood = moods[currentMoodIndex.value];
    if (mood.suggestedActivityRoute != null) {
      showSuggestedAction.value = false;
      Get.toNamed(mood.suggestedActivityRoute!);
    }
  }

  Mood get currentMood => moods[currentMoodIndex.value];

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
