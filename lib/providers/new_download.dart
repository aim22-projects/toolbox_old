import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/models/instagram_reel.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/instagram_service.dart';

class NewDownloadProvider extends ChangeNotifier {
  final urlInputController = TextEditingController();
  final fileNameInputController = TextEditingController();
  final downloadLocationInputController = TextEditingController();

  final BuildContext context;
  final String? downloadUrl;
  final DownloadsRepository downloadsRepository = DownloadsRepository();
  final InstagramService instagramService = InstagramService();
  bool _processingUrl = false;

  bool get processingUrl => _processingUrl;

  set processingUrl(bool value) {
    _processingUrl = value;
    notifyListeners();
  }

  NewDownloadProvider({required this.context, this.downloadUrl}) {
    if (downloadUrl != null) {
      urlInputController.text = downloadUrl!;
    }

    urlInputController.addListener(notifyListeners);
    fileNameInputController.addListener(notifyListeners);
    downloadLocationInputController.addListener(notifyListeners);
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

  Future<void> processUrl(String value) async {
    if (!value.startsWith("https://www.instagram.com/reel/")) return;

    // example instagram reel url
    // "https://www.instagram.com/reel/C-RYWZCN2TY/?utm_source=ig_web_copy_link";
    String reelId = value.split("/reel/")[1].split("/")[0];

    // String url = urlInputController.text;
    processingUrl = true;

    InstagramReel? result = await instagramService.fetchReelInfo(reelId);

    processingUrl = false;

    if (result == null) return;

    urlInputController.text = result.videoLink;
  }
}
