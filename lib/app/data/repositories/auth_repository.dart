import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'package:get/get.dart';

export 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, User;

class AuthRepository {
  final SupabaseClient _supabase = Get.find<SupabaseService>().client;

  Future<User?> signInAnonymously() async {
    final response = await _supabase.auth.signInAnonymously();
    return response.user;
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _supabase.auth.currentUser;
}
