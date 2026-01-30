import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final _authRepo = AuthRepository();
  final _profileRepo = ProfileRepository();

  final userName = 'User'.obs;
  final email = ''.obs;
  final avatarUrl = RxnString();
  final joinDate = DateTime.now().obs;
  final isLoading = false.obs;
  final notificationsEnabled = true.obs;

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
        joinDate.value = profile.updatedAt; // Using updatedAt as proxy for now
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
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
