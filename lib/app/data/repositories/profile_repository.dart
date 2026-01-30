import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_profile_model.dart';
import 'package:get/get.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<UserProfile> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserProfile.fromJson(response);
  }

  Future<void> updateProfile({String? fullName, String? avatarUrl}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _supabase
        .from('profiles')
        .update({
          if (fullName != null) 'full_name': fullName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id);
  }
}
