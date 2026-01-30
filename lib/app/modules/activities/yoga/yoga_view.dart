import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import '../widgets/completion_feedback_widget.dart';
import 'yoga_controller.dart';

class YogaView extends GetView<YogaController> {
  const YogaView({super.key});

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Yoga Session',
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildPoseCarousel(),
                        const Spacer(flex: 1),
                        _buildTimerRing(),
                        const Spacer(flex: 1),
                        _buildPoseInfo(),
                        const SizedBox(height: 48),
                        _buildControls(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              );
            },
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
        title: 'Yoga Complete!',
        message:
            'Namaste! You\'ve finished your yoga session. Great job staying flexible!',
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

  Widget _buildPoseCarousel() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: List.generate(controller.poses.length, (index) {
            final pose = controller.poses[index];
            final isSelected = controller.selectedPoseIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectPose(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(pose.color).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? Color(pose.color).withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(pose.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      pose.name,
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
    }).animate().fadeIn(duration: const Duration(milliseconds: 400));
  }

  Widget _buildTimerRing() {
    return Obx(() {
      final pose = controller.currentPose;
      return SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(240, 240),
              painter: YogaTimerRingPainter(
                progress: controller.progress,
                color: Color(pose.color),
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
                  pose.sanskritName.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(pose.color),
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

  Widget _buildPoseInfo() {
    return Obx(() {
      final pose = controller.currentPose;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Text(
              pose.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(pose.color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                pose.difficulty.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(pose.color),
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Text(
                    pose.instructions,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                )
                .animate(key: ValueKey(pose.name))
                .fadeIn(duration: const Duration(milliseconds: 400))
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      );
    });
  }

  Widget _buildControls() {
    return Obx(() {
      final pose = controller.currentPose;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous
          GestureDetector(
            onTap: controller.previousPose,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.skip_previous_rounded,
                color: Colors.white54,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Play/Pause
          GestureDetector(
            onTap: controller.togglePose,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(pose.color),
                    Color(pose.color).withOpacity(0.7),
                  ],
                ),
              ),
              child: Icon(
                controller.isInPose.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Next
          GestureDetector(
            onTap: controller.nextPose,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.skip_next_rounded,
                color: Colors.white54,
                size: 28,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class YogaTimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  YogaTimerRingPainter({required this.progress, required this.color});

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
  bool shouldRepaint(covariant YogaTimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
