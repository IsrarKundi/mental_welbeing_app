import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_pages.dart';
import '../../data/services/sos_service.dart';
import '../../utils/app_image_provider.dart';
import '../../widgets/liquid_glass_container.dart';
import 'home_controller.dart';
import 'mood_checkin_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background that rebuilds on gradient change
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              decoration: BoxDecoration(gradient: controller.currentGradient),
              child: const SizedBox.expand(),
            ),
          ),
          // Scrollable content that stays static
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildHeader(),
                ),
                const SizedBox(height: 8),
                _buildDailyFocus(),
                const SizedBox(height: 14),
                _buildMoodTracker(),
                _buildSuggestedActionCard(),
                _buildDailyActions(),
                const SizedBox(height: 10), // Space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.greeting,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
            Obx(
              () => Text(
                controller.userName.value,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 8),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
                color: Colors.white.withOpacity(0.1),
              ),
              child: ClipOval(
                child: Obx(() {
                  final imageUrl = controller.profileImageUrl.value;
                  if (imageUrl.isEmpty) {
                    return const Icon(
                      LucideIcons.user,
                      color: Colors.white70,
                      size: 24,
                    );
                  }
                  return AppImageProvider.buildImage(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        LucideIcons.user,
                        color: Colors.white70,
                        size: 24,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildDailyFocus() {
    return GestureDetector(
          onTap: () => Get.toNamed(Routes.MEDITATION),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AppImageProvider.getProvider(
                  'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&w=800&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cyanAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'DAILY FOCUS',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Finding Inner Peace in a\nBusy World",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '10 min meditation',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildMoodTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How are you feeling?',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  // Streak Badge
                  // Obx(
                  //   () => controller.moodStreak.value > 0
                  //       ? Container(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 10,
                  //             vertical: 6,
                  //           ),
                  //           margin: const EdgeInsets.only(right: 8),
                  //           decoration: BoxDecoration(
                  //             gradient: const LinearGradient(
                  //               colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  //             ),
                  //             borderRadius: BorderRadius.circular(20),
                  //           ),
                  //           child: Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               const Text(
                  //                 '🔥',
                  //                 style: TextStyle(fontSize: 12),
                  //               ),
                  //               const SizedBox(width: 4),
                  //               Text(
                  //                 '${controller.moodStreak.value}',
                  //                 style: GoogleFonts.poppins(
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.w600,
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         )
                  //       : const SizedBox.shrink(),
                  // ),

                  // History Button
                  GestureDetector(
                    key: const ValueKey('home_history_button'),
                    onTap: () => Get.toNamed(Routes.MOOD_HISTORY),
                    child: LiquidGlassContainer(
                      width: 85,
                      height: 32,
                      borderRadius: 20,
                      alignment: Alignment.center,
                      isAnimate: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'History',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.insights_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 112,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            scrollDirection: Axis.horizontal,
            itemCount: controller.moods.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final mood = controller.moods[index];
              return Obx(() {
                final isSelected = controller.currentMoodIndex.value == index;

                return GestureDetector(
                  key: ValueKey('mood_tile_${mood.label.toLowerCase()}'),
                  onTap: () async {
                    controller.selectMood(index);
                    final note = await showMoodCheckinSheet(context, mood);
                    controller.logMoodWithNote(note);
                  },
                  child: Column(
                    children: [
                      // Mood Tile
                      LiquidGlassContainer(
                            width: 64,
                            height: 64,
                            borderRadius: 50,
                            blur: isSelected ? 0 : 15,
                            alignment: Alignment.center,
                            isAnimate: false, // Handled by outer animate()
                            linearGradient: isSelected ? mood.gradient : null,
                            borderGradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.4),
                                      Colors.white.withOpacity(0.2),
                                    ],
                                  )
                                : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                mood.iconUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                color: isSelected
                                    ? null
                                    : Colors.black.withOpacity(0.3),
                                colorBlendMode: isSelected
                                    ? null
                                    : BlendMode.darken,
                              ),
                            ),
                          )
                          .animate(target: isSelected ? 1 : 0)
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.1, 1.1),
                            duration: 400.ms,
                            curve: Curves.easeOutBack,
                          ),
                      const SizedBox(height: 8),
                      // Mood Label
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.white54,
                        ),
                        child: Text(mood.label),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedActionCard() {
    return Obx(() {
      final mood = controller.currentMood;
      final show =
          controller.showSuggestedAction.value &&
          !controller.suggestedActionDismissed.value &&
          mood.suggestedActivityTitle != null;

      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: show
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child:
                    LiquidGlassContainer(
                          width: double.infinity,
                          height: 80,
                          borderRadius: 20,
                          blur: 20,
                          alignment: Alignment.center,
                          isAnimate: false, // Handled by outer animate()
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              mood.gradient.colors.first.withOpacity(0.25),
                              mood.gradient.colors.last.withOpacity(0.15),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                // Character Image
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: mood.gradient,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      mood.iconUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Text Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        mood.suggestedActivityTitle!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        mood.suggestedActivityMessage ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Action Buttons
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      key: const ValueKey(
                                        'suggested_action_try_button',
                                      ),
                                      onTap: controller.openSuggestedActivity,
                                      child: LiquidGlassContainer(
                                        width: 70,
                                        height: 32,
                                        borderRadius: 20,
                                        blur: 10,
                                        isAnimate: false,
                                        child: Center(
                                          child: Text(
                                            'Try it',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      key: const ValueKey(
                                        'suggested_action_dismiss_button',
                                      ),
                                      onTap: controller.dismissSuggestedAction,
                                      child: Text(
                                        'Dismiss',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
              )
            : const SizedBox.shrink(),
      );
    });
  }

  Widget _buildDailyActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Daily Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: controller.dailyActions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final action = controller.dailyActions[index];
              return GestureDetector(
                    key: ValueKey(
                      'daily_action_${action.title.toLowerCase().replaceAll(' ', '_')}',
                    ),
                    onTap: () => controller.openActivity(action),
                    child: Semantics(
                      label:
                          '${action.title} - ${action.duration} - ${action.difficulty}',
                      button: true,
                      child: Container(
                        width: 160,
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Glass backdrop layer
                            Positioned.fill(
                              child: LiquidGlassContainer(
                                borderRadius: 22,
                                blur: 25,
                                isAnimate: false,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.04),
                                  ],
                                ),
                                child: const SizedBox.expand(),
                              ),
                            ),

                            // Character Area (The Hero)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 70,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(22),
                                  topRight: Radius.circular(22),
                                ),
                                child: Hero(
                                  tag: 'action_image_${action.title}',
                                  child: AppImageProvider.buildImage(
                                    action.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            // Duration Pill (top-left) - Moved slightly inside for safety
                            Positioned(
                              top: 10,
                              left: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    color: Colors.black.withOpacity(0.1),
                                    child: Text(
                                      action.duration,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Bottom Info Section
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  0,
                                  12,
                                  16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      action.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,

                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          LucideIcons.barChart2,
                                          size: 12,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          action.difficulty,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 100 * index),
                    duration: 500.ms,
                  )
                  .scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutCubic,
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSOSButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: GestureDetector(
        onTap: () {
          SOSService.showSOSDialog();
        },
        child:
            Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 30,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                ),
      ),
    );
  }
}
