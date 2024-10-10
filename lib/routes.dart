import 'package:go_router/go_router.dart';
import 'package:toolbox/screens/downloads.dart';
import 'package:toolbox/screens/new_download.dart';
import 'package:toolbox/screens/settings.dart';

class AppRouteNames {
  static const String root = "root";
  static const String home = "home";
  static const String downloads = "downloads";
  static const String newDownload = "new_download";
  static const String settings = "settings";
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: AppRouteNames.downloads,
      path: '/',
      builder: (context, state) => const DownloadsScreen(),
    ),
    GoRoute(
      name: AppRouteNames.newDownload,
      path: '/new',
      // builder: (context, state) => const DownloadsScreen(),
      builder: (context, state) {
        // print('data:${state.extra}');
        return NewDownloadScreen(
          downloadUrl: state.extra as String?,
        );
      },
    ),
    GoRoute(
      name: AppRouteNames.settings,
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
