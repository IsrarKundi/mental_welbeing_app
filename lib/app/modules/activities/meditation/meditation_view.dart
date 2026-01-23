import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import 'meditation_controller.dart';

class MeditationView extends GetView<MeditationController> {
  const MeditationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Meditation',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMeditationTypes(),
                  const SizedBox(height: 40),
                  _buildTimerRing(),
                  const SizedBox(height: 30),
                  _buildDurationSelector(),
                  const SizedBox(height: 40),
                  _buildControls(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Focus',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.meditationTypes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final type = controller.meditationTypes[index];
              return Obx(() {
                final isSelected = controller.selectedTypeIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectType(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 90,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(type.color).withOpacity(0.3)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Color(type.color)
                            : Colors.white.withOpacity(0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(type.icon, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text(
                          type.name,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildTimerRing() {
    return Obx(() {
      final type = controller.selectedType;
      return Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(type.color).withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // Progress ring background
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 8,
              ),
            ),
          ),
          // Progress ring
          SizedBox(
            width: 240,
            height: 240,
            child: CircularProgressIndicator(
              value: controller.progress,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color(type.color)),
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(type.icon, style: const TextStyle(fontSize: 40))
                  .animate(
                    onPlay: controller.isPlaying.value
                        ? (c) => c.repeat(reverse: true)
                        : null,
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 2000.ms,
                  ),
              const SizedBox(height: 12),
              Text(
                controller.formattedTime,
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              Text(
                type.description,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDurationSelector() {
    return Column(
      children: [
        Text(
          'Duration',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.availableDurations.map((duration) {
              final isSelected = controller.selectedDuration.value == duration;
              return GestureDetector(
                onTap: () => controller.selectDuration(duration),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cyanAccent
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.cyanAccent
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '$duration',
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'minutes',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset button
          GestureDetector(
            onTap: controller.reset,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Play/Pause button
          GestureDetector(
            onTap: controller.togglePlay,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.cyanAccent, AppColors.tealAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyanAccent.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                controller.isPlaying.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ).animate().scale(duration: 200.ms),
          const SizedBox(width: 24),
          // Settings placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white70,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
