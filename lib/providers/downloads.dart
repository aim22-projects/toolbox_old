import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/sheets/download_details.dart';

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
  }

  Future<void> init() async {
    // 1. fetch records
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    // 1. fetch database values
    downloads = await DownloadsRepository.getDownloads() ?? [];
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
