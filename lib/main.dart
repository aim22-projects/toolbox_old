import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/services/download_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DownloadService.initializeManager();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    requestPermission();
    super.initState();
  }

  requestPermission() async {
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
    // Now you can access external storage
    String downloadPath = await getDownloadPath();
    print('Download Path: $downloadPath');
  }

  Future<String> getDownloadPath() async {
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    if (downloadsDirectory != null) {
      return '${downloadsDirectory.path}/Download';
    }
    throw Exception('Could not get download path');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        cardTheme: CardTheme(
          color: Colors.grey[900], // Dark card background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
