import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/dialogs/new_download.dart';
import 'package:toolbox/providers/downloads.dart';
import 'package:toolbox/routes.dart';
import 'package:toolbox/widgets/bottom_menu_bar.dart';
import 'package:toolbox/widgets/download_tile.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DownloadsProvider(context: context),
      builder: (context, child) => const DownloadsScreenContent(),
    );
  }
}

class DownloadsScreenContent extends StatelessWidget {
  const DownloadsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadsProvider>(
      builder: (context, downloadsProvider, child) => PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          downloadsProvider.hideMenu();
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Downloads'),
            actions: [
              IconButton(
                onPressed: () =>
                    GoRouter.of(context).pushNamed(AppRouteNames.settings),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Card(
              elevation: 0,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) => DownloadTile(
                  downloadTask: downloadsProvider.downloads[index],
                  selected: false,
                  onTap: () => downloadsProvider.openFile(
                    downloadsProvider.downloads[index],
                  ),
                  onLongPress: () => downloadsProvider
                      .showMenu(downloadsProvider.downloads[index]),
                  // onLongPress: () => DownloadDetailsSheet.show(
                  //   context,
                  //   downloadsProvider.downloads[index],
                  //   () async {
                  //     await downloadsProvider
                  //         .deleteTask(downloadsProvider.downloads[index]);
                  //     // ignore: use_build_context_synchronously
                  //     GoRouter.of(context).pop();
                  //   },
                  // ),
                ),
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 16,
                ),
                itemCount: downloadsProvider.downloads.length,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // onPressed: downloadsProvider.goToNewDownloadScreen,
            onPressed: () async {
              await NewDownloadDialog.show(context, null);
              await downloadsProvider.fetchRecords();
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomMenuBar(items: [
            const BottomMenuItem(
              icon: Icons.share,
              title: "Share",
            ),
            const BottomMenuItem(
              icon: Icons.edit,
              title: "Edit",
            ),
            BottomMenuItem(
              icon: Icons.info,
              title: "Info",
              onTap: downloadsProvider.showInfo,
            ),
            BottomMenuItem(
              icon: Icons.delete,
              title: "Delete",
              onTap: downloadsProvider.deleteSelectedTask,
            ),
            const BottomMenuItem(
              icon: Icons.more_vert,
              title: "More",
            ),
          ]),
        ),
      ),
    );
  }
}
