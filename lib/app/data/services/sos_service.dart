import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import 'app_logger.dart';

/// Service for handling SOS/crisis support functionality.
///
/// Provides quick access to crisis resources for users who need
/// immediate emotional support or emergency assistance.
class SOSService {
  SOSService._();

  // Crisis hotlines - US-based, can be localized
  static const String _crisisHotline =
      'tel:988'; // 988 Suicide & Crisis Lifeline
  static const String _crisisText = 'sms:741741'; // Crisis Text Line

  /// Shows the SOS help dialog with crisis resources
  static Future<void> showSOSDialog() async {
    HapticFeedback.heavyImpact();

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              const Icon(Icons.favorite, color: Color(0xFFEC4899), size: 48),
              const SizedBox(height: 16),
              const Text(
                'You\'re Not Alone',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'re here to help. Choose how you\'d like to connect:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Crisis Hotline Button
              _SOSOptionButton(
                icon: Icons.call,
                label: 'Call 988 Crisis Lifeline',
                sublabel: '24/7 Free & Confidential',
                color: const Color(0xFF22C55E),
                onTap: () => callCrisisHotline(),
              ),
              const SizedBox(height: 12),

              // Text Button
              _SOSOptionButton(
                icon: Icons.message,
                label: 'Text HOME to 741741',
                sublabel: 'Crisis Text Line',
                color: const Color(0xFF3B82F6),
                onTap: () => textCrisisLine(),
              ),
              const SizedBox(height: 12),

              // Breathing Exercise Button
              _SOSOptionButton(
                icon: Icons.air,
                label: 'Start Breathing Exercise',
                sublabel: 'Calm down in 2 minutes',
                color: AppColors.cyanAccent,
                onTap: () {
                  Get.back();
                  Get.toNamed('/breathing');
                },
              ),
              const SizedBox(height: 20),

              // Close button
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'I\'m okay for now',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  /// Launches phone dialer with crisis hotline number
  static Future<void> callCrisisHotline() async {
    try {
      final uri = Uri.parse(_crisisHotline);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar(
          'Unable to Call',
          'Please dial 988 manually for crisis support.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppLogger.error('Failed to launch crisis hotline', e);
    }
  }

  /// Launches SMS app with crisis text line
  static Future<void> textCrisisLine() async {
    try {
      final uri = Uri.parse(_crisisText);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar(
          'Unable to Text',
          'Please text HOME to 741741 manually.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppLogger.error('Failed to launch crisis text line', e);
    }
  }
}

/// Internal widget for SOS dialog options
class _SOSOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _SOSOptionButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
