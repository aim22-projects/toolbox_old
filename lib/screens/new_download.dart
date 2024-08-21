import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/extensions/file.dart';
import 'package:toolbox/providers/new_download.dart';

class NewDownloadScreen extends StatelessWidget {
  final String? downloadUrl;
  const NewDownloadScreen({super.key, this.downloadUrl});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewDownloadProvider>(
      create: (context) => NewDownloadProvider(
        context: context,
        downloadUrl: downloadUrl,
      ),
      child: const NewDownloadScreenContent(),
    );
  }
}

class NewDownloadScreenContent extends StatelessWidget {
  const NewDownloadScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewDownloadProvider>(
      builder: (context, newDownloadProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Download File'),
        ),
        body: Column(
          children: [
            if (newDownloadProvider.fileSize != null) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 26,
                  child: Icon(Icons.videocam),
                ),
              ),
              Center(
                child: Text(
                  "Size: ${getFileSizeString(bytes: newDownloadProvider.fileSize ?? 0)}",
                ),
              ),
            ],
            Card.filled(
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newDownloadProvider.urlInputController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.link),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      // filled: true,
                      hintText: 'Download url',
                      // label: Text('Download url'),
                      suffixIcon: !newDownloadProvider.isLoading
                          ? IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: newDownloadProvider.processUrl,
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            ),
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    enabled: !newDownloadProvider.isLoading,
                  ),
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  TextField(
                    controller: newDownloadProvider.fileNameInputController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      // filled: true,
                      hintText: 'File name',
                      // label: Text('File name'),
                    ),
                  ),
                  // const Divider(
                  //   height: 1,
                  //   indent: 16,
                  //   endIndent: 16,
                  // ),
                  // TextField(
                  //   controller:
                  //       newDownloadProvider.downloadLocationInputController,
                  //   decoration: const InputDecoration(
                  //     prefixIcon: Icon(Icons.folder),
                  //     border: OutlineInputBorder(borderSide: BorderSide.none),
                  //     // filled: true,
                  //     hintMaxLines: 1,
                  //     helperMaxLines: 1,
                  //     hintText: 'Download location',
                  //     // label: TextText('Download location'),
                  //   ),
                  // ),
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
                      onPressed: newDownloadProvider.addNewDownloadEvent,
                      child: const Text("Download"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
