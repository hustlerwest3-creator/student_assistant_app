// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// Date: May 2026

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static late final SupabaseClient client;

  // YOUR ACTUAL CREDENTIALS - REPLACED!
  static const String _supabaseUrl = 'https://oxuzivxoejiilerwyevk.supabase.co';
  static const String _anonKey =
      'sb_publishable_7GBZjdO6ykrnWIqA_iQsRw_5gkbL1Wf';

  static Future<void> init() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Supabase with your project's credentials
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _anonKey,
    );
    client = Supabase.instance.client;
    debugPrint('✅ Supabase initialized successfully!');
  }

  static Future<AuthResponse> signUp(
    String email,
    String password,
    Map<String, dynamic> userData,
  ) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: userData,
    );
  }

  static Future<Session?> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.session;
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;
}
