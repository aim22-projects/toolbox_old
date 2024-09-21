import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toolbox/models/local_notification.dart';

class NotificationService {
  static final notificationPlugin = FlutterLocalNotificationsPlugin();
  static const androidDetails = AndroidNotificationDetails(
    'id',
    'notification',
    importance: Importance.max,
    priority: Priority.high,
  );
  static const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static requestPermission() {
    var d = notificationPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    d?.requestNotificationsPermission();
  }

  static init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(LocalNotification notification) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notificationPlugin.show(
      notification.id, // Notification ID
      notification.title, // Title
      notification.body, // Body
      platformChannelSpecifics,
      payload: notification.payload, // Optional data
    );
  }
}
