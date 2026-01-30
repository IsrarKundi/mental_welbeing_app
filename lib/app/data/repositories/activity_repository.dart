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

    // Check if already performed today (calendar day)
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();

    final existing = await _supabase
        .from('activity_logs')
        .select()
        .eq('user_id', user.id)
        .eq('activity_type', activityType)
        .gte('created_at', todayStart);

    if ((existing as List).isNotEmpty) {
      print('Activity $activityType already logged today. Skipping.');
      return;
    }

    await _supabase.from('activity_logs').insert({
      'user_id': user.id,
      'activity_type': activityType,
      'duration_minutes': durationMinutes,
    });
  }

  Future<List<ActivityLog>> getActivities() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('activity_logs')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ActivityLog.fromJson(json))
        .toList();
  }
}
