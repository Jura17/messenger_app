import 'package:flutter/material.dart';
import 'package:messenger_app/app_bootstrap.dart';

void main() async {
  final app = await AppBootstrap.createProviders();
  runApp(app);
}
