import 'dart:async';
import 'dart:io';

import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/extensions/http_ex.dart';
import 'package:toolbox/extensions/url.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:http/http.dart' as http;
import 'package:toolbox/models/file_meta_data.dart';
import 'package:toolbox/models/local_notification.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/background_download_service.dart';

class DownloadService {
  DownloadService._internal();

  static Future<void> downloadFile(DownloadTask task) async {
    try {
      // 2. insert download record
      task.id = await DownloadsRepository.insertTask(task);

      await HttpEx.download(
        task.url,
        task.filePath,
        onStarted: () {
          // show notification
          BackgroundDownloadService.sendNotification(
            task.name,
            LocalNotification.downloadStarted(task),
          );
        },
        onProgress: (int received, int total) {
          if (total == -1) return;
          // double progress = received / total;
          task.downloadedSize = received;
          task.downloadStatus = DownloadStatus.inProcess;
          DownloadsRepository.updateTask(task);
          BackgroundDownloadService.updateDownloadProgress(task);
        },
        onComplete: () {
          // update database
          task.downloadStatus = DownloadStatus.completed;
          DownloadsRepository.updateTask(task);
          BackgroundDownloadService.updateDownloadProgress(task);
          // show notification
          BackgroundDownloadService.sendNotification(
            task.name,
            LocalNotification.downloadFinished(task),
          );
        },
        onError: (error) {
          // update database
          task.downloadStatus = DownloadStatus.failed;
          DownloadsRepository.updateTask(task);
          BackgroundDownloadService.updateDownloadProgress(task);
          BackgroundDownloadService.sendNotification(
              task.name, LocalNotification.downloadFailed(task));
        },
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
