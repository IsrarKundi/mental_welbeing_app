import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LiquidGlassContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final double borderRadius;
  final double blur;
  final double border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isAnimate;
  final LinearGradient? linearGradient;
  final LinearGradient? borderGradient;
  final Alignment? alignment;

  const LiquidGlassContainer({
    Key? key,
    this.width,
    this.height,
    required this.child,
    this.borderRadius = 20.0,
    this.blur = 15.0,
    this.border = 1.0,
    this.padding,
    this.margin,
    this.isAnimate = true,
    this.linearGradient,
    this.borderGradient,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final glassWidget = Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderGradient == null
                  ? Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: border,
                    )
                  : GradientBorder(gradient: borderGradient!, width: border),
              gradient:
                  linearGradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.12),
                    ],
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (isAnimate) {
      return glassWidget.animate().fade(duration: 400.ms);
    }
    return glassWidget;
  }
}

// Simple helper for gradient borders in fallback
class GradientBorder extends BoxBorder {
  final LinearGradient gradient;
  final double width;

  const GradientBorder({required this.gradient, this.width = 1.0});

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadiusGeometry? borderRadius,
  }) {
    final paint = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    if (shape == BoxShape.circle) {
      canvas.drawCircle(rect.center, rect.width / 2, paint);
    } else {
      final rRect = borderRadius!.resolve(textDirection).toRRect(rect);
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  ShapeBorder scale(double t) => this;
}
