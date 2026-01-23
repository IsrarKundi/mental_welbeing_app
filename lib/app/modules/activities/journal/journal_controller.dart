import 'package:get/get.dart';

class JournalController extends GetxController {
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

  final prompts = [
    'What made you smile today?',
    'Who are you thankful for?',
    'What\'s something good that happened?',
  ];

  final selectedMoodIndex = 0.obs;

  void updateGratitude(int index, String value) {
    gratitudeInputs[index] = value;
  }

  void selectMood(int index) {
    selectedMoodIndex.value = index;
  }

  void saveEntry() {
    // UI only - just show confirmation
    entries.add(
      JournalEntry(
        date: DateTime.now(),
        entries: List.from(gratitudeInputs),
        mood: moodOptions[selectedMoodIndex.value],
      ),
    );

    // Reset inputs
    gratitudeInputs.value = ['', '', ''];
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
