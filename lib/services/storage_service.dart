import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  static init() {
    requestPermission();
  }

  static Future<bool> get permissionStatus async {
    final plugin = DeviceInfoPlugin();
    final androidDeviceInfo = await plugin.androidInfo;

    var status = await Permission.storage.status;

    if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 33) {
      status = await Permission.manageExternalStorage.status;
    } else if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 32) {
      status = await Permission.videos.status;
    }

    // storage permission already granted
    return status.isGranted;
  }

  static requestPermission() async {
    final plugin = DeviceInfoPlugin();
    final androidDeviceInfo = await plugin.androidInfo;

    if (await permissionStatus) {
      if (kDebugMode) {
        print("Permission already granted");
      }
      return;
    }

    var requestStorage = Permission.storage.request;
    if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 33) {
      requestStorage = Permission.manageExternalStorage.request;
    } else if (Platform.isAndroid && androidDeviceInfo.version.sdkInt > 32) {
      requestStorage = Permission.videos.request;
    }

    var isGranted = await requestStorage().isGranted;

    // storage permission denied
    if (!isGranted) {
      if (kDebugMode) {
        print("Permission denied");
      }
      return;
    }
    // storage permission granted
    if (kDebugMode) {
      print("Permission granted");
    }
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
}
