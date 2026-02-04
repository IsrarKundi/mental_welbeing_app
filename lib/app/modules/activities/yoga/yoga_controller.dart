import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/services/app_logger.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../progress/progress_controller.dart';

class YogaController extends GetxController {
  final _activityRepo = ActivityRepository();

  final selectedPoseIndex = 0.obs;
  final isInPose = false.obs;
  final elapsedSeconds = 0.obs;
  Timer? _timer;
  VoidCallback? onSessionComplete;

  final poses = [
    YogaPose(
      name: 'Mountain Pose',
      sanskritName: 'Tadasana',
      duration: 60,
      difficulty: 'Beginner',
      icon: '🧘',
      instructions:
          'Stand tall with feet together, arms at sides. Ground through feet, engage legs, lengthen spine.',
      color: 0xFF22C55E,
    ),
    YogaPose(
      name: 'Downward Dog',
      sanskritName: 'Adho Mukha Svanasana',
      duration: 45,
      difficulty: 'Beginner',
      icon: '🐕',
      instructions:
          'Form an inverted V-shape. Press palms and heels down, lift hips high.',
      color: 0xFF0EA5E9,
    ),
    YogaPose(
      name: 'Warrior I',
      sanskritName: 'Virabhadrasana I',
      duration: 45,
      difficulty: 'Intermediate',
      icon: '⚔️',
      instructions: 'Lunge forward, back foot at 45°. Arms overhead, gaze up.',
      color: 0xFFF59E0B,
    ),
    YogaPose(
      name: 'Tree Pose',
      sanskritName: 'Vrksasana',
      duration: 60,
      difficulty: 'Beginner',
      icon: '🌳',
      instructions:
          'Stand on one leg, other foot on inner thigh. Hands at heart or overhead.',
      color: 0xFF84CC16,
    ),
    YogaPose(
      name: 'Child\'s Pose',
      sanskritName: 'Balasana',
      duration: 90,
      difficulty: 'Beginner',
      icon: '🧒',
      instructions:
          'Kneel and fold forward, arms extended or at sides. Rest forehead on mat.',
      color: 0xFF8B5CF6,
    ),
    YogaPose(
      name: 'Cobra Pose',
      sanskritName: 'Bhujangasana',
      duration: 30,
      difficulty: 'Beginner',
      icon: '🐍',
      instructions:
          'Lie face down, press palms to lift chest. Keep hips grounded.',
      color: 0xFFEC4899,
    ),
  ];

  YogaPose get currentPose => poses[selectedPoseIndex.value];

  String get formattedTime {
    final remaining = currentPose.duration - elapsedSeconds.value;
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress {
    return elapsedSeconds.value / currentPose.duration;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void selectPose(int index) {
    if (selectedPoseIndex.value == index) return;
    HapticFeedback.selectionClick();
    _stopTimer();
    selectedPoseIndex.value = index;
    elapsedSeconds.value = 0;
    isInPose.value = false;
  }

  void togglePose() {
    HapticFeedback.mediumImpact();
    isInPose.value = !isInPose.value;
    if (isInPose.value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedSeconds.value < currentPose.duration) {
        elapsedSeconds.value++;
      } else {
        _stopTimer();
        isInPose.value = false;
        HapticFeedback.heavyImpact();
        _moveToNextAutomatically();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _moveToNextAutomatically() {
    if (selectedPoseIndex.value < poses.length - 1) {
      Future.delayed(const Duration(seconds: 2), () {
        nextPose();
      });
    } else {
      // All poses complete
      if (onSessionComplete != null) {
        onSessionComplete!();
      }
    }
  }

  void nextPose() {
    if (selectedPoseIndex.value < poses.length - 1) {
      HapticFeedback.lightImpact();
      selectPose(selectedPoseIndex.value + 1);
    }
  }

  void previousPose() {
    if (selectedPoseIndex.value > 0) {
      HapticFeedback.lightImpact();
      selectPose(selectedPoseIndex.value - 1);
    }
  }

  void reset() {
    HapticFeedback.lightImpact();
    _stopTimer();
    isInPose.value = false;
    elapsedSeconds.value = 0;
  }

  Future<void> logSession() async {
    try {
      // Calculate total duration roughly
      final totalMinutes =
          poses.fold<int>(0, (sum, pose) => sum + pose.duration) ~/ 60;

      await _activityRepo.logActivity(
        activityType: 'yoga',
        durationMinutes: totalMinutes,
      );

      // Refresh stats
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().onInit();
      }
    } catch (e) {
      AppLogger.error('Failed to log yoga session', e);
    }
  }
}

class YogaPose {
  final String name;
  final String sanskritName;
  final int duration;
  final String difficulty;
  final String icon;
  final String instructions;
  final int color;

  YogaPose({
    required this.name,
    required this.sanskritName,
    required this.duration,
    required this.difficulty,
    required this.icon,
    required this.instructions,
    required this.color,
  });
}
