import 'package:get/get.dart';

class MoodHistoryController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final currentMonth = DateTime.now().obs;

  // Mock mood data for demo - in real app, this would come from storage
  final moodHistory = <DateTime, MoodEntry>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _generateMockData();
  }

  void _generateMockData() {
    final now = DateTime.now();
    final moods = ['😊', '😌', '😔', '😠', '🥰', '😴'];
    final moodLabels = ['Happy', 'Calm', 'Sad', 'Angry', 'Loved', 'Tired'];
    final colors = [
      0xFFF59E0B, // Happy
      0xFF0F172A, // Calm (deepOceanBlue)
      0xFF1E293B, // Sad
      0xFF991B1B, // Angry
      0xFFEC4899, // Loved
      0xFF8B5CF6, // Tired
    ];

    // Generate random mood data for past 30 days
    for (int i = 0; i < 30; i++) {
      final date = DateTime(now.year, now.month, now.day - i);
      if (i % 3 != 0) {
        // Skip some days to make it realistic
        final randomIndex = (date.day + date.month) % moods.length;
        moodHistory[_dateKey(date)] = MoodEntry(
          date: date,
          emoji: moods[randomIndex],
          label: moodLabels[randomIndex],
          color: colors[randomIndex],
          note: _getRandomNote(moodLabels[randomIndex]),
        );
      }
    }
  }

  void logMood(String emoji, String label, int color) {
    final now = DateTime.now();
    moodHistory[_dateKey(now)] = MoodEntry(
      date: now,
      emoji: emoji,
      label: label,
      color: color,
      note: 'Logged from Home',
    );
  }

  String _getRandomNote(String mood) {
    final notes = {
      'Happy': 'Had a great day at work!',
      'Calm': 'Meditation helped me relax.',
      'Sad': 'Missing family today.',
      'Angry': 'Traffic was terrible.',
      'Loved': 'Spent time with friends.',
      'Tired': 'Need more sleep.',
    };
    return notes[mood] ?? '';
  }

  DateTime _dateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  MoodEntry? getMoodForDate(DateTime date) {
    return moodHistory[_dateKey(date)];
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void previousMonth() {
    currentMonth.value = DateTime(
      currentMonth.value.year,
      currentMonth.value.month - 1,
    );
  }

  void nextMonth() {
    final now = DateTime.now();
    final next = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
    );
    if (next.isBefore(now) || next.month == now.month) {
      currentMonth.value = next;
    }
  }

  List<DateTime> get daysInMonth {
    final first = DateTime(
      currentMonth.value.year,
      currentMonth.value.month,
      1,
    );
    final last = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + 1,
      0,
    );

    final days = <DateTime>[];

    // Add padding for days before the first of the month
    final firstWeekday = first.weekday % 7; // Sunday = 0
    for (int i = 0; i < firstWeekday; i++) {
      days.add(DateTime(first.year, first.month, first.day - firstWeekday + i));
    }

    // Add all days of the month
    for (int i = 1; i <= last.day; i++) {
      days.add(DateTime(currentMonth.value.year, currentMonth.value.month, i));
    }

    return days;
  }

  String get monthYearString {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[currentMonth.value.month - 1]} ${currentMonth.value.year}';
  }

  Map<String, int> get moodStats {
    final stats = <String, int>{};
    for (final entry in moodHistory.values) {
      stats[entry.label] = (stats[entry.label] ?? 0) + 1;
    }
    return stats;
  }

  String get mostFrequentMood {
    if (moodStats.isEmpty) return 'No data';
    final sorted = moodStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  int get totalLoggedDays => moodHistory.length;
}

class MoodEntry {
  final DateTime date;
  final String emoji;
  final String label;
  final int color;
  final String note;

  MoodEntry({
    required this.date,
    required this.emoji,
    required this.label,
    required this.color,
    this.note = '',
  });
}
