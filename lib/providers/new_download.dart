import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/download_task.dart';
import 'package:toolbox/models/file_meta_data.dart';
import 'package:toolbox/models/instagram_reel.dart';
import 'package:toolbox/repositories/preferences.dart';
import 'package:toolbox/services/download_service.dart';
import 'package:toolbox/services/instagram_service.dart';

class NewDownloadProvider extends ChangeNotifier {
  final BuildContext context;
  final String? downloadUrl;

  final urlInputController = TextEditingController();
  final fileNameInputController = TextEditingController();

  bool _isLoading = false;
  FileMetaData? _fileMetaData;

  FileMetaData? get fileMetaData => _fileMetaData;
  bool get isLoading => _isLoading;

  String get url => urlInputController.text;
  String get fileName => fileNameInputController.text;
  bool? get isFileNameValid => DownloadService.isFileExists(fileName);

  bool get isFormValid => url.isNotEmpty && fileName.isNotEmpty;

  set fileMetaData(FileMetaData? value) {
    _fileMetaData = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set url(String value) {
    urlInputController.text = value;
    notifyListeners();
  }

  set fileName(String value) {
    fileNameInputController.text = value;
    notifyListeners();
  }

  NewDownloadProvider({required this.context, this.downloadUrl}) {
    init();
  }

  @override
  void dispose() {
    urlInputController.dispose();
    fileNameInputController.dispose();
    super.dispose();
  }

  init() async {
    // 1. parse download url shared from another app
    if (downloadUrl != null) {
      url = downloadUrl!;
      processUrl();
    }

    // 3. add input change listeners
    urlInputController.addListener(notifyListeners);
    fileNameInputController.addListener(notifyListeners);
  }

  Future<void> Function()? get addNewDownloadEvent =>
      isFormValid ? addNewDownloadTask : null;

  Future<void> addNewDownloadTask() async {
    // 2. fetch download location
    var downloadLocation = await Preferences.downloadLocation ?? '/';

    await DownloadService.downloadFile(DownloadTask(
      url: url,
      name: fileName,
      downloadLocation: downloadLocation,
      createdAt: DateTime.now(),
      downloadStatus: DownloadStatus.loading,
      thumbnailUrl: '',
      fileSize: fileMetaData?.fileSize,
    ));
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
    InstagramReel? result = await InstagramService.getReelInfoFromUrl(url);

    // 5. hide loading
    isLoading = false;

    // 6. validate result
    if (result == null) return;

    // 7. parse data
    url = result.videoLink;
    //

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(
        content: Text("instagram data parsed"),
      ));
  }

  Future<void> getUrlMetadata() async {
    // 1. show loading
    isLoading = true;
    try {
      // 1. get metadata from download url
      fileMetaData = await DownloadService.getMetaInfo(url);
      // 2. parse headers
      fileName = fileMetaData?.fileName ?? '';
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text('$error'),
        ));
    } finally {
      // 1. hide loading
      isLoading = false;
    }
  }
}
