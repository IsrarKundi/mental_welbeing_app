import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import '../widgets/completion_feedback_widget.dart';
import 'mindful_walk_controller.dart';

class MindfulWalkView extends GetView<MindfulWalkController> {
  const MindfulWalkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set up completion callback
    controller.onSessionComplete = () {
      _showCompletionModal(context);
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          key: const ValueKey('mindful_walk_back_button'),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Mindful Walk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
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
              const SizedBox(height: 16),
              _buildTypeSelector(),
              const Spacer(flex: 1),
              _buildTimerRing(),
              const Spacer(flex: 1),
              _buildMindfulnessPrompt(),
              const SizedBox(height: 48),
              _buildControls(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompletionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => CompletionFeedbackWidget(
        title: 'Walk Complete!',
        message:
            'You\'ve finished your mindful walk. Great job staying present!',
        onFinish: () {
          controller.logSession();
          Get.back(); // Return to previous screen
        },
        onRedo: () {
          controller.reset();
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: List.generate(controller.environments.length, (index) {
            final env = controller.environments[index];
            final isSelected = controller.selectedEnvironment.value == index;
            return GestureDetector(
              key: ValueKey('mindful_walk_env_${env.name.toLowerCase()}'),
              onTap: () {
                HapticFeedback.selectionClick();
                controller.selectEnvironment(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(env.color).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? Color(env.color).withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(env.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      env.name,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildTimerRing() {
    return Obx(() {
      final env = controller.currentEnvironment;
      return SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(240, 240),
              painter: MindfulWalkRingPainter(
                progress: controller.progress,
                color: Color(env.color),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.formattedTime,
                  style: GoogleFonts.poppins(
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  env.name.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(env.color),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMindfulnessPrompt() {
    return Obx(() {
      final env = controller.currentEnvironment;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Text(
                  controller.currentPrompt,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                )
                .animate(key: ValueKey(controller.currentPrompt))
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 12),
            Container(
              height: 1,
              width: 30,
              color: Color(env.color).withOpacity(0.2),
            ),
            const SizedBox(height: 12),
            Text(
              env.tip,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white24,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildControls() {
    return Obx(() {
      final env = controller.currentEnvironment;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset
          GestureDetector(
            key: const ValueKey('mindful_walk_reset_button'),
            onTap: () {
              HapticFeedback.lightImpact();
              controller.reset();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white54,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Play/Pause/Stop
          GestureDetector(
            key: const ValueKey('mindful_walk_toggle_button'),
            onTap: () {
              if (controller.isWalking.value) {
                controller.stopWalkingManually();
              } else {
                controller.toggleWalking();
              }
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(env.color), Color(env.color).withOpacity(0.7)],
                ),
              ),
              child: Icon(
                controller.isWalking.value
                    ? Icons.stop_rounded
                    : Icons.directions_walk_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Volume
          GestureDetector(
            key: const ValueKey('mindful_walk_volume_button'),
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: Colors.white54,
                size: 24,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class MindfulWalkRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  MindfulWalkRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 6.0;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0.001) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final sweepAngle = 2 * pi * progress;

      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MindfulWalkRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
