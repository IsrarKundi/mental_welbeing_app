import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'liquid_glass_container.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSend;
  final IconData? sendIcon;
  final double height;
  final double borderRadius;

  const GlassTextField({
    Key? key,
    required this.controller,
    this.hintText = 'Type a message...',
    this.onSend,
    this.sendIcon = Icons.send,
    this.height = 50,
    this.borderRadius = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      height: height,
      borderRadius: borderRadius,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,

              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          if (onSend != null && sendIcon != null)
            IconButton(
              icon: Icon(sendIcon, color: Colors.white),
              onPressed: onSend,
            ),
        ],
      ),
    );
  }
}
