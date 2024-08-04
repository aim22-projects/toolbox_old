import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';

class NewDownloadProvider extends ChangeNotifier {
  final urlInputController = TextEditingController();
  final fileNameInputController = TextEditingController();
  final downloadLocationInputController = TextEditingController();

  final BuildContext context;
  final String? downloadUrl;
  final DownloadsRepository downloadsRepository = DownloadsRepository();

  NewDownloadProvider({required this.context, this.downloadUrl}) {
    if (downloadUrl != null) {
      urlInputController.text = downloadUrl!;
    }
    urlInputController.addListener(_onFormChanged);
    fileNameInputController.addListener(_onFormChanged);
    downloadLocationInputController.addListener(_onFormChanged);
  }
  void _onFormChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    urlInputController.dispose();
    fileNameInputController.dispose();
    downloadLocationInputController.dispose();
    super.dispose();
  }

  bool get isFormValid =>
      urlInputController.text.isNotEmpty &&
      fileNameInputController.text.isNotEmpty &&
      downloadLocationInputController.text.isNotEmpty;

  Future<void> Function()? get addNewDownloadEvent =>
      isFormValid ? addNewDownloadTask : null;

  Future<void> addNewDownloadTask() async {
    await downloadsRepository.insertDownload(
      Download(
        url: urlInputController.text,
        name: fileNameInputController.text,
        location: downloadLocationInputController.text,
        createdAt: DateTime.now().toIso8601String(),
        downloadStatus: DownloadStatus.completed,
        thumbnailUrl: '',
      ),
    );
    // ignore: use_build_context_synchronously
    GoRouter.of(context).pop();
    // if (result)
  }
}
