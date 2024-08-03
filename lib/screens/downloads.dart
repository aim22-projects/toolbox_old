import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';
import 'package:toolbox/widgets/download_tile.dart';

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
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Card.filled(
                margin: const EdgeInsets.all(8),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) => DownloadTile(
                    fileName: downloads[index].name,
                    downloadStatus: DownloadStatus.completed,
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemCount: downloads.length,
                ),
              ),
            ),
          ],
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
