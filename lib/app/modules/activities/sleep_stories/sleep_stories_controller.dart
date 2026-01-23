import 'package:get/get.dart';

class SleepStoriesController extends GetxController {
  final selectedStoryIndex = (-1).obs;
  final isPlaying = false.obs;

  final stories = [
    SleepStory(
      title: 'Forest Dreams',
      narrator: 'Sarah Mitchell',
      duration: '25 min',
      imageUrl:
          'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=500&q=60',
      description: 'A peaceful journey through an enchanted forest',
      color: 0xFF22C55E,
    ),
    SleepStory(
      title: 'Ocean Waves',
      narrator: 'David Chen',
      duration: '20 min',
      imageUrl:
          'https://images.unsplash.com/photo-1505142468610-359e7d316be0?auto=format&fit=crop&w=500&q=60',
      description: 'Let the rhythm of waves carry you to sleep',
      color: 0xFF0EA5E9,
    ),
    SleepStory(
      title: 'Mountain Retreat',
      narrator: 'Emma Wilson',
      duration: '30 min',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=500&q=60',
      description: 'A cozy cabin nestled in snowy peaks',
      color: 0xFF8B5CF6,
    ),
    SleepStory(
      title: 'Starlit Garden',
      narrator: 'James Porter',
      duration: '22 min',
      imageUrl:
          'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?auto=format&fit=crop&w=500&q=60',
      description: 'Wander through a magical midnight garden',
      color: 0xFFF59E0B,
    ),
    SleepStory(
      title: 'Rainy Evening',
      narrator: 'Lily Anderson',
      duration: '18 min',
      imageUrl:
          'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?auto=format&fit=crop&w=500&q=60',
      description: 'The soothing sounds of rain on windows',
      color: 0xFF6366F1,
    ),
  ];

  void selectStory(int index) {
    selectedStoryIndex.value = index;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  SleepStory? get selectedStory {
    if (selectedStoryIndex.value < 0) return null;
    return stories[selectedStoryIndex.value];
  }
}

class SleepStory {
  final String title;
  final String narrator;
  final String duration;
  final String imageUrl;
  final String description;
  final int color;

  SleepStory({
    required this.title,
    required this.narrator,
    required this.duration,
    required this.imageUrl,
    required this.description,
    required this.color,
  });
}
