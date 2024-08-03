import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen>
    with WidgetsBindingObserver {
  DownloadsRepository downloadsRepository = DownloadsRepository();

  List<Download> downloads = [];

  @override
  void initState() {
    init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      init();
    }
  }

  Future<void> init() async {
    // await Future<void>.delayed(const Duration(seconds: 3));

    // 1. fetch database values
    var result = await downloadsRepository.getDownloads();

    // 2. result
    setState(() => downloads = result ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Downloads'),
        // titleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.share),
      //       label: 'Share',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.edit_square),
      //       label: 'Rename',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.info),
      //       label: 'Details',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.delete),
      //       label: 'Delete',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.more_vert),
      //       label: 'More',
      //     ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: init,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          // physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
            leading: Stack(
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: 0.5,
                    backgroundColor: Theme.of(context).canvasColor,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.video_call),
                )
              ],
            ),
            title: Text(downloads[index].url),
            subtitle: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('10%'),
                Text('122 MB / 289 MB'),
                Text('1.2 MB/s'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () => {},
              iconSize: 20,
            ),
            contentPadding:
                const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: downloads.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await GoRouter.of(context).push('/downloads/new');
          init();
        },
        child: const Icon(Icons.add),
        // onPressed: () => NewDownloadSheet.show(context),
      ),
    );
  }
}
