import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download_task.dart';

class DownloadOptionsSheet extends StatelessWidget {
  final DownloadTask download;
  final void Function()? onDelete;
  const DownloadOptionsSheet({
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
      builder: (context) => DownloadOptionsSheet(
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
            ],
          ),
        ),
      ),
    );
  }
}
