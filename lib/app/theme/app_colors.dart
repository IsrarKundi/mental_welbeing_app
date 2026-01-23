import 'package:flutter/material.dart';

class AppColors {
  // Background Gradients
  static const Color deepOceanBlue = Color(0xFF0F172A);
  static const Color mutedPurple = Color(0xFF2E1065);

  static const LinearGradient mainBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepOceanBlue, mutedPurple],
  );

  // Glass Colors
  static Color primaryGlass = Colors.white.withOpacity(0.1);
  static Color borderGlass = Colors.white.withOpacity(0.3);

  // Accent Colors
  static const Color cyanAccent = Colors.cyan;
  static const Color tealAccent = Colors.teal;

  static const LinearGradient accentLiquidGradient = LinearGradient(
    colors: [cyanAccent, tealAccent],
  );

  // Mood Gradients
  static const LinearGradient happyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)], // Amber/Orange
  );

  static const LinearGradient calmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepOceanBlue, mutedPurple], // Default
  );

  static const LinearGradient sadGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF334155)], // Slate/BlueGrey
  );

  static const LinearGradient angryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF991B1B), Color(0xFF7F1D1D)], // Red
  );

  static const LinearGradient lovedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFFBE185D)], // Pink/Rose
  );

  static const LinearGradient tiredGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)], // Purple/Indigo
  );

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
}
