import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/providers/downloads.dart';
import 'package:toolbox/sheets/download_details.dart';
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
      builder: (context, downloadsProvider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Downloads'),
        ),
        body: RefreshIndicator(
          onRefresh: downloadsProvider.init,
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
                      fileName: downloadsProvider.downloads[index].name,
                      downloadStatus: DownloadStatus.completed,
                      onLongPress: () => downloadsProvider.showDownloadDetails(
                          downloadsProvider.downloads[index]),
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemCount: downloadsProvider.downloads.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: downloadsProvider.goToNewDownloadScreen,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
