import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/services/download_service.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:toolbox/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.requestPermission();
  StorageService.requestPermission();
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
    init();
    super.initState();
  }

  init() async {
    await NotificationService.init();
    // ignore: use_build_context_synchronously
    // await StorageService.showDialogs(context);
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
