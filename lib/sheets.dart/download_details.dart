import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toolbox/extensions/file.dart';
import 'package:toolbox/models/download.dart';

class DownloadDetailsSheet extends StatelessWidget {
  final Download download;
  final ScrollController scrollController;
  const DownloadDetailsSheet({
    super.key,
    required this.download,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // return CustomScrollView(
    //   controller: scrollController,
    //   shrinkWrap: true,
    //   slivers: [
    //     SliverToBoxAdapter(
    //       child: Center(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).hintColor,
    //             borderRadius: const BorderRadius.all(Radius.circular(10)),
    //           ),
    //           height: 4,
    //           width: 40,
    //           margin: const EdgeInsets.symmetric(vertical: 10),
    //         ),
    //       ),
    //     ),
    //     SliverAppBar(
    //       leading: IconButton(
    //         icon: const Icon(Icons.close),
    //         onPressed: GoRouter.of(context).pop,
    //       ),
    //       title: const Text(
    //         'Details',
    //       ),
    //       centerTitle: true,
    //     ),
    //     SliverList.list(children: [
    //       const Divider(
    //         height: 1,
    //         thickness: 1,
    //       ),
    //       ListTile(
    //         title: Text(
    //           'Name',
    //           style: Theme.of(context).textTheme.bodySmall,
    //         ),
    //         subtitle: Text(
    //           download.name,
    //           style: Theme.of(context).textTheme.bodyLarge,
    //         ),
    //       ),
    //       const Divider(
    //         height: 0,
    //         thickness: 0.5,
    //         indent: 16,
    //         endIndent: 16,
    //       ),
    //       ListTile(
    //         title: Text(
    //           'Time',
    //           style: Theme.of(context).textTheme.bodySmall,
    //         ),
    //         subtitle: Text(
    //           download.createdAt.toString(),
    //           style: Theme.of(context).textTheme.bodyLarge,
    //         ),
    //       ),
    //       const Divider(
    //         height: 0,
    //         thickness: 0.5,
    //         indent: 16,
    //         endIndent: 16,
    //       ),
    //       ListTile(
    //         title: Text(
    //           'Size',
    //           style: Theme.of(context).textTheme.bodySmall,
    //         ),
    //         subtitle: Text(
    //           download.fileSize == null
    //               ? '?'
    //               : getFileSizeString(bytes: download.fileSize ?? 0),
    //           style: Theme.of(context).textTheme.bodyLarge,
    //         ),
    //       ),
    //       const Divider(
    //         height: 0,
    //         thickness: 0.5,
    //         indent: 16,
    //         endIndent: 16,
    //       ),
    //       ListTile(
    //         title: Text(
    //           'Path',
    //           style: Theme.of(context).textTheme.bodySmall,
    //         ),
    //         subtitle: Text(
    //           download.downloadLocation,
    //           style: Theme.of(context).textTheme.bodyLarge,
    //         ),
    //       ),
    //       const Divider(
    //         height: 0,
    //         thickness: 0.5,
    //         indent: 16,
    //         endIndent: 16,
    //       ),
    //       ListTile(
    //         title: Text(
    //           'Url',
    //           style: Theme.of(context).textTheme.bodySmall,
    //         ),
    //         subtitle: Text(
    //           download.url,
    //           style: Theme.of(context).textTheme.bodyLarge,
    //         ),
    //       ),
    //     ])
    //   ],
    // );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: GoRouter.of(context).pop,
        ),
        title: const Text(
          'Details',
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        controller: scrollController,
        children: [
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            title: Text(
              'Name',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              download.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              'Time',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              download.createdAt.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              'Size',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              download.fileSize == null
                  ? '?'
                  : getFileSizeString(bytes: download.fileSize ?? 0),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              'Path',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              download.downloadLocation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Divider(
            height: 0,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
          ),
          ListTile(
            title: Text(
              'Url',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(
              download.url,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
