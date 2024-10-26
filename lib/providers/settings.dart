import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toolbox/repositories/preferences.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:toolbox/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  Future<bool> get storagePermissionStatus => StorageService.permissionStatus;
  Future<bool> get notificationPermissionStatus =>
      NotificationService.permissionStatus;

  Future<void> getNotificationPermission(bool newValue) async {
    if (!newValue) return;
    await NotificationService.requestPermission();
    await NotificationService.init();
    notifyListeners();
  }

  Future<void> getStoragePermission(bool newValue) async {
    if (!newValue) return;
    await StorageService.requestPermission();
    notifyListeners();
  }

  Future<String?> get downloadLocation => Preferences.downloadLocation;

  Future<void> pickDownloadLocation() async {
    // 1. pick location
    String? selectedDirectory = await FilePicker.platform
        .getDirectoryPath(initialDirectory: await Preferences.downloadLocation);

    if (selectedDirectory == null) return;

    // 2. save selected location
    await Preferences.setDownloadLocation(selectedDirectory);

    // 3. update ui
    notifyListeners();
  }
}
