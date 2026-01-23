import 'package:get/get.dart';

class MeditationController extends GetxController {
  final isPlaying = false.obs;
  final selectedDuration = 10.obs; // minutes
  final elapsedSeconds = 0.obs;

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
    selectedDuration.value = minutes;
    elapsedSeconds.value = 0;
  }

  void selectType(int index) {
    selectedTypeIndex.value = index;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void reset() {
    isPlaying.value = false;
    elapsedSeconds.value = 0;
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
