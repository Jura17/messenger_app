import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "T a v e r n \n C h a t",
      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }
}
