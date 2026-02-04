import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'app_logger.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      requestOptions: const RequestOptions(apiVersion: 'v1'),
    );
  }

  Future<String> generateResponse({
    required String systemPrompt,
    required List<Content> history,
    required String userMessage,
  }) async {
    try {
      final chat = _model.startChat(history: history);

      // Inject system prompt as a user message at the very beginning if it's a new chat
      // or as a context instruction. For simplicity and robustness with chat history,
      // we'll combine it with the first message or send it separately if required.
      // However, the best way with GenerativeModel is often pre-pending to the prompt
      // or using the specialized SystemInstruction (if supported in the SDK version).

      final content = Content.text('$systemPrompt\n\nUser: $userMessage');
      final response = await chat.sendMessage(content);

      return response.text ?? "I'm sorry, I couldn't process that.";
    } catch (e) {
      AppLogger.error('Gemini API failed', e);
      return "I'm having a bit of trouble connecting right now. Let's try again in a moment.";
    }
  }
}
