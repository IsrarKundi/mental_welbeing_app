import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/services/app_logger.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../progress/progress_controller.dart';

class MindfulWalkController extends GetxController {
  final _activityRepo = ActivityRepository();

  final isWalking = false.obs;
  final elapsedSeconds = 0.obs;
  final selectedEnvironment = 0.obs;
  Timer? _timer;
  VoidCallback? onSessionComplete;

  final environments = [
    WalkEnvironment(
      name: 'Forest Path',
      icon: '🌲',
      color: 0xFF22C55E,
      tip: 'Notice the patterns of leaves and bark',
    ),
    WalkEnvironment(
      name: 'Beach Walk',
      icon: '🏖️',
      color: 0xFF0EA5E9,
      tip: 'Feel the sand between your toes',
    ),
    WalkEnvironment(
      name: 'City Park',
      icon: '🌳',
      color: 0xFF84CC16,
      tip: 'Observe the people and nature coexisting',
    ),
    WalkEnvironment(
      name: 'Mountain Trail',
      icon: '⛰️',
      color: 0xFF8B5CF6,
      tip: 'Take in the vastness of the landscape',
    ),
  ];

  final mindfulnessPrompts = [
    'Focus on your breathing with each step',
    'Notice the sensation of your feet touching the ground',
    'Listen to the sounds around you',
    'Feel the air on your skin',
    'Observe the colors in your surroundings',
    'Pay attention to the rhythm of your walk',
  ];

  int get currentPromptIndex =>
      (elapsedSeconds.value ~/ 30) % mindfulnessPrompts.length;
  String get currentPrompt => mindfulnessPrompts[currentPromptIndex];

  double get progress => (elapsedSeconds.value % 60) / 60.0;

  String get formattedTime {
    final minutes = (elapsedSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void selectEnvironment(int index) {
    if (index != selectedEnvironment.value) {
      HapticFeedback.selectionClick();
      selectedEnvironment.value = index;
    }
  }

  void toggleWalking() {
    HapticFeedback.mediumImpact();
    isWalking.value = !isWalking.value;
    if (isWalking.value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    HapticFeedback.lightImpact();
    _stopTimer();
    isWalking.value = false;
    elapsedSeconds.value = 0;
  }

  void stopWalkingManually() {
    if (elapsedSeconds.value > 0) {
      _stopTimer();
      isWalking.value = false;
      if (onSessionComplete != null) {
        onSessionComplete!();
      }
    } else {
      reset();
    }
  }

  Future<void> logSession() async {
    try {
      if (elapsedSeconds.value < 10) return; // Don't log very short sessions

      await _activityRepo.logActivity(
        activityType: 'mindfulWalk',
        durationMinutes: (elapsedSeconds.value / 60).ceil(),
      );

      // Refresh stats
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().onInit();
      }
    } catch (e) {
      AppLogger.error('Failed to log mindful walk session', e);
    }
  }

  WalkEnvironment get currentEnvironment =>
      environments[selectedEnvironment.value];

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}

class WalkEnvironment {
  final String name;
  final String icon;
  final int color;
  final String tip;

  WalkEnvironment({
    required this.name,
    required this.icon,
    required this.color,
    required this.tip,
  });
}
