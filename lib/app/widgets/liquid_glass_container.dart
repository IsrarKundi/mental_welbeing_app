import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_colors.dart';

class LiquidGlassContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final double borderRadius;
  final double blur;
  final double border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          borderRadius: borderRadius,
          blur: blur,
          alignment: Alignment.center,
          border: border,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGlass.withOpacity(0.1),
              AppColors.primaryGlass.withOpacity(0.05),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.borderGlass,
              AppColors.borderGlass.withOpacity(0.1),
            ],
          ),
          margin: margin,
          padding: padding,
          child: child,
        )
        .animate()
        .fade(duration: 600.ms)
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.2))
        .then()
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(begin: 0, end: -5, duration: 2000.ms, curve: Curves.easeInOut);
  }
}
