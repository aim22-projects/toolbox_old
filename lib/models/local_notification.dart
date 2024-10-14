import 'package:toolbox/models/download_task.dart';

class LocalNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  LocalNotification({
    this.id = 0,
    required this.title,
    required this.body,
    this.payload,
  });

  LocalNotification.downloadStarted(DownloadTask task)
      : this(
          title: 'Download started',
          body: task.name,
          id: task.id ?? 0,
        );
  LocalNotification.downloadFinished(DownloadTask task)
      : this(
          title: 'Download finished',
          body: task.name,
          payload: task.filePath,
          id: task.id ?? 0,
        );
  LocalNotification.downloadFailed(DownloadTask task)
      : this(
          title: 'Download failed',
          body: task.name,
        );
  LocalNotification.downloadInProgress(DownloadTask task)
      : this(
          id: task.id ?? 0,
          title: 'Download inProgress',
          body: "${task.name} - ${task.progress} %",
        );

  LocalNotification.fromMap(Map<String, dynamic> value)
      : id = value[LocalNotificationKeys.id] as int? ?? 0,
        title = value[LocalNotificationKeys.title] as String? ?? '',
        body = value[LocalNotificationKeys.body] as String? ?? '',
        payload = value[LocalNotificationKeys.payload] as String? ?? '';

  Map<String, dynamic> toMap() => {
        LocalNotificationKeys.id: id,
        LocalNotificationKeys.title: title,
        LocalNotificationKeys.body: body,
        LocalNotificationKeys.payload: payload,
      };
}

class LocalNotificationKeys {
  static const String id = 'id';
  static const String title = 'title';
  static const String body = 'body';
  static const String payload = 'payload';
}
