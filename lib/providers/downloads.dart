import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:toolbox/dialogs/delete_download.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/background_download_service.dart';
import 'package:toolbox/services/sharing_service.dart';
import 'package:toolbox/sheets/download_details.dart';
import 'package:toolbox/sheets/new_download.dart';

class DownloadsProvider extends ChangeNotifier {
  List<DownloadTask> _downloads = [];
  Set<int> _selectedDownloads = {};
  final BuildContext context;

  List<DownloadTask> get downloads => _downloads;
  Set<int> get selectedDownloads => _selectedDownloads;

  bool get isMenuVisible => selectedDownloads.isNotEmpty;

  set downloads(List<DownloadTask> value) {
    _downloads = value;
    notifyListeners();
  }

  set selectedDownloads(Set<int> value) {
    _selectedDownloads = value;
    notifyListeners();
  }

  DownloadsProvider({required this.context}) {
    init();
    BackgroundDownloadService.updates.listen((task) {
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
    clearSelection();
  }

  Future<void> goToNewDownloadScreen() async {
    await GoRouter.of(context).push('/downloads/new');
    init();
  }

  Future<void> openFile(DownloadTask task) async {
    try {
      String path = "${task.downloadLocation}/${task.name}";

      await OpenFile.open(path);

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

  void askDeleteTask(DownloadTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete ${task.name}?"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void hideMenu() => clearSelection();

  // void showMenu(DownloadTask value) => selectedTask = value;

  void toggleSelection(int index) {
    if (_selectedDownloads.contains(index)) {
      _selectedDownloads.remove(index);
    } else {
      _selectedDownloads.add(index);
    }
    notifyListeners();
  }

  void clearSelection() {
    selectedDownloads.clear();
    notifyListeners();
  }

  void showInfo() {
    if (selectedDownloads.isEmpty) return;

    DownloadDetailsSheet.show(context, downloads[selectedDownloads.first]);
  }

  Future<void> deleteSelectedTask() async {
    if (selectedDownloads.isEmpty) return;

    for (var index in selectedDownloads) {
      await DownloadsRepository.deleteTask(downloads[index]);
    }

    fetchRecords();
  }

  Future<void> deleteTask(DownloadTask task) async {
    await DownloadsRepository.deleteTask(task);
    fetchRecords();
  }

  void confirmDeleteSelectedTask() {
    if (selectedDownloads.isEmpty) return;

    var firstRecord = downloads[selectedDownloads.first];

    DeleteDownloadDialog.show(
      context,
      firstRecord,
      deleteSelectedTask,
    );
  }
}
