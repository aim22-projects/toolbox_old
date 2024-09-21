import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/download_service.dart';
import 'package:toolbox/services/sharing_service.dart';
import 'package:toolbox/sheets/new_download.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadTasksProvider extends ChangeNotifier {
  List<DownloadTask> _downloads = [];
  final BuildContext context;

  List<DownloadTask> get downloads => _downloads;

  set downloads(List<DownloadTask> value) {
    _downloads = value;
    notifyListeners();
  }

  DownloadTasksProvider({required this.context}) {
    init();
    DownloadService.updates.listen((task) {
      fetchRecords();
    });
  }

  @override
  void dispose() {
    SharingService.instance.dispose();
    super.dispose();
  }

  init() async {
    // 1. validate platform
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return;
    }

    // 2. fetch records
    fetchRecords();

    // 3. start listening to shared data
    SharingService.instance.listen((value) async {
      // 1. return if data is null
      if (value == null || value.isEmpty) return;

      // 2. check mime type
      if (value.first.mimeType != 'text/plain') return;

      // GoRouter.of(context).go('/downloads/new');

      await NewDownloadSheet.show(context, value.first.path);

      fetchRecords();

      // GoRouter.of(context).push('/downloads/new', extra: value.first.path);
    });

    // 2. request storage permission
    // currently disabled as app will directly navigate to storage settings
    // var status = await Permission.manageExternalStorage.request().isGranted;
    // if (status) return;

    // 3. show snackbar if storage permission is not granted
    // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text(
    //       'Storage access is required to save the downloaded files.',
    //     ),
    //     action: SnackBarAction(
    //       label: 'Grant',
    //       onPressed: openAppSettings,
    //     ),
    //   ),
    // );
  }

  Future<void> fetchRecords() async {
    // 1. fetch database values
    downloads = await DownloadsRepository.getTasks() ?? [];
  }

  Future<void> deleteTask(DownloadTask task) async {
    await DownloadsRepository.deleteTask(task);
    fetchRecords();
  }

  Future<void> goToNewDownloadScreen() async {
    await GoRouter.of(context).push('/downloads/new');
    init();
  }

  Future<void> openFile(DownloadTask task) async {
    try {
      String path = "${task.downloadLocation}/${task.name}";
      print(path);

      var result = await OpenFile.open(path);

      // Uri uri = Uri.parse(task.url);

      // if (!await canLaunchUrl(uri)) {
      //   throw "No default app found to open link";
      // }

      // if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      //   throw "Unknown error while open link";
      // }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
}
