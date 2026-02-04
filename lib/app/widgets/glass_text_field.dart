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

  final Key? textFieldKey;
  final Key? sendButtonKey;

  const GlassTextField({
    Key? key,
    required this.controller,
    this.hintText = 'Type a message...',
    this.onSend,
    this.sendIcon = Icons.send,
    this.height = 50,
    this.borderRadius = 30,
    this.textFieldKey,
    this.sendButtonKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      height: height,
      borderRadius: borderRadius,
      padding: const EdgeInsets.only(left: 20, right: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: textFieldKey,
              controller: controller,

              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              ),
            ),
          ),
          if (onSend != null && sendIcon != null)
            IconButton(
              key: sendButtonKey,
              icon: Icon(sendIcon, color: Colors.white),
              onPressed: onSend,
            ),
        ],
      ),
    );
  }
}
