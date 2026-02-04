import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../data/services/app_logger.dart';
import '../../data/constants/app_assets.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_mentor_model.dart';
import '../../data/services/gemini_service.dart';

class ChatController extends GetxController {
  final mentors = <ChatMentor>[].obs;
  final activeMentor = Rxn<ChatMentor>();
  final messages = <Message>[].obs;
  final isThinking = false.obs;
  final quickReplies = <String>[].obs;
  final isLoadingHistory = false.obs;

  final _chatRepo = ChatRepository();
  final _geminiService = GeminiService();

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
        avatarUrl: AppAssets.mentorSerene,
        welcomeMessage:
            'I\'m here to listen without judgment. How is your heart feeling today?',
      ),
      ChatMentor(
        id: '2',
        name: 'Atlas',
        trait: 'Logical',
        specialization: 'CBT & Strategy',
        personality: 'Practical, grounding, and solution-oriented.',
        avatarUrl: AppAssets.mentorAtlas,
        welcomeMessage:
            'Let\'s break down what\'s on your mind and find a practical path forward.',
      ),
      ChatMentor(
        id: '3',
        name: 'Nova',
        trait: 'Energizing',
        specialization: 'Motivation & Growth',
        personality: 'Inspiring, upbeat, and encouraging.',
        avatarUrl: AppAssets.mentorNova,
        welcomeMessage:
            'Ready to find your strength? Tell me what you want to achieve today!',
      ),
      ChatMentor(
        id: '4',
        name: 'Sage',
        trait: 'Wise',
        specialization: 'Mindfulness & Zen',
        personality: 'Calm, philosophical, and grounding.',
        avatarUrl: AppAssets.mentorSage,
        welcomeMessage:
            'Take a deep breath. Let us observe the present moment together.',
      ),
    ]);
  }

  Future<void> startChat(ChatMentor mentor) async {
    activeMentor.value = mentor;
    Get.toNamed('/chat-detail');
    _updateQuickReplies();

    messages.clear();
    isLoadingHistory.value = true;

    // Load History from Supabase in background
    try {
      final history = await _chatRepo.getMessages(mentor.id);
      if (history.isEmpty) {
        // Only add welcome message if no history exists
        final welcomeMsg = Message(
          text: mentor.welcomeMessage,
          isUser: false,
          timestamp: DateTime.now(),
        );
        messages.insert(0, welcomeMsg);
        await _chatRepo.saveMessage(
          mentorId: mentor.id,
          text: mentor.welcomeMessage,
          isUser: false,
        );
      } else {
        final List<Message> loadedMessages = history
            .map(
              (item) => Message(
                text: item['message_text'],
                isUser: item['is_user'],
                timestamp: DateTime.parse(item['created_at']),
              ),
            )
            .toList();
        messages.addAll(loadedMessages);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chat history.');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  void _updateQuickReplies() {
    final trait = activeMentor.value?.trait ?? '';
    quickReplies.clear();
    if (trait == 'Empathetic') {
      quickReplies.addAll([
        "I'm feeling overwhelmed",
        "Help me process an emotion",
        "Just want to vent",
      ]);
    } else if (trait == 'Wise') {
      quickReplies.addAll([
        "I need perspective",
        "Teach me a mindfulness tip",
        "Deep breath exercise",
      ]);
    } else if (trait == 'Logical') {
      quickReplies.addAll([
        "Show me a framework",
        "Let's solve a problem",
        "What's the next step?",
      ]);
    } else {
      quickReplies.addAll([
        "Daily challenge",
        "Give me motivation",
        "Quick boost",
      ]);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    final mentor = activeMentor.value;
    if (mentor == null) return;

    // Add Haptic Feedback
    HapticFeedback.lightImpact();

    final userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.insert(0, userMessage);

    try {
      await _chatRepo.saveMessage(
        mentorId: mentor.id,
        text: text,
        isUser: true,
      );
    } catch (e) {
      AppLogger.error('Failed to save message', e);
    }

    // Real Gemini AI response
    isThinking.value = true;
    _getAIResponse(text);
  }

  Future<void> _getAIResponse(String userMessage) async {
    final mentor = activeMentor.value;
    if (mentor == null) return;

    // 1. Prepare Personality Prompt
    final systemPrompt =
        """
You are ${mentor.name}, a specialized AI Counselor for a Mental Wellbeing app.
Your trait is ${mentor.trait} and your specialization is ${mentor.specialization}.
Your personality is ${mentor.personality}.

CONSTRAINTS:
- Keep your responses concise (2-4 sentences max).
- Use a warm, professional, and supportive tone.
- Never give medical prescriptions.
- Always stay in character as ${mentor.name}.
""";

    // 2. Prepare History (24-hour window)
    final now = DateTime.now();
    final oneDayAgo = now.subtract(const Duration(hours: 24));

    final recentMessages = messages
        .where((m) => m.timestamp.isAfter(oneDayAgo))
        .take(16)
        .toList();

    final chronoMessages = recentMessages.reversed.toList();

    final history = <Content>[];
    for (int i = 0; i < chronoMessages.length - 1; i++) {
      final m = chronoMessages[i];
      // Gemini expects history to start with a User message.
      // If our first message is a Mentor welcome, we skip it for the API history
      // but the user still sees it in the UI.
      if (i == 0 && !m.isUser) continue;

      if (m.isUser) {
        history.add(Content.text(m.text));
      } else {
        history.add(Content.model([TextPart(m.text)]));
      }
    }

    // 3. Get Response from Gemini
    try {
      final responseText = (await _geminiService.generateResponse(
        systemPrompt: systemPrompt,
        history: history,
        userMessage: userMessage,
      )).trim();

      isThinking.value = false;

      // Add haptic feedback on response arrival
      HapticFeedback.lightImpact();

      final aiMessage = Message(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.insert(0, aiMessage);

      await _chatRepo.saveMessage(
        mentorId: mentor.id,
        text: responseText,
        isUser: false,
      );
    } catch (e) {
      isThinking.value = false;
      Get.snackbar('Error', 'The counselor is resting. Please try again soon.');
    }
  }
}
