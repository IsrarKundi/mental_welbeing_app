import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/app_logger.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../progress/progress_controller.dart';

enum BreathingPhase { inhale, hold, exhale, rest }

class BreathingController extends GetxController {
  final _activityRepo = ActivityRepository();

  final currentPhase = BreathingPhase.inhale.obs;
  final isPlaying = false.obs;
  final currentCycle = 0.obs;

  // Reactive settings
  final totalCycles = 4.obs;
  final inhaleDuration = 4.obs;
  final holdDuration = 4.obs;
  final exhaleDuration = 6.obs;
  final restDuration = 2.obs;

  Timer? _phaseTimer;
  VoidCallback? onSessionComplete;

  String get phaseText {
    // ... same
    switch (currentPhase.value) {
      case BreathingPhase.inhale:
        return 'Breathe In';
      case BreathingPhase.hold:
        return 'Hold';
      case BreathingPhase.exhale:
        return 'Breathe Out';
      case BreathingPhase.rest:
        return 'Rest';
    }
  }

  String get phaseSubtext {
    switch (currentPhase.value) {
      case BreathingPhase.inhale:
        return 'Fill your lungs slowly';
      case BreathingPhase.hold:
        return 'Keep the air in';
      case BreathingPhase.exhale:
        return 'Release slowly';
      case BreathingPhase.rest:
        return 'Pause and relax';
    }
  }

  int get currentPhaseDuration {
    switch (currentPhase.value) {
      case BreathingPhase.inhale:
        return inhaleDuration.value;
      case BreathingPhase.hold:
        return holdDuration.value;
      case BreathingPhase.exhale:
        return exhaleDuration.value;
      case BreathingPhase.rest:
        return restDuration.value;
    }
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      _startPhaseTimer();
    } else {
      _stopPhaseTimer();
    }
  }

  void _startPhaseTimer() {
    _phaseTimer?.cancel();
    _phaseTimer = Timer(Duration(seconds: currentPhaseDuration), () {
      if (isPlaying.value) {
        nextPhase();
        if (isPlaying.value) {
          _startPhaseTimer();
        }
      }
    });
  }

  void _stopPhaseTimer() {
    _phaseTimer?.cancel();
    _phaseTimer = null;
  }

  void resetSession() {
    _stopPhaseTimer();
    isPlaying.value = false;
    currentPhase.value = BreathingPhase.inhale;
    currentCycle.value = 0;
  }

  void nextPhase() {
    switch (currentPhase.value) {
      case BreathingPhase.inhale:
        currentPhase.value = BreathingPhase.hold;
        break;
      case BreathingPhase.hold:
        currentPhase.value = BreathingPhase.exhale;
        break;
      case BreathingPhase.exhale:
        currentPhase.value = BreathingPhase.rest;
        break;
      case BreathingPhase.rest:
        currentPhase.value = BreathingPhase.inhale;
        currentCycle.value++;
        if (currentCycle.value >= totalCycles.value) {
          isPlaying.value = false;
          _stopPhaseTimer();
          if (onSessionComplete != null) {
            onSessionComplete!();
          }
        }
        break;
    }
  }

  Future<void> logSession() async {
    try {
      // Calculate actual duration based on cycles and durations
      final totalSecondsPerCycle =
          inhaleDuration.value +
          holdDuration.value +
          exhaleDuration.value +
          restDuration.value;
      final totalMinutes = (totalSecondsPerCycle * totalCycles.value) / 60;

      await _activityRepo.logActivity(
        activityType: 'breathing',
        durationMinutes: totalMinutes.ceil(),
      );

      // Refresh stats
      if (Get.isRegistered<ProgressController>()) {
        Get.find<ProgressController>().onInit();
      }
    } catch (e) {
      AppLogger.error('Failed to log breathing session', e);
    }
  }

  // Settings methods
  void updateInhaleDuration(int value) {
    inhaleDuration.value = value.clamp(2, 10);
  }

  void updateHoldDuration(int value) {
    holdDuration.value = value.clamp(1, 10);
  }

  void updateExhaleDuration(int value) {
    exhaleDuration.value = value.clamp(2, 12);
  }

  void updateRestDuration(int value) {
    restDuration.value = value.clamp(1, 6);
  }

  void updateTotalCycles(int value) {
    totalCycles.value = value.clamp(1, 10);
  }

  @override
  void onClose() {
    _stopPhaseTimer();
    super.onClose();
  }
}
