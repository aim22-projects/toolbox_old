import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:toolbox/services/storage_service.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.requestPermission();
  // await StorageService.requestPermission();
  // await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
