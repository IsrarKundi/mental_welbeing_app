import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  _buildArchitecturalHeader(context),
                  SizedBox(height: 32.h),
                  _buildInsightRail(),
                  SizedBox(height: 32.h),
                  _buildCategoryLabel('Settings'),
                  SizedBox(height: 16.h),
                  ..._buildSettingsRail(),
                  SizedBox(height: 40.h),
                  _buildSignOutLink(),
                  SizedBox(height: 100.h), // Space for FAB/Navbar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArchitecturalHeader(BuildContext context) {
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
        GestureDetector(
          onTap: () => _showImageSourceSheet(context),
          child: Stack(
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: Obx(() {
                    final imageUrl = controller.avatarUrl.value;
                    if (imageUrl == null || imageUrl.isEmpty) {
                      return Icon(
                        LucideIcons.user,
                        color: Colors.white24,
                        size: 36.sp,
                      );
                    }
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          LucideIcons.user,
                          color: Colors.white24,
                          size: 36.sp,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white24,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.cyanAccent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0F172A),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0);
  }

  void _showImageSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Profile Picture',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            _buildSourceOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take a Photo',
              onTap: () {
                Get.back();
                controller.pickAndUploadAvatar(ImageSource.camera);
              },
            ),
            SizedBox(height: 16.h),
            _buildSourceOption(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              onTap: () {
                Get.back();
                controller.pickAndUploadAvatar(ImageSource.gallery);
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.cyanAccent, size: 20.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRail() {
    return Row(
      children: [
        _buildMiniInsight('${controller.currentStreak.value}d Streak', '🔥'),
        const SizedBox(width: 24),
        _buildMiniInsight('${controller.totalSessions.value} Sessions', '🧘'),
        const SizedBox(width: 24),
        _buildMiniInsight('${controller.wellnessTime.value} Wellness', '⏱️'),
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
