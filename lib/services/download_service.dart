import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:http/http.dart' as http;

class DownloadService {
  DownloadService._internal();

  static DownloadService get _instance => DownloadService._internal();

  factory DownloadService() => _instance;

  static StreamController<DownloadTask> updatesStreamController =
      StreamController();

  static Stream<DownloadTask> get updates => updatesStreamController.stream;

  static Future<void> downloadFile(DownloadTask task) async {
    var request = http.Request('GET', Uri.parse(task.url));

    final response = await http.Client().send(request);

    if (response.statusCode != 200) throw Exception('Failed to download file');

    // final directory = await getExternalStorageDirectory();
    final filePath = '${task.downloadLocation}/${task.name}';
    final file = File(filePath);

    if (!await Directory(task.downloadLocation).exists()) {
      await Directory(task.downloadLocation).create();
    }

    final totalBytes = response.contentLength ?? 0;
    task.fileSize = totalBytes;
    updatesStreamController.sink.add(task);

    int receivedBytes = 0;

    final sink = file.openWrite();
    response.stream.listen(
      (List<int> chunk) {
        // receivedBytes += chunk.length;
        task.downloadedSize = task.downloadedSize ?? 0 + chunk.length;
        updatesStreamController.sink.add(task);
        // updates.onProgress(receivedBytes / totalBytes * 100, task);
        // download sink
        sink.add(chunk);
      },
      onDone: () async {
        await sink.close();
        task.downloadStatus = DownloadStatus.completed;
        updatesStreamController.sink.add(task);
      },
      onError: (error) async {
        await sink.close();
        task.downloadStatus = DownloadStatus.failed;
        updatesStreamController.sink.add(task);
        throw error;
      },
    );
  }
}
