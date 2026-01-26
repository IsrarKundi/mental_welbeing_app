import 'package:get/get.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_mentor_model.dart';

class ChatController extends GetxController {
  final mentors = <ChatMentor>[].obs;
  final activeMentor = Rxn<ChatMentor>();
  final messages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMentors();
  }

  void _loadMentors() {
    mentors.addAll([
      ChatMentor(
        id: '1',
        name: 'Serene',
        trait: 'Empathetic',
        specialization: 'Emotional Support',
        personality: 'Gentle, patient, and deeply understanding.',
        avatarUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
        welcomeMessage:
            'I\'m here to listen without judgment. How is your heart feeling today?',
      ),
      ChatMentor(
        id: '2',
        name: 'Atlas',
        trait: 'Logical',
        specialization: 'CBT & Strategy',
        personality: 'Practical, grounding, and solution-oriented.',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
        welcomeMessage:
            'Let\'s break down what\'s on your mind and find a practical path forward.',
      ),
      ChatMentor(
        id: '3',
        name: 'Nova',
        trait: 'Energizing',
        specialization: 'Motivation & Growth',
        personality: 'Inspiring, upbeat, and encouraging.',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
        welcomeMessage:
            'Ready to find your strength? Tell me what you want to achieve today!',
      ),
      ChatMentor(
        id: '4',
        name: 'Sage',
        trait: 'Wise',
        specialization: 'Mindfulness & Zen',
        personality: 'Calm, philosophical, and grounding.',
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
        welcomeMessage:
            'Take a deep breath. Let us observe the present moment together.',
      ),
    ]);
  }

  void startChat(ChatMentor mentor) {
    activeMentor.value = mentor;
    messages.clear();
    messages.add(
      Message(
        text: mentor.welcomeMessage,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    Get.toNamed('/chat-detail');
  }

  void sendMessage(String text) {
    if (text.isEmpty) return;
    messages.add(Message(text: text, isUser: true, timestamp: DateTime.now()));

    // Simulate Personality-Driven AI response
    _simulateAIResponse(text);
  }

  void _simulateAIResponse(String userMessage) {
    final mentor = activeMentor.value;
    if (mentor == null) return;

    Future.delayed(const Duration(seconds: 1), () {
      String response = "I'm listening. Tell me more about that.";

      // Simple personality logic
      if (mentor.trait == 'Logical') {
        response =
            "I hear you. Dealing with this logically, what's one small step we can take?";
      } else if (mentor.trait == 'Empathetic') {
        response = "That sounds like a lot to carry. I'm right here with you.";
      } else if (mentor.trait == 'Energizing') {
        response =
            "You've got this! Every challenge is a chance to grow. What else?";
      } else if (mentor.trait == 'Wise') {
        response =
            "Observe that feeling. Where do you feel it in your body right now?";
      }

      messages.add(
        Message(text: response, isUser: false, timestamp: DateTime.now()),
      );
    });
  }
}
