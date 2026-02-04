import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/app_logger.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../progress/progress_controller.dart';

class MeditationController extends GetxController {
  final _activityRepo = ActivityRepository();

  final isPlaying = false.obs;
  final selectedDuration = 10.obs; // minutes
  final elapsedSeconds = 0.obs;
  final isSoundEnabled = true.obs; // Sound toggle state

  Timer? _timer;
  VoidCallback? onSessionComplete;

  /// Toggles ambient sound on/off for meditation sessions
  void toggleSound() {
    isSoundEnabled.value = !isSoundEnabled.value;
    // Future enhancement: integrate with audio player
  }

  final availableDurations = [5, 10, 15, 20, 30];

  final meditationTypes = [
    MeditationType(
      name: 'Focus',
      icon: '🎯',
      description: 'Clear your mind',
      color: 0xFF6366F1,
    ),
    MeditationType(
      name: 'Calm',
      icon: '🌊',
      description: 'Find inner peace',
      color: 0xFF14B8A6,
    ),
    MeditationType(
      name: 'Sleep',
      icon: '🌙',
      description: 'Prepare for rest',
      color: 0xFF8B5CF6,
    ),
    MeditationType(
      name: 'Anxiety',
      icon: '🍃',
      description: 'Release tension',
      color: 0xFF22C55E,
    ),
  ];

  final selectedTypeIndex = 0.obs;

  MeditationType get selectedType => meditationTypes[selectedTypeIndex.value];

  String get formattedTime {
    final totalSeconds = selectedDuration.value * 60;
    final remaining = totalSeconds - elapsedSeconds.value;
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progress {
    if (selectedDuration.value == 0) return 0;
    return elapsedSeconds.value / (selectedDuration.value * 60);
  }

  void selectDuration(int minutes) {
    if (isPlaying.value) return; // Don't allow changing during session
    selectedDuration.value = minutes;
    elapsedSeconds.value = 0;
  }

  void selectType(int index) {
    if (isPlaying.value) return; // Don't allow changing during session
    selectedTypeIndex.value = index;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final totalSeconds = selectedDuration.value * 60;
      if (elapsedSeconds.value >= totalSeconds) {
        // Meditation complete
        _stopTimer();
        isPlaying.value = false;
        if (onSessionComplete != null) {
          onSessionComplete!();
        }
      } else {
        elapsedSeconds.value++;
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _stopTimer();
    isPlaying.value = false;
    elapsedSeconds.value = 0;
  }

  Future<void> logSession() async {
    try {
      await _activityRepo.logActivity(
        activityType: 'meditation',
        durationMinutes: selectedDuration.value,
      );

      // Refresh stats
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().onInit();
      }
    } catch (e) {
      AppLogger.error('Failed to log meditation session', e);
    }
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}

class MeditationType {
  final String name;
  final String icon;
  final String description;
  final int color;

  MeditationType({
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
  });
}
