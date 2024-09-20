import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:toolbox/models/download_task.dart';

class DownloadService2 {
  static Isolate? _mainIsolate;
  static ReceivePort mainReceivePort = ReceivePort()
    ..listen((dynamic message) {
      if (kDebugMode) print(message);
    });
  static SendPort? get mainSendPort => mainReceivePort.sendPort;

  static Future init() async => await mainIsolate;

  static Future<Isolate> get mainIsolate async {
    if (_mainIsolate != null) return _mainIsolate!;
    return _mainIsolate =
        await Isolate.spawn(_downloadFile, mainReceivePort.sendPort);
  }

  static void _downloadFile(SendPort sendPort) async {
    final subReceivePort = ReceivePort();
    // sendPort.send(subReceivePort.sendPort);

    await for (var message in subReceivePort) {
      if (message is DownloadTask) {
        try {
          final response = await http.get(Uri.parse(message.url));
          if (response.statusCode == 200) {
            final file = File(message.filePath);
            await file.writeAsBytes(response.bodyBytes);
            sendPort.send('Download completed: ${message.name}');
          } else {
            sendPort.send('Error: ${response.statusCode}');
          }
        } catch (e) {
          sendPort.send('Exception: $e');
        }
      }
    }
  }

  static Future<void> downloadFile(DownloadTask task) async =>
      mainSendPort?.send(task);

  static void dispose() {
    _mainIsolate!.kill(priority: Isolate.immediate);
    mainReceivePort.close();
  }
}
