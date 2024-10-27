import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/dialogs/new_download.dart';
import 'package:toolbox/providers/downloads.dart';
import 'package:toolbox/routes.dart';
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
        canPop: false, // !downloadsProvider.isMenuVisible,
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          appBar: !downloadsProvider.isMenuVisible
              ? AppBar(
                  title: const Text('Downloads'),
                  actions: [
                    IconButton(
                      onPressed: () => GoRouter.of(context)
                          .pushNamed(AppRouteNames.settings),
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                )
              : AppBar(
                  leading: IconButton(
                    onPressed: downloadsProvider.hideMenu,
                    icon: const Icon(Icons.clear),
                  ),
                  title: const Text("1 Selected"),
                ),
          body: SingleChildScrollView(
            child: Card(
              elevation: 0,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) => DownloadTile(
                  downloadTask: downloadsProvider.downloads[index],
                  selectionButtonEnabled:
                      downloadsProvider.selectedDownloads.isNotEmpty,
                  selected: downloadsProvider.selectedDownloads.contains(index),
                  onTap: () {
                    downloadsProvider.openFile(
                      downloadsProvider.downloads[index],
                    );
                  },
                  onLongPress: () {
                    downloadsProvider.toggleSelection(index);
                  },
                  onSelectionChanged: () {
                    downloadsProvider.toggleSelection(index);
                  }, 
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
          bottomNavigationBar: !downloadsProvider.isMenuVisible
              ? null
              : BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.share),
                      label: 'Share',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.edit),
                      label: 'Edit',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.info),
                      label: 'Info',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.delete),
                      label: 'Delete',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.more_vert),
                      label: 'More',
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                  // currentIndex: 0,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black, //grey.shade700,
                  iconSize: 26,
                  onTap: (int value) {
                    switch (value) {
                      case 0: // share
                        break;
                      case 1: // edit
                        break;
                      case 2: // info
                        downloadsProvider.showInfo();
                        break;
                      case 3: // delete
                        downloadsProvider.confirmDeleteSelectedTask();
                        break;
                      case 4: // more
                        break;
                      default:
                        break;
                    }
                  },
                  elevation: 5,
                ),
        ),
      ),
    );
  }
}
