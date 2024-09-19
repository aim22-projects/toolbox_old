import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/models/instagram_reel.dart';
import 'package:toolbox/services/download_service.dart';
import 'package:toolbox/services/instagram_service.dart';

class NewDownloadProvider extends ChangeNotifier {
  final BuildContext context;
  final String? downloadUrl;

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
    downloadLocationInputController.text = downloadPath;

    // 3. add input change listeners
    urlInputController.addListener(notifyListeners);
    fileNameInputController.addListener(notifyListeners);
    downloadLocationInputController.addListener(notifyListeners);
  }

  String get fileUrl => urlInputController.text;

  bool get isFormValid =>
      urlInputController.text.isNotEmpty &&
      fileNameInputController.text.isNotEmpty &&
      downloadLocationInputController.text.isNotEmpty;

  Future<void> Function()? get addNewDownloadEvent =>
      isFormValid ? addNewDownloadTask : null;

  Future<void> addNewDownloadTask() async {
    var task = DownloadTask(
      url: urlInputController.text,
      name: fileNameInputController.text,
      downloadLocation: downloadLocationInputController.text,
      createdAt: DateTime.now(),
      downloadStatus: DownloadStatus.completed,
      thumbnailUrl: '',
      fileSize: fileSize,
    );

    await DownloadService.downloadFile(task);
    notifyListeners();
    // ignore: use_build_context_synchronously
    GoRouter.of(context).pop();
    // if (result)
  }

  Future<void> processUrl() async {
    await parseInstagramData();
    await getUrlMetadata();
  }

  Future<void> parseInstagramData() async {
    // 3. show loading
    isLoading = true;

    // 4. fetch data
    InstagramReel? result = await InstagramService.getReelInfoFromUrl(fileUrl);

    // 5. hide loading
    isLoading = false;

    // 6. validate result
    if (result == null) return;

    // 7. parse data
    urlInputController.text = result.videoLink;
    //

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(
        content: Text("instagram data parsed"),
      ));
  }

  Future<void> getUrlMetadata() async {
    try {
      // 1. show loading
      isLoading = true;
      // 4. check response status code
      var fileMetaData = await DownloadService.getDownloadFileMetaInfo(fileUrl);
      // 5. parse headers
      fileSize = fileMetaData?.fileSize;
      fileType = fileMetaData?.fileType;
      fileNameInputController.text = fileMetaData?.fileName ?? '';
      // 3. hide loading
      isLoading = false;
    } catch (error) {
      // 1. hide loading
      isLoading = false;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text('$error'),
        ));
    }
  }
}
