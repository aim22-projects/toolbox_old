import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                border: OutlineInputBorder(),
                label: Text('Download url'),
              ),
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: fileNameInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('File name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: downloadLocationInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Download location'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
