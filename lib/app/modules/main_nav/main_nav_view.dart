import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../theme/app_colors.dart';
import '../home/home_view.dart';
import '../progress/progress_view.dart';
import '../chat/chat_view.dart';
import '../profile/profile_view.dart';
import 'main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const ProgressView(),
      const ChatView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(
            () => IndexedStack(
              index: controller.currentIndex.value,
              children: pages,
            ),
          ),
          // Floating Navbar
          Positioned(
            left: 21,
            right: 21,
            bottom: 15,
            child:
                Obx(
                  () => GlassmorphicContainer(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 64,
                    borderRadius: 34,
                    blur: 15,
                    alignment: Alignment.center,
                    border: 0.5,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, LucideIcons.home, 'Home'),
                          _buildNavItem(1, LucideIcons.barChartBig, 'Stats'),
                          _buildNavItem(2, LucideIcons.messageCircle, 'Chat'),
                          _buildNavItem(3, LucideIcons.user, 'Profile'),
                        ],
                      ),
                    ),
                  ),
                ).animate().slideY(
                  begin: 1,
                  end: 0,
                  duration: 800.ms,
                  curve: Curves.easeOutExpo,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = controller.currentIndex.value == index;
    final keyName = 'nav_${label.toLowerCase()}_tab';

    return GestureDetector(
      key: ValueKey(keyName),
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.cyanAccent.withOpacity(0.8),
                    AppColors.cyanAccent.withOpacity(0.3),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.2), width: 0.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white54,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isSelected ? 1 : 0,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
