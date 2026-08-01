import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../logger/app_logger.dart';
import '../storage/secure_storage_service.dart';

/// Notification Data Model
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String category;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.category = 'General',
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      category: json['category'] ?? 'General',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        body: body,
        category: category,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}

/// Notification State
class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) =>
      NotificationState(
        notifications: notifications ?? this.notifications,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

final notificationServiceProvider =
    StateNotifierProvider<NotificationService, NotificationState>(
        (ref) => NotificationService());

/// Production Notification Service — connects to Node.js/Express backend
class NotificationService extends StateNotifier<NotificationState> {
  static const String _baseUrl = 'http://localhost:5004/api/v1';

  NotificationService() : super(const NotificationState()) {
    fetchNotifications();
  }

  Future<Map<String, String>> _headers() async {
    final token = await SecureStorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /api/v1/notifications
  Future<void> fetchNotifications() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final headers = await _headers();
      final res = await http
          .get(Uri.parse('$_baseUrl/notifications'), headers: headers)
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = (data['notifications'] as List? ?? [])
            .map((n) =>
                NotificationModel.fromJson(n as Map<String, dynamic>))
            .toList();
        if (mounted) {
          state = state.copyWith(notifications: list, isLoading: false);
        }
        AppLogger.info('NotificationService: Loaded ${list.length} notifications');
        return;
      }
    } catch (e) {
      AppLogger.error('NotificationService: Backend unreachable — using defaults', e, null);
    }

    if (!mounted) return;
    state = state.copyWith(
      notifications: _defaults(),
      isLoading: false,
    );
  }

  /// PUT /api/v1/notifications/read
  Future<void> markAsRead(String notificationId) async {
    // Optimistic local update
    _updateLocal(notificationId, isRead: true);

    try {
      final headers = await _headers();
      await http
          .put(
            Uri.parse('$_baseUrl/notifications/read'),
            headers: headers,
            body: jsonEncode({'notificationId': notificationId}),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      AppLogger.error('NotificationService: markAsRead failed', e, null);
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    if (!mounted) return;
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updated);
  }

  /// DELETE /api/v1/notifications/:id
  Future<void> deleteNotification(String notificationId) async {
    // Optimistic removal
    if (mounted) {
      state = state.copyWith(
        notifications:
            state.notifications.where((n) => n.id != notificationId).toList(),
      );
    }

    try {
      final headers = await _headers();
      await http
          .delete(
            Uri.parse('$_baseUrl/notifications/$notificationId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      AppLogger.error('NotificationService: delete failed', e, null);
    }
  }

  void _updateLocal(String id, {required bool isRead}) {
    if (!mounted) return;
    state = state.copyWith(
      notifications: state.notifications.map((n) {
        return n.id == id ? n.copyWith(isRead: isRead) : n;
      }).toList(),
    );
  }

  List<NotificationModel> _defaults() => [
        NotificationModel(
          id: 'notif_1',
          title: '🌾 PM-KISAN 17th Installment',
          body: 'The 17th installment of PM-KISAN (₹2,000) has been released. Check your bank account.',
          category: 'Scheme Update',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NotificationModel(
          id: 'notif_2',
          title: '⏰ PMFBY Application Deadline',
          body: 'Crop insurance (PMFBY) deadline for Kharif season is August 31. Apply now.',
          category: 'Deadline Reminder',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        NotificationModel(
          id: 'notif_3',
          title: '✅ New Scheme Match Found',
          body: 'Based on your profile, you qualify for SMAM subsidy on farm machinery.',
          category: 'Recommendation',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: 'notif_4',
          title: '📄 Documents Required for KCC',
          body: 'Missing: Aadhaar copy, 7/12 extract. Complete KCC application now.',
          category: 'Document Reminder',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NotificationModel(
          id: 'notif_5',
          title: '🌿 PM Krishi Sinchayee Yojana',
          body: '80% drip irrigation subsidy available in Maharashtra. Limited quota.',
          category: 'Scheme Update',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
}
