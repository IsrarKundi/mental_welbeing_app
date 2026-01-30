import 'package:get/get.dart';
import '../../data/repositories/mood_repository.dart';

class MoodHistoryController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final currentMonth = DateTime.now().obs;

  // Mock mood data for demo - in real app, this would come from storage
  final moodHistory = <DateTime, MoodEntry>{}.obs;

  final _moodRepo = MoodRepository();

  @override
  void onInit() {
    super.onInit();
    _fetchMoods();
  }

  Future<void> _fetchMoods() async {
    try {
      final data = await _moodRepo.getMoods();
      moodHistory.clear();
      for (final item in data) {
        final date = DateTime.parse(item['created_at']);
        moodHistory[_dateKey(date)] = MoodEntry(
          date: date,
          emoji: item['emoji'],
          label: item['label'],
          color: item['color'],
          note: item['note'] ?? '',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load mood history.');
    }
  }

  Future<void> logMood(String emoji, String label, int color) async {
    try {
      await _moodRepo.logMood(
        emoji: emoji,
        label: label,
        color: color,
        note: 'Logged from Home',
      );
      _fetchMoods(); // Refresh local list
    } catch (e) {
      Get.snackbar('Error', 'Failed to save mood.');
    }
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
