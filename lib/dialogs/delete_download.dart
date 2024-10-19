import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/app_theme.dart';
import 'package:toolbox/models/download_task.dart';

class DeleteDownloadDialog extends StatelessWidget {
  final DownloadTask? task;
  final Function()? onDelete;

  const DeleteDownloadDialog({super.key, this.task, this.onDelete});

  static Future show(
    BuildContext context,
    DownloadTask? task,
    final Function()? onDelete,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: cardOnDialogTheme(context),
          child: DeleteDownloadDialog(
            task: task,
            onDelete: onDelete,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                "Confirm Delete?",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(
                "Delete ${task?.name ?? "download"}?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
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
                    onPressed: onDelete,
                    child: const Text("Delete"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
