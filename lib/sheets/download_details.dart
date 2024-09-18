import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/extensions/file.dart';
import 'package:toolbox/models/download_task.dart';

class DownloadDetailsSheet extends StatelessWidget {
  final DownloadTask download;
  final void Function()? onDelete;
  const DownloadDetailsSheet({
    super.key,
    required this.download,
    required this.onDelete,
  });

  static void show(
    BuildContext context,
    DownloadTask downloadTask,
    void Function() onDelete,
  ) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      builder: (context) => DownloadDetailsSheet(
        download: downloadTask,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      snap: true,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Scaffold(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          body: CustomScrollView(
            controller: scrollController,
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: GoRouter.of(context).pop,
                ),
                title: const Text(
                  'Details',
                ),
                centerTitle: true,
                elevation: 1,
                pinned: true,
                floating: false,
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ElevatedButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete 1'),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: ElevatedButton.icon(
                          onPressed: GoRouter.of(context).pop,
                          icon: const Icon(Icons.close),
                          label: const Text('Close'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList.list(
                children: downloadDetails(context, download),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> downloadDetails(BuildContext context, DownloadTask download) {
  return <Widget>[
    const Divider(
      height: 1,
      thickness: 1,
    ),
    ListTile(
      title: Text(
        'Name',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        download.name,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onLongPress: () async {
        await FlutterClipboard.copy(download.name);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Text copied')));
      },
    ),
    const Divider(
      height: 0,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    ListTile(
      title: Text(
        'Time',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        download.createdAt.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
    const Divider(
      height: 0,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    ListTile(
      title: Text(
        'Size',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        download.fileSize == null
            ? '?'
            : getFileSizeString(bytes: download.fileSize ?? 0),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
    const Divider(
      height: 0,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    ListTile(
      title: Text(
        'Path',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        download.downloadLocation,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onLongPress: () async {
        await FlutterClipboard.copy(download.downloadLocation);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Text copied')));
      },
    ),
    const Divider(
      height: 0,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    ),
    ListTile(
      title: Text(
        'Url',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        download.url,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onLongPress: () async {
        await FlutterClipboard.copy(download.url);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Text copied')));
      },
    ),
  ];
}
