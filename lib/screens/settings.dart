import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/providers/settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      builder: (context, child) => const SettingsScreenContent(),
    );
  }
}

class SettingsScreenContent extends StatelessWidget {
  const SettingsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
          ),
          body: ListView(
            children: [
              const ListTile(
                title: Text("Permissions"),
                dense: true,
                minTileHeight: 0,
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.storage),
                      title: const Text("Storage"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: provider.getStoragePermission,
                    ),
                    const Divider(
                      height: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text("Notifications"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: provider.getNotificationPermission,
                    ),
                  ],
                ),
              ),
              const ListTile(
                title: Text("Preferences"),
                dense: true,
                minTileHeight: 0,
              ),
              Card(
                child: Column(
                  children: [
                    FutureBuilder(
                      initialData: '-',
                      future: provider.downloadLocation,
                      builder: (context, snapshot) {
                        var value = switch (snapshot.connectionState) {
                          ConnectionState.none => "Initializing...",
                          ConnectionState.waiting => "Loading...",
                          ConnectionState.done =>
                            snapshot.hasError ? "-" : snapshot.data ?? "-",
                          _ => "-",
                        };
                        return ListTile(
                          leading: const Icon(Icons.folder),
                          title: const Text("Download Location"),
                          subtitle: Text(value),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: provider.pickDownloadLocation,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
