import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import 'breathing_controller.dart';

class BreathingView extends GetView<BreathingController> {
  const BreathingView({Key? key}) : super(key: key);

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
          'Breathing Exercise',
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
          child: Column(
            children: [
              const Spacer(flex: 1),
              _buildBreathingCircle(),
              const SizedBox(height: 40),
              _buildPhaseText(),
              const Spacer(flex: 1),
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              _buildControls(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingCircle() {
    return Obx(() {
      final phase = controller.currentPhase.value;
      final isPlaying = controller.isPlaying.value;

      // Determine animation parameters based on phase
      double targetScale;
      int durationMs;

      switch (phase) {
        case BreathingPhase.inhale:
          targetScale = 1.4;
          durationMs = controller.inhaleDuration * 1000;
          break;
        case BreathingPhase.hold:
          targetScale = 1.4;
          durationMs = controller.holdDuration * 1000;
          break;
        case BreathingPhase.exhale:
          targetScale = 0.8;
          durationMs = controller.exhaleDuration * 1000;
          break;
        case BreathingPhase.rest:
          targetScale = 0.8;
          durationMs = controller.restDuration * 1000;
          break;
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          AnimatedContainer(
            duration: Duration(milliseconds: durationMs),
            curve: Curves.easeInOut,
            width: 280 * (isPlaying ? targetScale : 1.0),
            height: 280 * (isPlaying ? targetScale : 1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.cyanAccent.withOpacity(0.0),
                  AppColors.cyanAccent.withOpacity(0.1),
                ],
              ),
            ),
          ),
          // Middle ring
          AnimatedContainer(
            duration: Duration(milliseconds: durationMs),
            curve: Curves.easeInOut,
            width: 240 * (isPlaying ? targetScale : 1.0),
            height: 240 * (isPlaying ? targetScale : 1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cyanAccent.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          // Inner breathing circle
          AnimatedContainer(
            duration: Duration(milliseconds: durationMs),
            curve: Curves.easeInOut,
            width: 180 * (isPlaying ? targetScale : 1.0),
            height: 180 * (isPlaying ? targetScale : 1.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.cyanAccent.withOpacity(0.6),
                  AppColors.tealAccent.withOpacity(0.3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyanAccent.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Icon(_getPhaseIcon(phase), size: 50, color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  IconData _getPhaseIcon(BreathingPhase phase) {
    switch (phase) {
      case BreathingPhase.inhale:
        return Icons.arrow_upward_rounded;
      case BreathingPhase.hold:
        return Icons.pause_rounded;
      case BreathingPhase.exhale:
        return Icons.arrow_downward_rounded;
      case BreathingPhase.rest:
        return Icons.self_improvement_rounded;
    }
  }

  Widget _buildPhaseText() {
    return Obx(
      () => Column(
        children: [
          Text(
            controller.phaseText,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          Text(
            controller.phaseSubtext,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(
      () => Column(
        children: [
          Text(
            'Cycle ${controller.currentCycle.value + 1} of ${controller.totalCycles}',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor:
                  (controller.currentCycle.value + 1) / controller.totalCycles,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.cyanAccent, AppColors.tealAccent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset button
          GestureDetector(
            onTap: controller.resetSession,
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
              Icons.tune_rounded,
              color: Colors.white70,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
