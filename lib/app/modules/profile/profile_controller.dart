import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final _authRepo = AuthRepository();

  final userName = 'User'.obs;
  final email = ''.obs;
  final joinDate = DateTime(2024, 6, 15).obs;

  final notificationsEnabled = true.obs;
  final darkMode = true.obs;
  final reminderTime = '09:00 AM'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authRepo.currentUser;
    if (user != null) {
      email.value = user.email ?? '';
      userName.value = user.userMetadata?['full_name'] ?? 'User';
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
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
