import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';

class DownloadsProvider extends ChangeNotifier {
  List<Download> _downloads = [];
  final DownloadsRepository downloadsRepository = DownloadsRepository();
  final BuildContext context;

  List<Download> get downloads => _downloads;

  set downloads(List<Download> value) {
    _downloads = value;
    notifyListeners();
  }

  DownloadsProvider({required this.context}) {
    init();
  }

  Future<void> init() async {
    await downloadsRepository.init();
    // await Future<void>.delayed(const Duration(seconds: 3));
    // await downloadsRepository.init();

    // 1. fetch database values
    var result = await downloadsRepository.getDownloads();

    // 2. result
    downloads = result ?? [];
  }

  Future<void> goToNewDownloadScreen() async {
    await GoRouter.of(context).push('/downloads/new');
    init();
  }
}
