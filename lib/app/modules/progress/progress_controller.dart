import 'package:get/get.dart';

class ProgressController extends GetxController {
  final currentStreak = 7.obs;
  final longestStreak = 14.obs;
  final totalSessions = 42.obs;
  final totalMinutes = 380.obs;

  final weeklyGoal = 5.obs;
  final weeklyProgress = 3.obs;

  final achievements = [
    Achievement(
      title: 'First Steps',
      description: 'Complete your first session',
      icon: '🎯',
      isUnlocked: true,
      color: 0xFF22C55E,
    ),
    Achievement(
      title: 'Week Warrior',
      description: 'Complete 7 sessions in a row',
      icon: '🔥',
      isUnlocked: true,
      color: 0xFFF59E0B,
    ),
    Achievement(
      title: 'Mindful Master',
      description: 'Log 30 days of moods',
      icon: '🧘',
      isUnlocked: false,
      color: 0xFF8B5CF6,
    ),
    Achievement(
      title: 'Night Owl',
      description: 'Listen to 10 sleep stories',
      icon: '🌙',
      isUnlocked: false,
      color: 0xFF6366F1,
    ),
    Achievement(
      title: 'Gratitude Guru',
      description: 'Write 20 journal entries',
      icon: '📝',
      isUnlocked: false,
      color: 0xFFEC4899,
    ),
  ];

  final recentActivities = [
    RecentActivity(
      title: 'Breathing Exercise',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      duration: '5 min',
      icon: '🌬️',
    ),
    RecentActivity(
      title: 'Morning Meditation',
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: '10 min',
      icon: '🧘',
    ),
    RecentActivity(
      title: 'Gratitude Journal',
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: '5 min',
      icon: '📝',
    ),
    RecentActivity(
      title: 'Sleep Stories',
      date: DateTime.now().subtract(const Duration(days: 2)),
      duration: '20 min',
      icon: '🌙',
    ),
  ];

  double get weeklyProgressPercent => weeklyProgress.value / weeklyGoal.value;
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

  RecentActivity({
    required this.title,
    required this.date,
    required this.duration,
    required this.icon,
  });
}
