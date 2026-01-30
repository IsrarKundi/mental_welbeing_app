import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mood_entry_model.dart';
import '../services/supabase_service.dart';
import 'package:get/get.dart';

class MoodRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<List<MoodEntry>> getMoods() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('mood_entries')
        .select()
        .eq('user_id', user.id)
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

    // Use client's UTC time for global timezone support
    final nowUtc = DateTime.now().toUtc();
    final startOfDayUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final endOfDayUtc = startOfDayUtc.add(const Duration(days: 1));

    // Check if a mood entry exists for today (using UTC)
    final existingEntries = await _supabase
        .from('mood_entries')
        .select('id')
        .eq('user_id', user.id)
        .gte('created_at', startOfDayUtc.toIso8601String())
        .lt('created_at', endOfDayUtc.toIso8601String())
        .limit(1);

    if ((existingEntries as List).isNotEmpty) {
      // Update existing entry for today
      final existingId = existingEntries.first['id'];
      await _supabase
          .from('mood_entries')
          .update({
            'emoji': emoji,
            'label': label,
            'color': color.toSigned(32),
            'note': note,
            'created_at': nowUtc.toIso8601String(),
          })
          .eq('id', existingId);
    } else {
      // Insert new entry with client's UTC timestamp
      await _supabase.from('mood_entries').insert({
        'user_id': user.id,
        'emoji': emoji,
        'label': label,
        'color': color.toSigned(32),
        'note': note,
        'created_at': nowUtc.toIso8601String(),
      });
    }
  }

  Future<void> deleteMood(int id) async {
    await _supabase.from('mood_entries').delete().match({'id': id});
  }

  Future<Map<String, int>> getMoodStats() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('mood_entries')
        .select('label')
        .eq('user_id', user.id);

    final stats = <String, int>{};
    for (final item in (response as List)) {
      final label = item['label'] as String;
      stats[label] = (stats[label] ?? 0) + 1;
    }
    return stats;
  }
}
