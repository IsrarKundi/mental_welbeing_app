import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;

  Future<SupabaseService> init() async {
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
    client = Supabase.instance.client;
    return this;
  }

  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  bool get isAuthenticated => currentUser != null;

  // Helper stream for Auth changes
  Stream<AuthState> get onAuthStateChange => client.auth.onAuthStateChange;

  void listenToAuthChanges() {
    onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Get.offAllNamed('/main');
      } else if (event == AuthChangeEvent.signedOut) {
        Get.offAllNamed('/login');
      }
    });
  }
}
