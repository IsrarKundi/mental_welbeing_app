import 'package:get/get.dart';

class ResourcesController extends GetxController {
  final selectedCategory = 0.obs;

  final categories = ['All', 'Articles', 'Videos', 'Podcasts'];

  final articles = [
    Resource(
      title: 'Understanding Anxiety',
      description: 'Learn the science behind anxiety and how to manage it',
      imageUrl:
          'https://images.unsplash.com/photo-1474418397713-7ede21d49118?auto=format&fit=crop&w=500&q=60',
      type: 'Article',
      readTime: '5 min read',
      color: 0xFF6366F1,
    ),
    Resource(
      title: 'The Power of Gratitude',
      description: 'How daily gratitude can transform your mental health',
      imageUrl:
          'https://images.unsplash.com/photo-1506784365847-bbad939e9335?auto=format&fit=crop&w=500&q=60',
      type: 'Article',
      readTime: '4 min read',
      color: 0xFFF59E0B,
    ),
    Resource(
      title: 'Sleep Better Tonight',
      description: 'Expert tips for improving your sleep quality',
      imageUrl:
          'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?auto=format&fit=crop&w=500&q=60',
      type: 'Article',
      readTime: '6 min read',
      color: 0xFF8B5CF6,
    ),
    Resource(
      title: 'Mindfulness for Beginners',
      description: 'Start your mindfulness journey with these simple practices',
      imageUrl:
          'https://images.unsplash.com/photo-1508672019048-805c876b67e2?auto=format&fit=crop&w=500&q=60',
      type: 'Video',
      readTime: '10 min',
      color: 0xFF22C55E,
    ),
    Resource(
      title: 'Dealing with Stress',
      description: 'Practical techniques to reduce daily stress',
      imageUrl:
          'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&w=500&q=60',
      type: 'Podcast',
      readTime: '25 min',
      color: 0xFFEC4899,
    ),
  ];

  final quickTips = [
    QuickTip(icon: '💧', tip: 'Stay hydrated - drink 8 glasses of water'),
    QuickTip(icon: '🚶', tip: 'Take a 10-minute walk outside'),
    QuickTip(icon: '📱', tip: 'Put your phone away 1 hour before bed'),
    QuickTip(icon: '🌿', tip: 'Practice deep breathing for 2 minutes'),
    QuickTip(icon: '☀️', tip: 'Get sunlight exposure in the morning'),
  ];

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  List<Resource> get filteredResources {
    if (selectedCategory.value == 0) return articles;
    final category = categories[selectedCategory.value];
    return articles
        .where((r) => r.type == category.substring(0, category.length - 1))
        .toList();
  }
}

class Resource {
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final String readTime;
  final int color;

  Resource({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.readTime,
    required this.color,
  });
}

class QuickTip {
  final String icon;
  final String tip;

  QuickTip({required this.icon, required this.tip});
}
