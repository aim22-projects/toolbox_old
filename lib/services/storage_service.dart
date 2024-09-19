import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  static init() {
    requestPermission();
  }

  static requestPermission() async {
    final plugin = DeviceInfoPlugin();
    final androidDeviceInfo = await plugin.androidInfo;

    var status = await Permission.storage.status;

    if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 33) {
      status = await Permission.manageExternalStorage.status;
    } else if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 32) {
      status = await Permission.videos.status;
    }

    // storage permission already granted
    if (status.isGranted) {
      print("Permission already granted");
      String downloadPath = await getDownloadPath();
      print('Download Path: $downloadPath');
      return;
    }

    var requestStorage = Permission.storage.request;
    if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 33) {
      requestStorage = Permission.manageExternalStorage.request;
    } else if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 32) {
      requestStorage = Permission.videos.request;
    }

    // storage permission denied
    if (!await requestStorage().isGranted) {
      return print("Permission denied");
    }
    // storage permission granted
    print("Permission granted");
  }

  static showDialogs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Storage Permission'),
        content: Text('Allow app to access storage on your device'),
        actions: [
          TextButton(onPressed: requestPermission, child: Text('Request'))
        ],
      ),
    );
  }

  static Future<String> getDownloadPath() async {
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    if (downloadsDirectory != null) {
      return downloadsDirectory.path;
    }
    throw Exception('Could not get download path');
  }
}
