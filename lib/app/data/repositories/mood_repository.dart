import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'package:get/get.dart';

class MoodRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<List<Map<String, dynamic>>> getMoods() async {
    final response = await _supabase
        .from('mood_entries')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> logMood({
    required String emoji,
    required String label,
    required int color,
    String? note,
  }) async {
    await _supabase.from('mood_entries').insert({
      'emoji': emoji,
      'label': label,
      'color': color,
      'note': note,
    });
  }

  Future<void> deleteMood(int id) async {
    await _supabase.from('mood_entries').delete().match({'id': id});
  }
}
