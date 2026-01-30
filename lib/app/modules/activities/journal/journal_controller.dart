import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../progress/progress_controller.dart';

class JournalController extends GetxController {
  final _activityRepo = ActivityRepository();
  VoidCallback? onSessionComplete;
  final entries = <JournalEntry>[].obs;
  final gratitudeInputs = ['', '', ''].obs;
  final currentMood = 'grateful'.obs;

  final moodOptions = [
    MoodOption(emoji: '🙏', label: 'Grateful'),
    MoodOption(emoji: '😊', label: 'Happy'),
    MoodOption(emoji: '😌', label: 'Peaceful'),
    MoodOption(emoji: '💪', label: 'Strong'),
    MoodOption(emoji: '🌟', label: 'Hopeful'),
  ];

  // Mood-specific prompts
  final Map<String, List<String>> moodPrompts = {
    'Grateful': [
      'What made you smile today?',
      'Who are you thankful for?',
      'What\'s a small thing you appreciated?',
    ],
    'Happy': [
      'What brought you joy today?',
      'What made you laugh recently?',
      'What are you excited about?',
    ],
    'Peaceful': [
      'What helped you feel calm today?',
      'What moment felt most serene?',
      'What brings you inner peace?',
    ],
    'Strong': [
      'What challenge did you overcome?',
      'What made you feel capable today?',
      'What strength are you proud of?',
    ],
    'Hopeful': [
      'What are you looking forward to?',
      'What possibility excites you?',
      'What gives you hope for tomorrow?',
    ],
  };

  List<String> get prompts {
    final mood = moodOptions[selectedMoodIndex.value].label;
    return moodPrompts[mood] ?? moodPrompts['Grateful']!;
  }

  final selectedMoodIndex = 0.obs;

  void updateGratitude(int index, String value) {
    gratitudeInputs[index] = value;
  }

  void selectMood(int index) {
    selectedMoodIndex.value = index;
  }

  Future<void> saveEntry() async {
    if (!canSave) return;

    try {
      // 1. Log as an activity
      await _activityRepo.logActivity(
        activityType: 'journal',
        durationMinutes: 5, // Default for journaling
      );

      // 2. Add to local list (stub)
      entries.add(
        JournalEntry(
          date: DateTime.now(),
          entries: List.from(gratitudeInputs),
          mood: moodOptions[selectedMoodIndex.value],
        ),
      );

      // 3. Reset inputs
      gratitudeInputs.value = ['', '', ''];

      // 4. Refresh stats
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().onInit();
      }

      // 5. Notify view
      if (onSessionComplete != null) {
        onSessionComplete!();
      }
    } catch (e) {
      print('Error saving journal entry: $e');
    }
  }

  bool get canSave {
    return gratitudeInputs.any((entry) => entry.isNotEmpty);
  }
}

class JournalEntry {
  final DateTime date;
  final List<String> entries;
  final MoodOption mood;

  JournalEntry({required this.date, required this.entries, required this.mood});
}

class MoodOption {
  final String emoji;
  final String label;

  MoodOption({required this.emoji, required this.label});
}
