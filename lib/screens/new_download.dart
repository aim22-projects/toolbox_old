import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/models/download.dart';
import 'package:toolbox/repositories/database/downloads.dart';

class NewDownload extends StatefulWidget {
  final String? downloadUrl;
  const NewDownload({super.key, this.downloadUrl});

  @override
  State<NewDownload> createState() => _NewDownloadState();
}

class _NewDownloadState extends State<NewDownload> {
  final urlInputController = TextEditingController();
  final fileNameInputController = TextEditingController();
  final downloadLocationInputController = TextEditingController();
  String? downloadUrl = '';

  DownloadsRepository downloadsRepository = DownloadsRepository();

  @override
  void initState() {
    urlInputController.text = widget.downloadUrl ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Download'),
      ),
      body: Column(
        children: [
          Card.filled(
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: urlInputController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // filled: true,
                    hintText: 'Download url',
                    // label: Text('Download url'),
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                TextField(
                  controller: fileNameInputController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // filled: true,
                    hintText: 'File name',
                    // label: Text('File name'),
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                TextField(
                  controller: downloadLocationInputController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.folder),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // filled: true,
                    hintMaxLines: 1,
                    helperMaxLines: 1,
                    hintText: 'Download location',
                    // label: TextText('Download location'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => GoRouter.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      var result = await downloadsRepository.insertDownload(
                        Download(
                            url: urlInputController.text,
                            name: fileNameInputController.text,
                            location: downloadLocationInputController.text,
                            createdAt: '',
                            downloadStatus: DownloadStatus.completed),
                      );
                      // ignore: use_build_context_synchronously
                      GoRouter.of(context).pop();
                      // if (result)
                    },
                    child: const Text("Download"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
