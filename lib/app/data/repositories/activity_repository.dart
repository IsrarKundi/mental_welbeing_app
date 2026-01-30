import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/activity_log_model.dart';
import 'package:get/get.dart';

class ActivityRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<void> logActivity({
    required String activityType,
    required int durationMinutes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Use client's UTC time for global timezone support
    final nowUtc = DateTime.now().toUtc();
    final todayStartUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);

    // Check if already performed today (using UTC)
    final existing = await _supabase
        .from('activity_logs')
        .select()
        .eq('user_id', user.id)
        .eq('activity_type', activityType)
        .gte('created_at', todayStartUtc.toIso8601String());

    if ((existing as List).isNotEmpty) {
      print('Activity $activityType already logged today. Skipping.');
      return;
    }

    // Send client's UTC timestamp instead of relying on server clock
    await _supabase.from('activity_logs').insert({
      'user_id': user.id,
      'activity_type': activityType,
      'duration_minutes': durationMinutes,
      'created_at': nowUtc.toIso8601String(),
    });
  }

  Future<List<ActivityLog>> getActivities() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('activity_logs')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ActivityLog.fromJson(json))
        .toList();
  }
}
