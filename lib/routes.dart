import 'package:go_router/go_router.dart';
import 'package:toolbox/screens/downloads.dart';
import 'package:toolbox/screens/home.dart';
import 'package:toolbox/screens/new_download.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    name: 'home',
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    name: 'downloads',
    path: '/downloads',
    builder: (context, state) => const DownloadsScreen(),
  ),
  GoRoute(
    name: 'new_download',
    path: '/downloads/new',
    // builder: (context, state) => const DownloadsScreen(),
    builder: (context, state) {
      // print('data:${state.extra}');
      return NewDownload(
        downloadUrl: state.extra as String?,
      );
    },
  ),
]);
