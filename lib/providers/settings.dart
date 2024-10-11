import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/repositories/preferences.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:toolbox/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  Future<void> getNotificationPermission() async {
    await NotificationService.requestPermission();
    await NotificationService.init();
  }

  Future<void> getStoragePermission() async {
    await StorageService.requestPermission();
  }

  Future<String?> get downloadLocation => Preferences.downloadLocation;

  Future<void> pickDownloadLocation() async {
    // 1. pick location
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    // 1.1. validate result
    if (selectedDirectory == null) return;

    // 2. save selected location
    await Preferences.setDownloadLocation(selectedDirectory);

    // 3. update ui
    notifyListeners();
  }
}
