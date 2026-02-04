import 'dart:math';
import 'package:flutter/material.dart';

/// A reusable progress ring widget with premium styling.
///
/// This widget consolidates the duplicate ProgressRingPainter classes
/// from breathing_view.dart and meditation_view.dart.
class ProgressRing extends StatelessWidget {
  /// The progress value from 0.0 to 1.0
  final double progress;

  /// The primary color for the filled arc
  final Color color;

  /// Size of the ring (width and height)
  final double size;

  /// Width of the ring stroke
  final double strokeWidth;

  /// Optional child widget to place in the center
  final Widget? child;

  /// Whether to show a glow effect around the progress
  final bool showGlow;

  /// Background color of the unfilled ring
  final Color? backgroundColor;

  const ProgressRing({
    Key? key,
    required this.progress,
    required this.color,
    this.size = 200,
    this.strokeWidth = 8,
    this.child,
    this.showGlow = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress ring
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              progress: progress,
              color: color,
              strokeWidth: strokeWidth,
              showGlow: showGlow,
              backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.1),
            ),
          ),
          // Child content
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Custom painter for the progress ring.
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool showGlow;
  final Color backgroundColor;

  _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.showGlow,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Add glow effect
      if (showGlow) {
        final glowPaint = Paint()
          ..color = color.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth * 2
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2, // Start from top
          2 * pi * progress,
          false,
          glowPaint,
        );
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // Start from top
        2 * pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// A more advanced progress ring with gradient support.
/// Used for breathing and meditation exercises.
class GradientProgressRing extends StatelessWidget {
  final double progress;
  final List<Color> gradientColors;
  final double size;
  final double strokeWidth;
  final Widget? child;

  const GradientProgressRing({
    Key? key,
    required this.progress,
    required this.gradientColors,
    this.size = 200,
    this.strokeWidth = 10,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _GradientProgressRingPainter(
              progress: progress,
              gradientColors: gradientColors,
              strokeWidth: strokeWidth,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _GradientProgressRingPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  _GradientProgressRingPainter({
    required this.progress,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      // Gradient arc
      final gradient = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: gradientColors,
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(_GradientProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
