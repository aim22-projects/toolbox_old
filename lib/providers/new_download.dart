import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/models/instagram_reel.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/services/instagram_service.dart';

class NewDownloadProvider extends ChangeNotifier {
  final BuildContext context;
  final String? downloadUrl;
  final instagramService = InstagramService();

  final urlInputController = TextEditingController();
  final fileNameInputController = TextEditingController();
  final downloadLocationInputController = TextEditingController();

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
    init();
  }

  @override
  void dispose() {
    urlInputController.dispose();
    fileNameInputController.dispose();
    downloadLocationInputController.dispose();
    super.dispose();
  }

  init() async {
    // 1. parse download url shared from another app
    if (downloadUrl != null) {
      urlInputController.text = downloadUrl!;
      processUrl();
    }
    // 2. fetch download location
    final downloadPath = (await getDownloadsDirectory())?.path ?? '/';
    final path = join(downloadPath, 'toolbox');
    downloadLocationInputController.text = path;

    // 3. add input change listeners
    urlInputController.addListener(notifyListeners);
    fileNameInputController.addListener(notifyListeners);
    downloadLocationInputController.addListener(notifyListeners);
  }

  bool get isFormValid =>
      urlInputController.text.isNotEmpty &&
      fileNameInputController.text.isNotEmpty &&
      downloadLocationInputController.text.isNotEmpty;

  Future<void> Function()? get addNewDownloadEvent =>
      isFormValid ? addNewDownloadTask : null;

  Future<void> addNewDownloadTask() async {
    await DownloadsRepository.insertDownload(
      DownloadTask(
        url: urlInputController.text,
        name: fileNameInputController.text,
        downloadLocation: downloadLocationInputController.text,
        createdAt: DateTime.now(),
        downloadStatus: DownloadStatus.completed,
        thumbnailUrl: '',
        fileSize: fileSize,
      ),
    );
    // ignore: use_build_context_synchronously
    GoRouter.of(context).pop();
    // if (result)
  }

  Future<void> processUrl() async {
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

    if (kDebugMode) {
      print(reelId);
    }
    // 4. fetch data
    InstagramReel? result = await instagramService.fetchReelInfo(reelId);

    // 5. hide loading
    isLoading = false;

    // 6. validate result
    if (result == null) return;

    // 7. parse data
    urlInputController.text = result.videoLink;

    //

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).clearSnackBars();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("instagram data parsed"),
    ));
  }

  Future<void> fetchUrlMetadata() async {
    if (kDebugMode) {
      print("fetch metadata");
    }
    try {
      // 1. show loading
      isLoading = true;
      // 2. fetch data
      Uri uri = Uri.parse(urlInputController.text);
      var response = await http.head(uri);
      // 3. hide loading
      isLoading = false;
      // 4. check response status code
      if (response.statusCode != 200) return;
      // 5. parse headers
      fileSize = int.tryParse(response.headers['content-length'] ?? '');
      fileType = response.headers['content-type'];
      if (response.headers.containsKey('content-disposition')) {
        fileNameInputController.text =
            response.headers['content-disposition'] ?? '';
      } else {
        fileNameInputController.text =
            (response.headers['content-type'] ?? '').replaceFirst('/', '.');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("metadata parsed"),
      ));
    } catch (error) {
      // 1. hide loading
      isLoading = false;
      if (kDebugMode) {
        print(error);
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$error'),
      ));
    }
  }
}
