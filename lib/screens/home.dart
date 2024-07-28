// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:toolbox/routes.dart';
// import 'package:toolbox/services/sharing_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   SharingService.instance.listen((value) {
  //     // 1. return if data is null
  //     if (value == null || value.isEmpty) return;

  //     if (kDebugMode) {
  //       print("data:");
  //       print((value.map((item) => item.toMap())));
  //     }

  //     // 2. check mime type
  //     if (value.first.mimeType != 'text/plain') return;

  //     if (kDebugMode) {
  //       print("url: ${value.first.path}");
  //     }
  //     // GoRouter.of(context).go('/downloads/new');
  //     appRouter.push('/downloads/new', extra: value.first.path);
  //   });
  //   // appRouter.go('/downloads/new');
  // }

  // @override
  // void dispose() {
  //   SharingService.instance.dispose();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
    );
  }
}
