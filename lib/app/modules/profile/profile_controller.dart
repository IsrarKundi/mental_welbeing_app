import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/mood_repository.dart';
import '../../data/repositories/activity_repository.dart';

class ProfileController extends GetxController {
  final _authRepo = AuthRepository();
  final _profileRepo = ProfileRepository();
  final _moodRepo = MoodRepository();
  final _activityRepo = ActivityRepository();

  final userName = 'User'.obs;
  final email = ''.obs;
  final avatarUrl = RxnString();
  final joinDate = DateTime.now().obs;
  final isLoading = false.obs;
  final notificationsEnabled = true.obs;

  // Real stats for the Insight Rail
  final currentStreak = 0.obs;
  final totalSessions = 0.obs;
  final wellnessTime = '0h'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    isLoading.value = true;
    try {
      final user = _authRepo.currentUser;
      if (user != null) {
        email.value = user.email ?? '';

        final profile = await _profileRepo.getProfile();
        userName.value = profile.fullName ?? 'User';
        avatarUrl.value = profile.avatarUrl;
        joinDate.value = profile.updatedAt;

        // Fetch Stats
        final moods = await _moodRepo.getMoods();
        final activities = await _activityRepo.getActivities();

        totalSessions.value = moods.length + activities.length;

        final minutes = activities.fold(0, (sum, a) => sum + a.durationMinutes);
        wellnessTime.value = '${(minutes / 60).toStringAsFixed(1)}h';

        _calculateStreak(moods, activities);
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStreak(List<dynamic> moods, List<dynamic> activities) {
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
      } else if (date.isBefore(checkDate))
        break;
    }
    currentStreak.value = streak;
  }

  Future<void> signOut() async {
    try {
      await _authRepo.signOut();
      Get.offAllNamed('/login'); // Redirect to login
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out.');
    }
  }

  final settingsItems = [
    SettingsItem(
      icon: '🔔',
      title: 'Notifications',
      subtitle: 'Daily reminders & updates',
      hasToggle: true,
    ),
    SettingsItem(
      icon: '⏰',
      title: 'Daily Reminder',
      subtitle: '09:00 AM',
      hasArrow: true,
    ),
    SettingsItem(
      icon: '❓',
      title: 'Help & Support',
      subtitle: 'FAQs and contact',
      hasArrow: true,
    ),
    SettingsItem(
      icon: '📄',
      title: 'Terms & Privacy',
      subtitle: 'Legal information',
      hasArrow: true,
    ),
  ];

  String get memberSince {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Member since ${months[joinDate.value.month - 1]} ${joinDate.value.year}';
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }
}

class SettingsItem {
  final String icon;
  final String title;
  final String subtitle;
  final bool hasToggle;
  final bool hasArrow;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.hasToggle = false,
    this.hasArrow = false,
  });
}
