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

  Widget inProcess(BuildContext context) {
    return ListTile(
      dense: true,
      selected: selected,
      onLongPress: onLongPress,
      // onTap: onTap,
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

  Widget completed(BuildContext context) {
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
          Text(downloadTask.fileSizeValue),
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

  @override
  Widget build(BuildContext context) {
    // if (downloadTask.downloadStatus == DownloadStatus.inProcess ||
    //     downloadTask.downloadStatus == DownloadStatus.loading) {
    //   return inProcess(context);
    // } else {
    //   return completed(context);
    // }
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).primaryColorLight,
          child: const Icon(Icons.movie),
        ),
        title: Text(
          downloadTask.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onTap: downloadTask.downloadStatus == DownloadStatus.inProcess ||
                downloadTask.downloadStatus == DownloadStatus.loading
            ? onTap
            : null,
        onLongPress: onLongPress,
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
        trailing: (downloadTask.downloadStatus == DownloadStatus.paused
            ? const Icon(Icons.pause)
            : null),
      ),
    );
  }
}
