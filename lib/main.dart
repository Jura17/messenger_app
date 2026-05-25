import 'package:flutter/material.dart';
import 'package:messenger_app/app_bootstrap.dart';

// TODO: show chatrooms/conversations with actual contacts of current user
// TODO: add Search function to filter chat list by email address or username
void main() async {
  final app = await AppBootstrap.createProviders();
  runApp(app);
}
