import 'package:get/get.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_mentor_model.dart';

class ChatController extends GetxController {
  final mentors = <ChatMentor>[].obs;
  final activeMentor = Rxn<ChatMentor>();
  final messages = <Message>[].obs;

  final _chatRepo = ChatRepository();

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

  Future<void> startChat(ChatMentor mentor) async {
    activeMentor.value = mentor;
    messages.clear();

    // Load History from Supabase
    try {
      final history = await _chatRepo.getMessages(mentor.id);
      if (history.isEmpty) {
        // Only add welcome message if no history exists
        final welcomeMsg = Message(
          text: mentor.welcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
        );
        messages.add(welcomeMsg);
        await _chatRepo.saveMessage(
          mentorId: mentor.id,
          text: mentor.welcomeMessage,
          isUser: false,
        );
      } else {
        for (final item in history) {
          messages.add(
            Message(
              text: item['message_text'],
              isUser: item['is_user'],
              timestamp: DateTime.parse(item['created_at']),
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat history.');
    }

    Get.toNamed('/chat-detail');
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final mentor = activeMentor.value;
    if (mentor == null) return;

    final userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    try {
      await _chatRepo.saveMessage(
        mentorId: mentor.id,
        text: text,
        isUser: true,
      );
    } catch (e) {
      print('Error saving message: $e');
    }

    // Simulate Personality-Driven AI response
    _simulateAIResponse(text);
  }

  void _simulateAIResponse(String userMessage) {
    final mentor = activeMentor.value;
    if (mentor == null) return;

    Future.delayed(const Duration(seconds: 1), () async {
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

      final aiMessage = Message(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);

      try {
        await _chatRepo.saveMessage(
          mentorId: mentor.id,
          text: response,
          isUser: false,
        );
      } catch (e) {
        print('Error saving AI response: $e');
      }
    });
  }
}
