import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType? keyboardType;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 12.w),
            child: Icon(icon, color: Colors.white70, size: 22.sp),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white38,
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          suffixIcon: isPassword
              ? Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white38,
                      size: 20.sp,
                    ),
                    onPressed: onToggleVisibility,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
