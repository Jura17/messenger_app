import 'package:intl/intl.dart';

String formatChatDate(DateTime datetime) {
  final now = DateTime.now();
  final difference = now.difference(datetime).inDays;
  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  if (difference < 7) return DateFormat.EEEE().format(datetime);
  return DateFormat.MMMEd().format(datetime);
}
