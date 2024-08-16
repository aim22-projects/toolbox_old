import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/sheets/download_details.dart';

class DownloadsProvider extends ChangeNotifier {
  List<DownloadTask> _downloads = [];
  final DownloadsRepository downloadsRepository = DownloadsRepository();
  final BuildContext context;
  final ReceivePort _port = ReceivePort();

  List<DownloadTask> get downloads => _downloads;

  set downloads(List<DownloadTask> value) {
    _downloads = value;
    notifyListeners();
  }

  DownloadsProvider({required this.context}) {
    init();
  }

  Future<void> init() async {
    // 1. fetch records
    fetchRecords();
    // FlutterDownloader.registerCallback(notifyListeners);
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      fetchRecords();
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> fetchRecords() async {
    // // 1. fetch database values
    // var result = await downloadsRepository.getDownloads();

    // // 2. result
    // downloads = result ?? [];

    final tasks = await FlutterDownloader.loadTasks();
    if (tasks != null) downloads = tasks;
  }

  Future<void> goToNewDownloadScreen() async {
    await GoRouter.of(context).push('/downloads/new');
    init();
  }

  Future showDownloadDetails(DownloadTask downloadTask) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => DownloadDetailsSheet(
        download: downloadTask,
      ),
    );
  }
}
