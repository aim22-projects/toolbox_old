import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
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
    if (Platform.isAndroid) {
      var androidPlugin =
          notificationPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      androidPlugin?.requestNotificationsPermission();
    }
    if (Platform.isIOS) {
      var iosPlugin = notificationPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      iosPlugin?.requestPermissions();
    }
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

    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationListener,
      onDidReceiveBackgroundNotificationResponse: notificationListener,
    );
  }

  @pragma('vm:entry-point')
  static void notificationListener(NotificationResponse details) async {
    try {
      if (details.payload != null) {
        await OpenFile.open(details.payload!);
      }
      // ignore: empty_catches
    } catch (e) {}
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
