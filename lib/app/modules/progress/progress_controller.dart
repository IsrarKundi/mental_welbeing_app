import 'package:get/get.dart';
import '../../data/repositories/mood_repository.dart';
import '../../data/repositories/activity_repository.dart';

class ProgressController extends GetxController {
  final _moodRepo = MoodRepository();
  final _activityRepo = ActivityRepository();

  final currentStreak = 0.obs;
  final longestStreak = 0.obs;
  final totalSessions = 0.obs;
  final totalMinutes = 0.obs;

  final dailyGoal = 6.obs; // Synchronized with total activities (6)
  final dailyProgress = 0.obs;

  final moodDistribution = <String, int>{}.obs;
  final recentActivities = <RecentActivity>[].obs;
  final isLoading = false.obs;

  final achievements = <Achievement>[].obs;
  final weeklyActivityData = <int>[0, 0, 0, 0, 0, 0, 0].obs;
  final weekDays = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    isLoading.value = true;
    try {
      final moodStats = await _moodRepo.getMoodStats();
      moodDistribution.value = moodStats;

      final activities = await _activityRepo.getActivities();
      final moods = await _moodRepo.getMoods();

      print(
        'DEBUG: Fetched ${activities.length} activities and ${moods.length} moods',
      );

      // Combined sessions
      totalSessions.value =
          moodStats.values.fold(0, (sum, count) => sum + count) +
          activities.length;

      print('DEBUG: Total sessions calculated: ${totalSessions.value}');

      // Total Wellness Time
      totalMinutes.value = activities.fold(
        0,
        (sum, act) => sum + act.durationMinutes,
      );

      // Streak Calculation
      _calculateStreaks(moods, activities);

      // Daily Progress (Today only)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dailyCount =
          moods.where((m) => m.createdAt.isAfter(today)).length +
          activities.where((a) => a.createdAt.isAfter(today)).length;
      dailyProgress.value = dailyCount;

      // Update Achievements based on REAL stats
      _updateAchievements(moods.length + activities.length);

      // Recent Activities
      _populateRecentJourney(moods, activities);

      // Weekly Chart Data
      _calculateWeeklyChartData(moods, activities);
    } catch (e) {
      print('Error fetching stats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateWeeklyChartData(
    List<dynamic> moods,
    List<dynamic> activities,
  ) {
    final now = DateTime.now();
    final data = List.filled(7, 0);
    final dayLabels = <String>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final activityCount = activities
          .where(
            (a) =>
                a.createdAt.isAfter(dayStart) && a.createdAt.isBefore(dayEnd),
          )
          .length;
      final moodCount = moods
          .where(
            (m) =>
                m.createdAt.isAfter(dayStart) && m.createdAt.isBefore(dayEnd),
          )
          .length;

      data[6 - i] = activityCount + moodCount;
      dayLabels.add(['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7]);
    }

    weeklyActivityData.value = data;
    weekDays.value = dayLabels;
  }

  void _updateAchievements(int total) {
    achievements.value = [
      Achievement(
        title: 'First Steps',
        description: 'Complete your first session',
        icon: '🎯',
        isUnlocked: total >= 1,
        color: 0xFF22C55E,
      ),
      Achievement(
        title: 'Week Warrior',
        description: 'Reach a 7 day streak',
        icon: '🔥',
        isUnlocked: currentStreak.value >= 7,
        color: 0xFFF59E0B,
      ),
      Achievement(
        title: 'Mindful Master',
        description: 'Complete 30 sessions',
        icon: '🧘',
        isUnlocked: total >= 30,
        color: 0xFF8B5CF6,
      ),
      Achievement(
        title: 'Elite Tracker',
        description: 'Log 100 sessions',
        icon: '🏆',
        isUnlocked: total >= 100,
        color: 0xFF6366F1,
      ),
      Achievement(
        title: 'Wellness Guru',
        description: 'Reach 10 hours of wellness',
        icon: '💎',
        isUnlocked: totalMinutes.value >= 600,
        color: 0xFFEC4899,
      ),
    ];
  }

  void _calculateStreaks(List<dynamic> moods, List<dynamic> activities) {
    if (moods.isEmpty && activities.isEmpty) {
      currentStreak.value = 0;
      return;
    }

    final dates = <DateTime>{};
    for (var m in moods)
      dates.add(DateTime(m.createdAt.year, m.createdAt.month, m.createdAt.day));
    for (var a in activities)
      dates.add(DateTime(a.createdAt.year, a.createdAt.month, a.createdAt.day));

    final sortedDates = dates.toList()..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime checkDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    for (var date in sortedDates) {
      if (date == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break; // Streak broken
      }
    }
    currentStreak.value = streak;
  }

  String get goalMessage {
    if (dailyGoal.value == 0) return 'Set a daily goal to track your progress.';
    final percent = (progressPercent * 100).toInt();
    if (percent >= 100) {
      return 'Amazing! You\'ve reached 100% of your daily wellness goal.';
    } else if (percent >= 50) {
      return 'Great job! You\'ve reached $percent% of your daily session goal.';
    } else if (percent > 0) {
      return 'You\'re on your way! $percent% of your daily goal completed.';
    } else {
      return 'Start your first activity today to reach your goal!';
    }
  }

  void _populateRecentJourney(List<dynamic> moods, List<dynamic> activities) {
    final list = <RecentActivity>[];

    // Add activities
    for (var a in activities.take(10)) {
      final type = a.activityType.toString();
      final capitalizedTitle = type.isNotEmpty
          ? '${type[0].toUpperCase()}${type.substring(1)}'
          : type;

      list.add(
        RecentActivity(
          title: capitalizedTitle,
          date: a.createdAt,
          duration: '${a.durationMinutes} min',
          icon: _getIconForActivity(a.activityType),
          type: 'Activity',
        ),
      );
    }

    // Add moods
    for (var m in moods.take(10)) {
      list.add(
        RecentActivity(
          title: 'Mood: ${m.label}',
          date: m.createdAt,
          duration: m.emoji,
          icon: m.emoji,
          type: 'Mood',
        ),
      );
    }

    // Sort combined list by date
    list.sort((a, b) => b.date.compareTo(a.date));
    recentActivities.value = list.take(6).toList();

    print(
      'DEBUG: Recent journey populated with ${recentActivities.length} items',
    );
  }

  String _getIconForActivity(String type) {
    switch (type.toLowerCase()) {
      case 'breathing':
        return '🌬️';
      case 'meditation':
        return '🧘';
      case 'journal':
      case 'journaling':
        return '📝';
      case 'sleepstories':
      case 'sleep':
        return '🌙';
      case 'yoga':
        return '🧘‍♀️';
      case 'mindfulwalk':
      case 'walk':
        return '🚶‍♂️';
      default:
        return '✨';
    }
  }

  double get progressPercent => dailyGoal.value > 0
      ? (dailyProgress.value / dailyGoal.value).clamp(0.0, 1.0)
      : 0.0;
}

class Achievement {
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final int color;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.color,
  });
}

class RecentActivity {
  final String title;
  final DateTime date;
  final String duration;
  final String icon;
  final String type;

  RecentActivity({
    required this.title,
    required this.date,
    required this.duration,
    required this.icon,
    required this.type,
  });
}
