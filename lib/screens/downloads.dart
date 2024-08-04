import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/providers/downloads.dart';
import 'package:toolbox/widgets/download_tile.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DownloadsProvider(context: context),
      builder: (context, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Downloads'),
        ),
        body: RefreshIndicator(
          onRefresh: context.read<DownloadsProvider>().init,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Card.filled(
                  margin: const EdgeInsets.all(8),
                  child: Selector<DownloadsProvider, List<Download>>(
                    selector: (context, provider) => provider.downloads,
                    builder: (context, value, child) => ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) => DownloadTile(
                        fileName: value[index].name,
                        downloadStatus: DownloadStatus.completed,
                      ),
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemCount: value.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton:
            Selector<DownloadsProvider, Future<void> Function()>(
          selector: (_, provider) => provider.goToNewDownloadScreen,
          builder: (context, value, child) => FloatingActionButton(
            onPressed: value,
            child: const Icon(Icons.add),
            // onPressed: () => NewDownloadSheet.show(context),
          ),
        ),
      ),
    );
  }
}
