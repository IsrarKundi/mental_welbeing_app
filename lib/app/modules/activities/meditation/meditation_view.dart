import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
          'Meditate',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
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
              const SizedBox(height: 24),
              _buildDurationSelector(),
              const Spacer(flex: 1),
              _buildControls(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: List.generate(controller.meditationTypes.length, (index) {
            final type = controller.meditationTypes[index];
            final isSelected = controller.selectedTypeIndex.value == index;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                controller.selectType(index);
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
                      ? Color(type.color).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? Color(type.color).withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.icon, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      type.name,
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
      final type = controller.selectedType;
      return MeditationTimerRing(
        progress: controller.progress,
        formattedTime: controller.formattedTime,
        typeName: type.name,
        typeColor: Color(type.color),
        isPlaying: controller.isPlaying.value,
      );
    });
  }

  Widget _buildDurationSelector() {
    return Obx(() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.availableDurations.map((duration) {
              final isSelected = controller.selectedDuration.value == duration;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  controller.selectDuration(duration);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 48,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cyanAccent
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      '$duration',
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),
          Text(
            'minutes',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white38),
          ),
        ],
      );
    });
  }

  Widget _buildControls() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset
          GestureDetector(
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
          // Play/Pause
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              controller.togglePlay();
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.cyanAccent, AppColors.tealAccent],
                ),
              ),
              child: Icon(
                controller.isPlaying.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Sound toggle (placeholder)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Implement sound toggle
            },
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
      ),
    );
  }
}

// Meditation Timer Ring Widget
class MeditationTimerRing extends StatelessWidget {
  final double progress;
  final String formattedTime;
  final String typeName;
  final Color typeColor;
  final bool isPlaying;

  const MeditationTimerRing({
    Key? key,
    required this.progress,
    required this.formattedTime,
    required this.typeName,
    required this.typeColor,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Timer Ring
          CustomPaint(
            painter: MeditationRingPainter(
              progress: progress,
              progressColor: typeColor,
            ),
            size: const Size(240, 240),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formattedTime,
                style: GoogleFonts.poppins(
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                typeName.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: typeColor,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MeditationRingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  MeditationRingPainter({required this.progress, required this.progressColor});

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
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MeditationRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor;
}
