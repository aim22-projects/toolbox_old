import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:http/http.dart' as http;

class DownloadService {
  DownloadService._internal();

  static DownloadService get _instance => DownloadService._internal();

  factory DownloadService() => _instance;

  static Future<void> downloadFile(
    DownloadTask task,
    Function(double, DownloadTask) onProgress,
  ) async {
    var request = http.Request('GET', Uri.parse(task.url));

    final response = await http.Client().send(request);

    if (response.statusCode != 200) throw Exception('Failed to download file');

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${task.name}';
    final file = File(filePath);

    final totalBytes = response.contentLength ?? 0;
    int receivedBytes = 0;

    final sink = file.openWrite();
    response.stream.listen(
      (List<int> chunk) {
        receivedBytes += chunk.length;
        onProgress(receivedBytes / totalBytes * 100, task);
        sink.add(chunk);
      },
      onDone: () async {
        await sink.close();
      },
      onError: (error) {
        sink.close();
        throw error;
      },
    );
  }
}
