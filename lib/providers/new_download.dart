import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
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
  bool _isLoading = false;
  int? _fileSize;
  String? _fileType;

  String? get fileType => _fileType;
  int? get fileSize => _fileSize;
  bool get isLoading => _isLoading;

  set fileType(String? value) {
    _fileType = value;
    notifyListeners();
  }

  set fileSize(int? value) {
    _fileSize = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  NewDownloadProvider({required this.context, this.downloadUrl}) {
    if (downloadUrl != null) {
      urlInputController.text = downloadUrl!;
      processUrl(downloadUrl!);
    }

    urlInputController.addListener(notifyListeners);
    fileNameInputController.addListener(notifyListeners);
    downloadLocationInputController.addListener(notifyListeners);

    // urlInputController.addListener(parseInstagramData);
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
    await parseInstagramData();
    await fetchUrlMetadata();
  }

  Future<void> parseInstagramData() async {
    // 1. check if valid instagram (reel) url
    var url = urlInputController.text;
    if (!url.startsWith("https://www.instagram.com/reel/")) {
      return;
    }
    // 2. parse instagram reel data
    // example instagram reel url
    // "https://www.instagram.com/reel/C-RYWZCN2TY/?utm_source=ig_web_copy_link";
    String reelId = url.split("/reel/")[1].split("/")[0];

    // 3. show loading
    // String url = urlInputController.text;
    isLoading = true;

    // 4. fetch data
    InstagramReel? result = await instagramService.fetchReelInfo(reelId);

    // 5. hide loading
    isLoading = false;

    // 6. validate result
    if (result == null) return;

    // 7. parse data
    urlInputController.text = result.videoLink;
  }

  Future<void> fetchUrlMetadata() async {
    try {
      // 1. show loading
      isLoading = true;
      // 2. fetch data
      Uri uri = Uri.dataFromString(urlInputController.text);
      var response = await http.head(uri);
      // 3. hide loading
      isLoading = false;
      // 4. check response status code
      if (response.statusCode != 200) return;
      // 5. parse headers
      fileSize = int.tryParse(response.headers['Content-Length'] ?? '');
      fileType = response.headers['Content-Type'];
    } catch (error) {
      // 1. hide loading
      isLoading = false;
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
