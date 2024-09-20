import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/extensions/url.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:http/http.dart' as http;
import 'package:toolbox/models/file_meta_data.dart';
import 'package:toolbox/models/local_notification.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

class DownloadService {
  DownloadService._internal();

  static DownloadService get _instance => DownloadService._internal();

  factory DownloadService() => _instance;

  static StreamController<DownloadTask> updatesStreamController =
      StreamController();

  static Stream<DownloadTask> get updates =>
      updatesStreamController.stream..listen(DownloadsRepository.updateTask);

  static Future<void> downloadFile(DownloadTask task) async {
    // 1. create http request
    var request = http.Request('GET', Uri.parse(task.url));
    final response = await http.Client().send(request);
    if (response.statusCode != 200) throw Exception('Failed to download file');

    // 2. insert download record
    task.fileSize = response.contentLength ?? 0;
    task.id = await DownloadsRepository.insertTask(task);
    updatesStreamController.sink.add(task);

    int downloadedSize = task.downloadedSize ?? 0;

    // 3. create download directory if not exists
    if (!await Directory(task.downloadLocation).exists()) {
      await Directory(task.downloadLocation).create();
    }

    // 4. create file
    final file = File(task.filePath);
    final fileSink = file.openWrite();

    // show notification
    NotificationService.showNotification(LocalNotification(
      title: 'Download started',
      body: task.name,
      payload: '',
    ));

    // 5. listen downloading data and write to file
    response.stream.listen(
      (List<int> chunk) async {
        // download sink
        fileSink.add(chunk);
        // update database
        downloadedSize += chunk.length;
        task.downloadedSize = downloadedSize;
        if (kDebugMode) {
          // ignore: prefer_interpolation_to_compose_strings
          print('downloaded:${task.downloadedSize}');
        }
        updatesStreamController.sink.add(task);
        await DownloadsRepository.updateTask(task);
      },
      onDone: () async {
        // close file write
        await fileSink.close();
        // update database
        task.downloadStatus = DownloadStatus.completed;
        updatesStreamController.sink.add(task);
        // show notification
        NotificationService.showNotification(LocalNotification(
          title: 'Download finished',
          body: task.name,
          payload: '',
        ));
        await DownloadsRepository.updateTask(task);
      },
      onError: (error) async {
        // close file write
        await fileSink.close();
        // update database
        task.downloadStatus = DownloadStatus.failed;
        updatesStreamController.sink.add(task);
        // show notification
        NotificationService.showNotification(LocalNotification(
          title: 'Download failed',
          body: task.name,
          payload: '',
        ));
        await DownloadsRepository.updateTask(task);
      },
    );
  }

  static Future<FileMetaData?> getDownloadFileMetaInfo(String url) async {
    try {
      // 2. fetch data
      Uri uri = Uri.parse(url);
      var response = await http.head(uri);
      // 4. check response status code
      if (response.statusCode != 200) return null;
      // 5. parse headers

      FileMetaData fileMetaData = FileMetaData(
        fileSize: int.tryParse(response.headers['content-length'] ?? ''),
        fileType: response.headers['content-type'],
        fileName: response.headers.containsKey('content-disposition')
            ? fileNameFromContentDiscriptionHeader(
                response.headers['content-disposition'])
            : fileNameFromContentTypeHeader(response.headers['content-type']) ??
                '',
      );
      return fileMetaData;
    } catch (ex) {
      return null;
    }
  }

  // Mandatory if the App is obfuscated or using Flutter 3.1+
  @pragma('vm:entry-point')
  static void downloaderDispatcher() {
    Workmanager().executeTask((task, inputData) {
      //simpleTask will be emitted here.
      print("Native called background task: $task");
      return Future.value(true);
    });
  }

  static void initializeManager() {
    Workmanager().initialize(
      // The top level function, aka callbackDispatcher
      downloaderDispatcher,
      // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      isInDebugMode: true,
    );
  }
}
