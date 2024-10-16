import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/app_theme.dart';
import 'package:toolbox/extensions/file.dart';
import 'package:toolbox/providers/new_download.dart';

class NewDownloadDialog extends StatelessWidget {
  const NewDownloadDialog({super.key});

  static Future show(BuildContext context, String? downloadUrl) {
    return showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: cardOnDialogTheme(context),
          child: ChangeNotifierProvider<NewDownloadProvider>(
            create: (context) {
              return NewDownloadProvider(
                context: context,
                downloadUrl: downloadUrl,
              );
            },
            child: const NewDownloadDialog(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewDownloadProvider>(
      builder: (context, newDownloadProvider, child) {
        if (newDownloadProvider.fileName.isEmpty) {
          return _DownloadLoaderDialog();
        } else {
          return _DownloadSaverDialog();
        }
      },
    );
  }
}

class _DownloadLoaderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewDownloadProvider>(
        builder: (context, newDownloadProvider, child) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  "New Download",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Card.filled(
                margin: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (newDownloadProvider.fileName.isEmpty)
                      TextField(
                        controller: newDownloadProvider.urlInputController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.link),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
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
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                ),
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        enabled: !newDownloadProvider.isLoading,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _DownloadSaverDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewDownloadProvider>(
      builder: (context, newDownloadProvider, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    "New Download",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Card.filled(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (newDownloadProvider.fileName.isNotEmpty)
                        TextField(
                          autofocus: true,
                          controller:
                              newDownloadProvider.fileNameInputController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
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
                      ListTile(
                        title: const Text("File Size"),
                        trailing: Text(
                          getFileSizeString(
                              bytes: newDownloadProvider.fileSize ?? 0),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (newDownloadProvider.fileName.isNotEmpty)
                  Row(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
