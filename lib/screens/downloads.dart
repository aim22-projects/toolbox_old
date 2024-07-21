import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        // titleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Share',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_square),
            label: 'Rename',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'More',
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Stack(
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: 0.5,
                    backgroundColor: Theme.of(context).canvasColor,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.video_call),
                )
              ],
            ),
            title: const Text('EP.2.v1.1080P.mp4'),
            subtitle: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('10%'),
                Text('122 MB / 289 MB'),
                Text('1.2 MB/s'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () => {},
              iconSize: 20,
            ),
            contentPadding:
                const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            indent: 60,
          ),
          ListTile(
            leading: Stack(
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: 0.5,
                    backgroundColor: Theme.of(context).canvasColor,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.video_call),
                )
              ],
            ),
            title: const Text('EP.2.v1.1080P.mp4'),
            subtitle: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('10%'),
                Text('124 MB / 289 MB'),
                Text('Paused'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => {},
              iconSize: 20,
            ),
            contentPadding:
                const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            indent: 60,
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.video_call),
            ),
            title: const Text('EP.2.v1.1080P.mp4'),
            subtitle: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('289 MB'),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.folder),
              onPressed: () => {},
              iconSize: 20,
            ),
            contentPadding:
                const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
          ),
        ],
      ),
    );
  }
}
