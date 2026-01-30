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

  const LiquidGlassContainer({
    Key? key,
    this.width,
    this.height,
    required this.child,
    this.borderRadius = 20.0,
    this.blur = 20.0,
    this.border = 1.5,
    this.padding,
    this.margin,
    this.isAnimate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    ).animate().fade(duration: 400.ms);
  }
}
