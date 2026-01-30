import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class BrandedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const BrandedButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<BrandedButton> createState() => _BrandedButtonState();
}

class _BrandedButtonState extends State<BrandedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => _controller.forward();
  void _handleTapUp(TapUpDetails details) => _controller.reverse();
  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: AppColors.cyanAccent,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    widget.text,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
