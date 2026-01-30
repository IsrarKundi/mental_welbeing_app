import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'package:get/get.dart';

class ChatRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<List<Map<String, dynamic>>> getMessages(String mentorId) async {
    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('mentor_id', mentorId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> saveMessage({
    required String mentorId,
    required String text,
    required bool isUser,
  }) async {
    await _supabase.from('chat_messages').insert({
      'mentor_id': mentorId,
      'message_text': text,
      'is_user': isUser,
    });
  }

  Future<void> clearHistory(String mentorId) async {
    await _supabase.from('chat_messages').delete().eq('mentor_id', mentorId);
  }
}
