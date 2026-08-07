//
import 'package:flutter/widgets.dart';

// return up to 2 capital letters (first name and for the second name) for the given string input
String? getUsernameInitials(String? username) {
  if (username == null) return null;

  List<String> initials = [];
  // remove leading and trailing whitespace using trim() and remove any other whitespace character
  final parts = username.trim().split(RegExp(r'\s+'));

  debugPrint(parts.toString());
  // extract initials of first name
  parts.removeWhere((part) => part.isEmpty);
  if (parts.isEmpty) return null;
  initials.add(parts[0][0]);

  // if username is longer than one name extract the initials of the last name as well
  if (parts.length > 1) {
    if (parts[parts.length - 1].isNotEmpty) initials.add(parts[parts.length - 1][0]);
  }

  return initials.join('').toUpperCase();
}
