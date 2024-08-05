import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/providers/new_download.dart';

class NewDownload extends StatelessWidget {
  final String? downloadUrl;
  const NewDownload({super.key, this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewDownloadProvider>(
      create: (context) => NewDownloadProvider(
        context: context,
        downloadUrl: downloadUrl,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Download'),
        ),
        body: const NewDownloadForm(),
      ),
    );
  }
}

class NewDownloadForm extends StatelessWidget {
  const NewDownloadForm({super.key});

  void onchange() {
    print("hhhhhhheeeeee");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card.filled(
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Selector<NewDownloadProvider, bool>(
                selector: (_, provider) => provider.processingUrl,
                builder: (context, value, child) =>
                    value ? const LinearProgressIndicator() : Container(),
              ),
              Consumer<NewDownloadProvider>(
                builder: (context, newDownloadProvider, child) => TextField(
                  controller: newDownloadProvider.urlInputController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // filled: true,
                    hintText: 'Download url',
                    // label: Text('Download url'),
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  // maxLines: null,
                  onChanged: newDownloadProvider.processUrl,
                ),
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              Selector<NewDownloadProvider, TextEditingController>(
                selector: (_, provider) => provider.fileNameInputController,
                builder: (context, value, child) => TextField(
                  controller: value,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    // filled: true,
                    hintText: 'File name',
                    // label: Text('File name'),
                  ),
                ),
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              Selector<NewDownloadProvider, TextEditingController>(
                selector: (_, provider) =>
                    provider.downloadLocationInputController,
                builder: (context, value, child) => TextField(
                  controller: value,
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
              Selector<NewDownloadProvider, Future<void> Function()?>(
                selector: (_, provider) => provider.addNewDownloadEvent,
                builder: (context, value, child) => Expanded(
                  child: TextButton(
                    onPressed: value,
                    child: const Text("Download"),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
