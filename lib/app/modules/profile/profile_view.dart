import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildArchitecturalHeader(),
                const SizedBox(height: 32),
                _buildInsightRail(),
                const SizedBox(height: 60),
                _buildCategoryLabel('GENERAL'),
                const SizedBox(height: 24),
                ..._buildSettingsRail(),
                const SizedBox(height: 48),
                _buildSignOutLink(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArchitecturalHeader() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white24),
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName.value,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.email.value.toLowerCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white60,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.cyanAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    controller.memberSince.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cyanAccent,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              image: controller.avatarUrl.value != null
                  ? DecorationImage(
                      image: NetworkImage(controller.avatarUrl.value!),
                      fit: BoxFit.cover,
                    )
                  : null,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: controller.avatarUrl.value == null
                ? const Icon(Icons.person, color: Colors.white24, size: 32)
                : null,
          ),
        ],
      );
    }).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildInsightRail() {
    return Row(
      children: [
        _buildMiniInsight('7d Streak', '🔥'),
        const SizedBox(width: 24),
        _buildMiniInsight('42 Sessions', '🧘'),
        const SizedBox(width: 24),
        _buildMiniInsight('6.3h Wellness', '⏱️'),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildMiniInsight(String text, String icon) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.white24,
        letterSpacing: 2,
      ),
    );
  }

  List<Widget> _buildSettingsRail() {
    return controller.settingsItems.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(item.icon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            if (item.hasToggle)
              Obx(
                () => Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: controller.notificationsEnabled.value,
                    onChanged: (_) => controller.toggleNotifications(),
                    activeColor: AppColors.cyanAccent,
                    inactiveTrackColor: Colors.white.withOpacity(0.05),
                  ),
                ),
              )
            else if (item.hasArrow)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white60,
                size: 16,
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSignOutLink() {
    return Center(
      child: TextButton(
        onPressed: controller.signOut,
        child: Text(
          'Log out of Account',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.redAccent.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
