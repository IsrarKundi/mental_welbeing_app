import 'package:get/get.dart';

enum BreathingPhase { inhale, hold, exhale, rest }

class BreathingController extends GetxController {
  final currentPhase = BreathingPhase.inhale.obs;
  final isPlaying = false.obs;
  final currentCycle = 0.obs;
  final totalCycles = 4;

  // Phase durations in seconds
  final inhaleDuration = 4;
  final holdDuration = 4;
  final exhaleDuration = 6;
  final restDuration = 2;

  String get phaseText {
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
        return inhaleDuration;
      case BreathingPhase.hold:
        return holdDuration;
      case BreathingPhase.exhale:
        return exhaleDuration;
      case BreathingPhase.rest:
        return restDuration;
    }
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void resetSession() {
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
        if (currentCycle.value >= totalCycles) {
          isPlaying.value = false;
        }
        break;
    }
  }
}
