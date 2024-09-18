import 'package:flutter/material.dart';
import 'package:toolbox/enums/download_status.dart';
import 'package:toolbox/models/download_task.dart';

class DownloadTile extends StatelessWidget {
  final DownloadTask downloadTask;
  final bool selected;
  final void Function()? onLongPress;
  final void Function()? onTap;

  const DownloadTile({
    super.key,
    this.onLongPress,
    this.onTap,
    required this.downloadTask,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      selected: selected,
      onLongPress: onLongPress,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
        child: const Icon(Icons.video_call),
      ),
      title: Text(
        downloadTask.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(getFileSizeString(bytes: downloadTask.fileSize ?? 0))
          Text(
              '${downloadTask.downloadedSizeValue} / ${downloadTask.fileSizeValue}'),
          Text("${downloadTask.progress}%"),
          // Text('1.2 MB/s'),
        ],
      ),
      trailing: (downloadTask.downloadStatus == DownloadStatus.paused
          ? const Icon(Icons.pause)
          : null),
      contentPadding: const EdgeInsetsDirectional.only(
        start: 16.0,
        end: 16.0,
      ),
    );
  }
}
