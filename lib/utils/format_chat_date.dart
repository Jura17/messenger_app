import 'package:intl/intl.dart';

String formatChatDate(DateTime datetime) {
  final now = DateTime.now();
  final dateOnly = DateTime(datetime.year, datetime.month, datetime.day);
  final nowOnly = DateTime(now.year, now.month, now.day);

  final difference = nowOnly.difference(dateOnly).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  if (difference < 7) return DateFormat.EEEE().format(datetime);
  return DateFormat.MMMEd().format(datetime);
}
