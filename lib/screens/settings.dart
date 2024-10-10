import 'package:flutter/material.dart';
import 'package:toolbox/services/notification_service.dart';
import 'package:toolbox/services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () async {
              await StorageService.requestPermission();
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await NotificationService.requestPermission();
              await NotificationService.init();
            },
          ),
        ],
      ),
    );
  }
}
