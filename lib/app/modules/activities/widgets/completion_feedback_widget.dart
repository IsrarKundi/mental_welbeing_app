import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';

class CompletionFeedbackWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onFinish;
  final VoidCallback onRedo;

  const CompletionFeedbackWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.onFinish,
    required this.onRedo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyanAccent.withOpacity(0.1),
                ),
                child: const Center(
                  child: Text('✨', style: TextStyle(fontSize: 40)),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: const Duration(seconds: 2),
                color: AppColors.cyanAccent.withOpacity(0.3),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOutSine,
              ),

          const SizedBox(height: 24),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white60,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: _buildButton(
                  'REDO',
                  Colors.white.withOpacity(0.05),
                  Colors.white70,
                  onRedo,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildButton(
                  'FINISH',
                  AppColors.cyanAccent,
                  Colors.white,
                  onFinish,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color background,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Get.back(); // Close modal
        onTap();
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
