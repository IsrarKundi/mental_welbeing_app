import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mood_entry_model.dart';
import '../services/supabase_service.dart';
import 'package:get/get.dart';

class MoodRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<List<MoodEntry>> getMoods() async {
    final response = await _supabase
        .from('mood_entries')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => MoodEntry.fromJson(json)).toList();
  }

  Future<void> logMood({
    required String emoji,
    required String label,
    required int color,
    String? note,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _supabase.from('mood_entries').insert({
      'user_id': user.id,
      'emoji': emoji,
      'label': label,
      'color': color.toSigned(32), // Convert to signed 32-bit for PostgreSQL
      'note': note,
    });
  }

  Future<void> deleteMood(int id) async {
    await _supabase.from('mood_entries').delete().match({'id': id});
  }

  Future<Map<String, int>> getMoodStats() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase.from('mood_entries').select('label');

    final stats = <String, int>{};
    for (final item in (response as List)) {
      final label = item['label'] as String;
      stats[label] = (stats[label] ?? 0) + 1;
    }
    return stats;
  }
}
