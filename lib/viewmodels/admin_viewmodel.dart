// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// Date: May 2026

import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';
import '../models/application.dart';
import '../models/user.dart';
import '../models/module_application.dart';
import '../config/constants.dart';

class AdminViewModel extends ChangeNotifier {
  List<Application> _allApps = [];
  List<ModuleApplication> _allModuleApps = [];
  List<UserProfile> _applicants = [];
  bool _isLoading = false;
  String? _error;

  List<Application> get allApps => _allApps;
  List<ModuleApplication> get allModuleApps => _allModuleApps;
  List<UserProfile> get applicants => _applicants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final appsRes =
          await SupabaseService.client.from('applications').select();
      _allApps =
          appsRes.map<Application>((j) => Application.fromJson(j)).toList();

      final modulesRes =
          await SupabaseService.client.from('module_applications').select();
      _allModuleApps = modulesRes
          .map<ModuleApplication>((j) => ModuleApplication.fromJson(j))
          .toList();

      final userIds = _allApps.map((a) => a.userId).toSet().toList();
      if (userIds.isNotEmpty) {
        final profilesRes = await SupabaseService.client
            .from('profiles')
            .select()
            .inFilter('id', userIds);
        _applicants = profilesRes
            .map<UserProfile>((j) => UserProfile.fromJson(j))
            .toList();
      } else {
        _applicants = [];
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateApplicationStatus(String appId, String newStatus) async {
    try {
      final application = _allApps.firstWhere((a) => a.id == appId);

      await SupabaseService.client.from('applications').update({
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
        'reviewed_by': SupabaseService.currentUser!.id,
        'reviewed_at': DateTime.now().toIso8601String(),
      }).eq('id', appId);

      await NotificationService.createNotification(
        userId: application.userId,
        title: 'Application ${newStatus.toUpperCase()}',
        message: 'Your application for Student Assistant has been $newStatus.',
      );

      await loadAllData();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteApplication(String appId) async {
    try {
      await SupabaseService.client
          .from('applications')
          .delete()
          .eq('id', appId);
      await loadAllData();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  int getTotalApplications() => _allApps.length;
  int getPendingCount() =>
      _allApps.where((a) => a.status == AppConstants.statusPending).length;
  int getApprovedCount() =>
      _allApps.where((a) => a.status == AppConstants.statusApproved).length;
  int getRejectedCount() =>
      _allApps.where((a) => a.status == AppConstants.statusRejected).length;

  double getApprovalRate() {
    if (_allApps.isEmpty) return 0;
    return getApprovedCount() / _allApps.length;
  }
}
