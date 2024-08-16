import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/services/sharing_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          false // option: set to false to disable working with http links (default: false)
      );
  await [
    Permission.storage,
  ].request();
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
    SharingService.instance.listen((value) {
      // 1. return if data is null
      if (value == null || value.isEmpty) return;

      // 2. check mime type
      if (value.first.mimeType != 'text/plain') return;

      // GoRouter.of(context).go('/downloads/new');
      appRouter.push('/downloads/new', extra: value.first.path);
    });
    // appRouter.go('/downloads/new');
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
      ),
      routerConfig: appRouter,
    );
  }
}
