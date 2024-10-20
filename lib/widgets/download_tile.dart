import 'package:flutter/material.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/download_task.dart';

class DownloadTile extends StatelessWidget {
  final DownloadTask downloadTask;
  final bool selected;
  final bool selectionButtonEnabled;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final void Function()? onSelectionChanged;

  const DownloadTile({
    super.key,
    this.onLongPress,
    this.onTap,
    required this.downloadTask,
    required this.selected,
    this.selectionButtonEnabled = false,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // if (downloadTask.downloadStatus == DownloadStatus.inProcess ||
    //     downloadTask.downloadStatus == DownloadStatus.loading) {
    //   return inProcess(context);
    // } else {
    //   return completed(context);
    // }
    return ListTile(
      dense: true,
      selected: selected,
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
        child: selected ? const Icon(Icons.check) : const Icon(Icons.movie),
      ),
      title: Text(
        downloadTask.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onTap: downloadTask.downloadStatus == DownloadStatus.inProcess ||
              downloadTask.downloadStatus == DownloadStatus.loading
          ? null
          : onTap,
      // trailing: Text("30 MB"),
      subtitle: downloadTask.downloadStatus == DownloadStatus.inProcess ||
              downloadTask.downloadStatus == DownloadStatus.loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  Text(
                      '${downloadTask.downloadedSizeValue} / ${downloadTask.fileSizeValue}'),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: downloadTask.progress / 100,
                  ),
                ],
              ],
            )
          : Text(downloadTask.fileSizeValue),
      // trailing: (downloadTask.downloadStatus == DownloadStatus.paused
      //     ? const Icon(Icons.pause)
      //     : null),

      trailing: !selectionButtonEnabled
          ? null
          : IconButton(
              onPressed: onSelectionChanged,
              icon: selected
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
            ),
    );
  }
}
