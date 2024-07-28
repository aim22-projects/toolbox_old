import 'package:flutter/material.dart';

class NewDownload extends StatefulWidget {
  final String? downloadUrl;
  const NewDownload({super.key, this.downloadUrl});

  @override
  State<NewDownload> createState() => _NewDownloadState();
}

class _NewDownloadState extends State<NewDownload> {
  String? downloadUrl = '';
  @override
  void initState() {
    setState(() {
      downloadUrl = widget.downloadUrl;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Download'),
      ),
      body: Row(
        children: [Text(downloadUrl ?? 'url')],
      ),
    );
  }
}
