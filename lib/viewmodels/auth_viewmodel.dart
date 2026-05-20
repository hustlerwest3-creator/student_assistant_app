import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _role;
  String? get role => _role;

  Future<bool> register(
      String email, String password, String fullName, int yearOfStudy) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'year_of_study': yearOfStudy,
          'role': 'student',
        },
      );

      if (response.user != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': response.user!.id,
          'full_name': fullName,
          'year_of_study': yearOfStudy,
          'role': 'student',
        });
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Registration failed');
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', response.user!.id)
            .maybeSingle();

        _role = profile != null ? profile['role'] : 'student';
        _isLoading = false;
        notifyListeners();
        return true;
      }
      throw Exception('Invalid credentials');
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _role = null;
    notifyListeners();
  }
}
