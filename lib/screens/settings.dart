import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/providers/settings.dart';
import 'package:toolbox/providers/theme.dart';

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
                elevation: 0,
                child: Column(
                  children: [
                    FutureBuilder(
                      initialData: false,
                      future: provider.storagePermissionStatus,
                      builder: (context, snapshot) {
                        var value = switch (snapshot.connectionState) {
                          ConnectionState.done =>
                            snapshot.hasError ? false : snapshot.data ?? false,
                          _ => false,
                        };
                        return SwitchListTile(
                          secondary: const Icon(Icons.storage),
                          title: const Text("Storage"),
                          value: value,
                          onChanged: provider.getStoragePermission,
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                    FutureBuilder(
                      initialData: false,
                      future: provider.notificationPermissionStatus,
                      builder: (context, snapshot) {
                        var value = switch (snapshot.connectionState) {
                          ConnectionState.done =>
                            snapshot.hasError ? false : snapshot.data ?? false,
                          _ => false,
                        };
                        return SwitchListTile(
                          secondary: const Icon(Icons.notifications),
                          title: const Text("Notifications"),
                          value: value,
                          onChanged: provider.getNotificationPermission,
                        );
                      },
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
                elevation: 0,
                child: Column(
                  children: [
                    FutureBuilder(
                      initialData: '-',
                      future: provider.downloadLocation,
                      builder: (context, snapshot) {
                        var value = switch (snapshot.connectionState) {
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
                    ),
                    const Divider(
                      height: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                    Consumer<ThemeProvider>(
                      builder: (context, provider, child) => PopupMenuButton(
                        itemBuilder: (BuildContext context) => provider.themes
                            .map((item) => PopupMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onSelected: provider.setThemeValue,
                        child: ListTile(
                          leading: const Icon(Icons.contrast),
                          title: const Text("Theme"),
                          subtitle: Text(provider.themeValue),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
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
