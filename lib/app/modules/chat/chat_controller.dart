import 'package:get/get.dart';
import '../../data/models/message_model.dart';

class ChatController extends GetxController {
  final messages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyMessages();
  }

  void loadDummyMessages() {
    messages.addAll([
      Message(
        text: 'Hi there! I am MindWell. How are you feeling today?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        text: "I'm feeling a bit anxious.",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      Message(
        text: 'I understand. Breathing usually helps. Shall we try?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
    ]);
  }

  void sendMessage(String text) {
    if (text.isEmpty) return;
    messages.add(Message(text: text, isUser: true, timestamp: DateTime.now()));
    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      messages.add(
        Message(
          text: "I'm listening. Tell me more.",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }
}
