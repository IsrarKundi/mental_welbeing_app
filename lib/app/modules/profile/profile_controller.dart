import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = 'Mustafa'.obs;
  final email = 'mustafa@example.com'.obs;
  final joinDate = DateTime(2024, 6, 15).obs;

  final notificationsEnabled = true.obs;
  final darkMode = true.obs;
  final reminderTime = '09:00 AM'.obs;

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
      icon: '🎨',
      title: 'Appearance',
      subtitle: 'Dark mode enabled',
      hasArrow: true,
    ),
    SettingsItem(
      icon: '🔐',
      title: 'Privacy',
      subtitle: 'Manage your data',
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
