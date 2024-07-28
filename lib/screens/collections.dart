import 'package:flutter/material.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      body: ListView.separated(
        itemCount: 4,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.facebook),
          title: const Text('http://google.com'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        separatorBuilder: (context, index) => const Divider(
          indent: 16,
          endIndent: 16,
          height: 1,
        ),
      ),
    );
  }
}
