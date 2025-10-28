import 'package:messenger_app/features/chat/data/models/message.dart';

class MessageWithDateTimeMarker {
  final Message message;
  final bool showDate;
  final bool showTime;
  MessageWithDateTimeMarker({
    required this.message,
    required this.showDate,
    required this.showTime,
  });
}
