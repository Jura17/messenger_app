import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    this.action,
    this.onTap,
    this.currentValue,
  });

  final String title;
  final Widget? action;
  final Function()? onTap;
  final String? currentValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.inversePrimary),
            ),
            Spacer(),
            if (currentValue != null) Text(currentValue!),
            SizedBox(width: 10),
            action ??
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}
