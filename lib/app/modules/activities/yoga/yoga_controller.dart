import 'package:get/get.dart';

class YogaController extends GetxController {
  final selectedPoseIndex = 0.obs;
  final isInPose = false.obs;
  final elapsedSeconds = 0.obs;

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

  void selectPose(int index) {
    selectedPoseIndex.value = index;
    elapsedSeconds.value = 0;
    isInPose.value = false;
  }

  void togglePose() {
    isInPose.value = !isInPose.value;
  }

  void nextPose() {
    if (selectedPoseIndex.value < poses.length - 1) {
      selectPose(selectedPoseIndex.value + 1);
    }
  }

  void previousPose() {
    if (selectedPoseIndex.value > 0) {
      selectPose(selectedPoseIndex.value - 1);
    }
  }

  void reset() {
    isInPose.value = false;
    elapsedSeconds.value = 0;
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
