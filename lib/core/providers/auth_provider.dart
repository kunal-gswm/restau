import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'shared_prefs_provider.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

final authUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ?? Supabase.instance.client.auth.currentUser;
});

class AuthController extends Notifier<bool> {
  @override
  bool build() {
    return ref.read(sharedPrefsProvider).getBool('guest_mode') ?? false;
  }

  Future<void> setGuestMode(bool isGuest) async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool('guest_mode', isGuest);
    state = isGuest;
  }
}

final authControllerProvider = NotifierProvider<AuthController, bool>(() {
  return AuthController();
});
