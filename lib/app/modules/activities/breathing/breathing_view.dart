import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../../../theme/app_colors.dart';
import '../widgets/completion_feedback_widget.dart';
import 'breathing_controller.dart';

class BreathingView extends GetView<BreathingController> {
  const BreathingView({Key? key}) : super(key: key);

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
          key: const ValueKey('breathing_back_button'),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Breathe',
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
              const Spacer(flex: 2),
              _buildBreathingRing(),
              const Spacer(flex: 1),
              _buildPhaseText(),
              const Spacer(flex: 2),
              _buildCycleIndicator(),
              const SizedBox(height: 40),
              _buildControls(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingRing() {
    return Obx(() {
      final phase = controller.currentPhase.value;
      final isPlaying = controller.isPlaying.value;

      return PremiumBreathingRing(
        phase: phase,
        isPlaying: isPlaying,
        inhaleDuration: controller.inhaleDuration.value,
        holdDuration: controller.holdDuration.value,
        exhaleDuration: controller.exhaleDuration.value,
        restDuration: controller.restDuration.value,
      );
    });
  }

  Widget _buildPhaseText() {
    return Obx(
      () => Text(
        controller.phaseSubtext,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white.withOpacity(0.5),
          letterSpacing: 0.5,
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildCycleIndicator() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: [
            Text(
              'Cycle ${controller.currentCycle.value + 1} of ${controller.totalCycles.value}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final progress =
                    (controller.currentCycle.value + 1) /
                    controller.totalCycles.value;
                return Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: constraints.maxWidth * progress,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.cyanAccent, AppColors.tealAccent],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Reset
          GestureDetector(
            key: const ValueKey('breathing_reset_button'),
            onTap: () {
              HapticFeedback.lightImpact();
              controller.resetSession();
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
            key: const ValueKey('breathing_play_pause_button'),
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
          // Settings
          GestureDetector(
            key: const ValueKey('breathing_settings_button'),
            onTap: () {
              HapticFeedback.lightImpact();
              _showSettingsSheet(Get.context!);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white54,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e).withOpacity(0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Settings',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildSettingRow('Inhale', controller.inhaleDuration, 2, 10, 's'),
              _buildSettingRow('Hold', controller.holdDuration, 1, 10, 's'),
              _buildSettingRow('Exhale', controller.exhaleDuration, 2, 12, 's'),
              _buildSettingRow('Rest', controller.restDuration, 1, 6, 's'),
              const SizedBox(height: 12),
              _buildSettingRow('Cycles', controller.totalCycles, 1, 10, ''),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    String label,
    RxInt value,
    int min,
    int max,
    String suffix,
  ) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
            Row(
              children: [
                GestureDetector(
                  key: ValueKey(
                    'breathing_setting_minus_${label.toLowerCase()}',
                  ),
                  onTap: () {
                    if (value.value > min) value.value--;
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${value.value}$suffix',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                ),
                GestureDetector(
                  key: ValueKey(
                    'breathing_setting_plus_${label.toLowerCase()}',
                  ),
                  onTap: () {
                    if (value.value < max) value.value++;
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
        title: 'Breathe Complete!',
        message:
            'You\'ve finished your breathing exercise. Great job staying focused!',
        onFinish: () {
          controller.logSession();
          Get.back(); // Return to previous screen
        },
        onRedo: () {
          controller.resetSession();
        },
      ),
    );
  }
}

// Premium Breathing Ring
class PremiumBreathingRing extends StatefulWidget {
  final BreathingPhase phase;
  final bool isPlaying;
  final int inhaleDuration;
  final int holdDuration;
  final int exhaleDuration;
  final int restDuration;

  const PremiumBreathingRing({
    Key? key,
    required this.phase,
    required this.isPlaying,
    required this.inhaleDuration,
    required this.holdDuration,
    required this.exhaleDuration,
    required this.restDuration,
  }) : super(key: key);

  @override
  State<PremiumBreathingRing> createState() => _PremiumBreathingRingState();
}

class _PremiumBreathingRingState extends State<PremiumBreathingRing>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _scaleController;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;

  int _secondsRemaining = 0;
  double _lastProgress = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this);
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_progressController);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_scaleController);

    _progressController.addListener(_updateSecondsRemaining);
    _updateAnimation();
  }

  void _updateSecondsRemaining() {
    final duration = _getCurrentDuration();
    final remaining = ((1 - _progressController.value) * duration).ceil();
    if (remaining != _secondsRemaining) {
      setState(() => _secondsRemaining = remaining);
    }
  }

  int _getCurrentDuration() {
    switch (widget.phase) {
      case BreathingPhase.inhale:
        return widget.inhaleDuration;
      case BreathingPhase.hold:
        return widget.holdDuration;
      case BreathingPhase.exhale:
        return widget.exhaleDuration;
      case BreathingPhase.rest:
        return widget.restDuration;
    }
  }

  @override
  void didUpdateWidget(PremiumBreathingRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase ||
        oldWidget.isPlaying != widget.isPlaying) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (!widget.isPlaying) {
      _progressController.stop();
      _scaleController.stop();
      return;
    }

    HapticFeedback.selectionClick();

    double startProgress, endProgress, startScale, endScale;
    int durationSeconds;

    switch (widget.phase) {
      case BreathingPhase.inhale:
        startProgress = 0.0;
        endProgress = 1.0;
        startScale = 1.0;
        endScale = 1.08;
        durationSeconds = widget.inhaleDuration;
        break;
      case BreathingPhase.hold:
        startProgress = 1.0;
        endProgress = 1.0;
        startScale = 1.08;
        endScale = 1.08;
        durationSeconds = widget.holdDuration;
        break;
      case BreathingPhase.exhale:
        startProgress = 1.0;
        endProgress = 0.0;
        startScale = 1.08;
        endScale = 1.0;
        durationSeconds = widget.exhaleDuration;
        break;
      case BreathingPhase.rest:
        startProgress = 0.0;
        endProgress = 0.0;
        startScale = 1.0;
        endScale = 1.0;
        durationSeconds = widget.restDuration;
        break;
    }

    _progressController.duration = Duration(seconds: durationSeconds);
    _scaleController.duration = Duration(seconds: durationSeconds);

    _progressAnimation = Tween<double>(begin: startProgress, end: endProgress)
        .animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
        );
    _scaleAnimation = Tween<double>(begin: startScale, end: endScale).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _progressController.forward(from: 0);
    _scaleController.forward(from: 0);
    _secondsRemaining = durationSeconds;
  }

  @override
  void dispose() {
    _progressController.removeListener(_updateSecondsRemaining);
    _progressController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _getPhaseLabel() {
    switch (widget.phase) {
      case BreathingPhase.inhale:
        return 'IN';
      case BreathingPhase.hold:
        return 'HOLD';
      case BreathingPhase.exhale:
        return 'OUT';
      case BreathingPhase.rest:
        return 'REST';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_progressController, _scaleController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ring
                CustomPaint(
                  painter: MinimalRingPainter(
                    progress: _progressAnimation.value,
                  ),
                  size: const Size(240, 240),
                ),
                // Center content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_secondsRemaining',
                      style: GoogleFonts.poppins(
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPhaseLabel(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.cyanAccent,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MinimalRingPainter extends CustomPainter {
  final double progress;

  MinimalRingPainter({required this.progress});

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
        ..color = AppColors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MinimalRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
