import 'package:go_router/go_router.dart';
import 'package:toolbox/screens/downloads.dart';
import 'package:toolbox/screens/new_download.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'downloads',
      path: '/',
      builder: (context, state) => const DownloadsScreen(),
    ),
    GoRoute(
      name: 'new_download',
      path: '/downloads/new',
      // builder: (context, state) => const DownloadsScreen(),
      builder: (context, state) {
        // print('data:${state.extra}');
        return NewDownloadScreen(
          downloadUrl: state.extra as String?,
        );
      },
    ),
  ],
);
