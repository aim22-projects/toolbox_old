import 'package:flutter/material.dart';
import 'package:toolbox/models/download.dart';

class DownloadTile extends StatelessWidget {
  final String fileName;
  final DownloadStatus downloadStatus;

  const DownloadTile({
    super.key,
    required this.fileName,
    required this.downloadStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
        child: const Icon(Icons.video_call),
      ),
      title: Text(
        fileName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('10%'),
          Text('122 MB / 289 MB'),
          Text('1.2 MB/s'),
        ],
      ),
      trailing: (downloadStatus == DownloadStatus.paused
          ? const Icon(Icons.pause)
          : null),
      contentPadding: const EdgeInsetsDirectional.only(
        start: 16.0,
        end: 16.0,
      ),
      onTap: () => {},
    );
  }
}
