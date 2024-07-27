import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:toolbox/screens/collections.dart';
import 'package:toolbox/services/sharing_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();

    SharingService.instance.listen((value) {
      // 1. return if data is null
      if (value == null || value.isEmpty) return;

      // 2. check mime type
      if (value.first.mimeType != 'text/plain') return;

      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
      });
    });
  }

  @override
  void dispose() {
    SharingService.instance.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: CollectionsScreen(
        sharedFiles: _sharedFiles,
      ),
    );
  }
}
