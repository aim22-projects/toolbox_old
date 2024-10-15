import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class HttpEx {
  HttpEx._();
  static download(
    String url,
    String path, {
    void Function()? onStarted,
    void Function(int received, int total)? onProgress,
    void Function()? onComplete,
    void Function(Object error)? onError,
  }) async {
    try {
      // 1. create http request
      var request = http.Request('GET', Uri.parse(url));
      final response = await http.Client().send(request);
      if (response.statusCode != 200) {
        throw Exception('Failed to download file');
      }
      // 2. capture download size
      int totalSize = response.contentLength ?? 0;
      int received = 0;
      // 3. create download directory if not exists
      await Directory(dirname(path)).create();
      // 4. create file
      final file = File(path);
      final fileSink = file.openWrite();
      // call on started callback
      if (onStarted != null) onStarted();
      // 5. listen downloading data and write to file
      response.stream.listen(
        (List<int> chunk) async {
          // download sink
          fileSink.add(chunk);
          // update progress
          received += chunk.length;
          // call in progress callback
          if (onProgress != null) onProgress(received, totalSize);
        },
        onDone: () async {
          // close file write
          await fileSink.close();
          // call on complete callback
          if (onComplete != null) onComplete();
        },
        onError: (error) async {
          // close file write
          await fileSink.close();
          // call on error callback
          if (onError != null) onError(error);
        },
      );
    } catch (ex) {
      if (onError != null) onError(ex);
    }
  }
}
