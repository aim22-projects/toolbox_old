import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';
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

  Future<void> openFile(DownloadTask task) async {
    try {
      Uri uri = Uri.parse(task.url);

      if (!await canLaunchUrl(uri)) {
        throw "No default app found to open link";
      }

      if (!await launchUrl(uri)) {
        throw "Unknown error while open link";
      }
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
