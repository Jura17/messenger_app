import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    required this.action,
    required this.foregroundColor,
    this.backgroundColor,
    this.fontWeight,
    this.wholeSurfaceTapable = false,
  });

  final String title;
  final Widget action;
  final Color foregroundColor;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final bool wholeSurfaceTapable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: wholeSurfaceTapable ? () => action : null,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: foregroundColor, fontWeight: fontWeight ?? FontWeight.normal),
            ),
            action
          ],
        ),
      ),
    );
  }
}
