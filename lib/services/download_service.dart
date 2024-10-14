import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/extensions/url.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:http/http.dart' as http;
import 'package:toolbox/models/file_meta_data.dart';
import 'package:toolbox/models/local_notification.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/background_download_service.dart';

class DownloadService {
  DownloadService._internal();

  static DownloadService get _instance => DownloadService._internal();

  factory DownloadService() => _instance;

  static Future<void> downloadFile(DownloadTask task) async {
    try {
      // 2. insert download record
      task.id = await DownloadsRepository.insertTask(task);

      // 3. create download directory if not exists
      if (!await Directory(task.downloadLocation).exists()) {
        await Directory(task.downloadLocation).create();
      }

      // show notification
      BackgroundDownloadService.sendNotification(
        task.name,
        LocalNotification.downloadStarted(task),
      );

      Dio dio = Dio();
      await dio.download(
        task.url,
        task.filePath,
        onReceiveProgress: (received, total) {
          if (total == -1) return;
          // double progress = received / total;
          task.downloadedSize = received;
          task.downloadStatus = DownloadStatus.inProcess;
          BackgroundDownloadService.updateDownloadProgress(task);
        },
      );
      // update database
      task.downloadStatus = DownloadStatus.completed;
      BackgroundDownloadService.updateDownloadProgress(task);
      // show notification
      BackgroundDownloadService.sendNotification(
        task.name,
        LocalNotification.downloadFinished(task),
      );
    } catch (ex) {
      // update database
      task.downloadStatus = DownloadStatus.failed;
      BackgroundDownloadService.updateDownloadProgress(task);
      BackgroundDownloadService.sendNotification(
          task.name, LocalNotification.downloadFailed(task));
    }
  }

  static Future<FileMetaData?> getMetaInfo(String url) async {
    try {
      // 2. fetch data
      var uri = Uri.parse(url);
      var response = await http.head(uri);
      // 4. check response status code
      if (response.statusCode != 200) throw "Invalid Response";
      // 5. parse headers
      return FileMetaData(
        fileSize: int.tryParse(response.headers['content-length'] ?? ''),
        fileType: response.headers['content-type'],
        fileName: fileName(uri, response.headers),
      );
    } catch (ex) {
      return null;
    }
  }

  static bool isFileExists(String location) => File(location).existsSync();
}
