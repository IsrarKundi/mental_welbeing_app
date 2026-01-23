import 'package:get/get.dart';

class MindfulWalkController extends GetxController {
  final isWalking = false.obs;
  final elapsedSeconds = 0.obs;
  final selectedEnvironment = 0.obs;

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

  String get formattedTime {
    final minutes = (elapsedSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void selectEnvironment(int index) {
    selectedEnvironment.value = index;
  }

  void toggleWalking() {
    isWalking.value = !isWalking.value;
  }

  void reset() {
    isWalking.value = false;
    elapsedSeconds.value = 0;
  }

  WalkEnvironment get currentEnvironment =>
      environments[selectedEnvironment.value];
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
