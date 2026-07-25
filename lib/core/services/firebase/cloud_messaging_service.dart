import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../logger/app_logger.dart';

abstract class ICloudMessagingService {
  Future<void> initialize();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}

class FirebaseCloudMessagingService implements ICloudMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      AppLogger.info('FirebaseCloudMessagingService: Permission status ${settings.authorizationStatus}');

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);
      await _localNotifications.initialize(initSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.info('FirebaseCloudMessagingService: Foreground message received: ${message.notification?.title}');
        _showLocalNotification(message);
      });

      // Subscribe to scheme announcements topic
      await subscribeToTopic('schemes_updates');
    } catch (e, stack) {
      AppLogger.error('FirebaseCloudMessagingService initialization warning', e, stack);
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
    } catch (_) {}
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
    } catch (_) {}
  }

  void _showLocalNotification(RemoteMessage message) {
    const androidDetails = AndroidNotificationDetails(
      'krishisahayak_channel',
      'KrishiSahayak Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    _localNotifications.show(
      0,
      message.notification?.title ?? 'KrishiSahayak Alert',
      message.notification?.body ?? 'New government scheme update available.',
      details,
    );
  }
}
