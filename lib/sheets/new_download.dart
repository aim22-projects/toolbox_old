import 'package:flutter/material.dart';

class NewDownloadSheet extends StatelessWidget {
  const NewDownloadSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      builder: (context) => const NewDownloadSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              scrollPadding: EdgeInsets.only(),
              // controller: urlInputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                hintText: 'Download url',
                // label: Text('Download url'),
              ),
              autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}
