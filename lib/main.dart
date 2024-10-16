import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/app_theme.dart';
import 'package:toolbox/providers/theme.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/services/background_download_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundDownloadService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Toolbox',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
