import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/models/local_notification.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'download_service.dart';

class BackgroundDownloadService {
  BackgroundDownloadService._() {
    init();
  }

  static init() => Workmanager().initialize(callback);

  // static sendNotificationMap(
  //   String uniqueName,
  //   Map<String, dynamic> payload,
  // ) {
  //   Workmanager().registerOneOffTask(
  //     uniqueName,
  //     "notification",
  //     inputData: payload,
  //   );
  // }

  static sendNotification(
    String uniqueName,
    LocalNotification notification,
  ) {
    Workmanager().registerOneOffTask(
      uniqueName,
      "notification",
      inputData: {"notification": jsonEncode(notification.toMap())},
    );
  }

  static updateDownloadProgress(DownloadTask task) {
    Workmanager().registerOneOffTask(
      task.name,
      "downloadProgress",
      inputData: {"task": jsonEncode(task.toMap())},
    );
  }

  static download(DownloadTask task) {
    Workmanager().registerOneOffTask(
      task.name + DateTime.now().millisecondsSinceEpoch.toString(),
      "download",
      inputData: {"task": jsonEncode(task.toMap())},
    );
  }

  @pragma('vm:entry-point')
  static callback() {
    Workmanager().executeTask((task, inputData) async {
      if (kDebugMode) {
        print(task);
      }
      switch (task) {
        case 'download' when inputData != null:
          DownloadTask downloadTask = DownloadTask.fromMap(
            jsonDecode(inputData['task']),
          );
          await DownloadService.downloadFile(downloadTask);
          break;
        case 'downloadProgress' when inputData != null:
          DownloadTask downloadTask = DownloadTask.fromMap(
            jsonDecode(inputData['task']),
          );
          updatesStreamController.sink.add(downloadTask);
          sendNotification(
            downloadTask.name,
            LocalNotification.downloadInProgress(downloadTask),
          );
          break;
        case 'notification' when inputData != null:
          var notification = LocalNotification.fromMap(
            jsonDecode(inputData['notification']),
          );
          NotificationService.showNotification(notification);
          sendNotification(
            DateTime.now().millisecondsSinceEpoch.toString(),
            notification,
          );
          break;
        default:
          break;
      }
      return Future.value(true);
    });
  }

  static StreamController<DownloadTask> updatesStreamController =
      StreamController.broadcast();

  static Stream<DownloadTask> get updates =>
      updatesStreamController.stream..listen(DownloadsRepository.updateTask);
}
