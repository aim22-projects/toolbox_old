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
                title: Text("Permission"),
                dense: true,
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text("Storage"),
                trailing: const Icon(Icons.chevron_right),
                onTap: provider.getStoragePermission,
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notifications"),
                trailing: const Icon(Icons.chevron_right),
                onTap: provider.getNotificationPermission,
              ),
              const ListTile(
                title: Text("Preferences"),
                dense: true,
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Download Location"),
                subtitle: FutureBuilder(
                  initialData: '-',
                  future: provider.downloadLocation,
                  builder: (context, snapshot) {
                    return switch (snapshot.connectionState) {
                      ConnectionState.none => const Text("Initializing..."),
                      ConnectionState.waiting => const Text("Loading..."),
                      ConnectionState.done => snapshot.hasError
                          ? const Text("-")
                          : Text(snapshot.data ?? "-"),
                      _ => const Text("-"),
                    };
                  },
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: provider.pickDownloadLocation,
              ),
            ],
          ),
        );
      },
    );
  }
}
