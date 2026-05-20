import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Application {
  final String id;
  final String userId;
  final String status;
  final bool meetsRequirements;
  final DateTime createdAt;
  final DateTime updatedAt;

  Application({
    required this.id,
    required this.userId,
    required this.status,
    required this.meetsRequirements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'] ?? 'pending',
      meetsRequirements: json['meets_requirements'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ModuleApplication {
  final String id;
  final String applicationId;
  final String academicLevel;
  final String moduleName;
  final String? additionalNotes;

  ModuleApplication({
    required this.id,
    required this.applicationId,
    required this.academicLevel,
    required this.moduleName,
    this.additionalNotes,
  });

  factory ModuleApplication.fromJson(Map<String, dynamic> json) {
    return ModuleApplication(
      id: json['id'],
      applicationId: json['application_id'],
      academicLevel: json['academic_level'],
      moduleName: json['module_name'],
      additionalNotes: json['additional_notes'],
    );
  }
}

class StudentViewModel extends ChangeNotifier {
  List<Application> _applications = [];
  List<ModuleApplication> _moduleApps = [];
  bool _isLoading = false;
  String? _error;

  List<Application> get applications => _applications;
  List<ModuleApplication> get moduleApps => _moduleApps;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final response = await Supabase.instance.client
          .from('applications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _applications =
          response.map((json) => Application.fromJson(json)).toList();

      _moduleApps.clear();
      for (var app in _applications) {
        final modulesRes = await Supabase.instance.client
            .from('module_applications')
            .select()
            .eq('application_id', app.id);
        _moduleApps
            .addAll(modulesRes.map((json) => ModuleApplication.fromJson(json)));
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createApplication({
    required List<Map<String, dynamic>> modulesData,
    required bool meetsRequirements,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final appRes = await Supabase.instance.client
          .from('applications')
          .insert({
            'user_id': userId,
            'status': 'pending',
            'meets_requirements': meetsRequirements,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final appId = appRes['id'];

      for (var mod in modulesData) {
        await Supabase.instance.client.from('module_applications').insert({
          'application_id': appId,
          'academic_level': mod['academicLevel'],
          'module_name': mod['moduleName'],
          'additional_notes': mod['additionalNotes'] ?? '',
        });
      }

      await loadApplications();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteApplication(
      String applicationId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client
          .from('applications')
          .delete()
          .eq('id', applicationId);
      await loadApplications();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
