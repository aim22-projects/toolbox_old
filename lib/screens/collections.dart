import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class CollectionsScreen extends StatelessWidget {
  final List<SharedMediaFile> sharedFiles;
  CollectionsScreen({super.key, required this.sharedFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            Text("Shared files:"),
            Text(sharedFiles
                .map((f) => f.toMap())
                .join(",\n****************\n")),
          ],
        ),
      ),
      // body: ListView.separated(
      //   itemCount: 4,
      //   itemBuilder: (context, index) => ListTile(
      //     leading: const Icon(Icons.facebook),
      //     title: const Text('http://google.com'),
      //     trailing: const Icon(Icons.chevron_right),
      //     onTap: () {},
      //   ),
      //   separatorBuilder: (context, index) => const Divider(
      //     indent: 16,
      //     endIndent: 16,
      //     height: 1,
      //   ),
      // ),
    );
  }
}
