import 'package:flutter/material.dart';

class BottomMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;

  const BottomMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomMenuBar extends StatelessWidget {
  final List<BottomMenuItem> items;

  const BottomMenuBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...items.map((item) => BottomMenuItem(
              icon: item.icon,
              title: item.title,
              onTap: item.onTap,
            ))
      ],
    );
  }
}
