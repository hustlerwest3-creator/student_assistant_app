// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// Date: May 2026

import 'package:flutter/material.dart';
import 'supabase_service.dart';

class NotificationService {
  static Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    try {
      await SupabaseService.client.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'is_read': false,
      });
    } catch (e) {
      debugPrint('Error creating notification: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserNotifications(
    String userId,
  ) async {
    final response = await SupabaseService.client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response;
  }

  static Future<void> markAsRead(String notificationId) async {
    await SupabaseService.client
        .from('notifications')
        .update({'is_read': true}).eq('id', notificationId);
  }
}
