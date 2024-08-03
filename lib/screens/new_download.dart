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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: urlInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                hintText: 'Download url',
                // label: Text('Download url'),
              ),
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: fileNameInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                hintText: 'File name',
                // label: Text('File name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: downloadLocationInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                hintText: 'Download location',
                // label: TextText('Download location'),
              ),
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
                        ),
                      );
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
