import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toolbox/repositories/database/base.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/services/sharing_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BaseDatabaseRepository.database;

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
    super.initState();

    init();
  }

  init() async {
    // manage platform
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return;
    }
    // 1. start listening shared data
    SharingService.instance.listen((value) async {
      // 1. return if data is null
      if (value == null || value.isEmpty) return;

      // 2. check mime type
      if (value.first.mimeType != 'text/plain') return;

      // GoRouter.of(context).go('/downloads/new');
      appRouter.push('/downloads/new', extra: value.first.path);
    });

    // 2. request storage permission
    var status = await Permission.manageExternalStorage.request().isGranted;
    if (status) return;

    // 3. show snackbar if storage permission is not granted
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Storage access is required to save the downloaded files.',
        ),
        action: SnackBarAction(
          label: 'Grant',
          onPressed: openAppSettings,
        ),
      ),
    );
  }

  @override
  void dispose() {
    SharingService.instance.dispose();

    super.dispose();
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
