import 'package:cloud_firestore/cloud_firestore.dart';

class Userdata {
  final String uid;
  final String username;
  final String email;
  final int unreadCount;
  final String profileImage;
  final DateTime createdAt;
  final DateTime lastSeen;

  Userdata({
    required this.uid,
    required this.email,
    required this.username,
    this.unreadCount = 0,
    this.profileImage = '',
    required this.createdAt,
    required this.lastSeen,
  });

  factory Userdata.fromMap(Map<String, dynamic> map) {
    return Userdata(
      uid: map['uid'] as String,
      username: map['username'],
      email: map['email'] as String,
      // TODO: check if unreadCount can be removed (bc it's handled by chatBloc)
      unreadCount: map['unreadCount'] ?? 0,
      profileImage: map['profileImage'] ?? '',
      /*
      - Firestore returns Timestamp, so we need to convert it 
      - using "as DateTime" does NOT convert anything, 
      - 'as DateTime' just tells Dart "Hey, this is a DateTime object, trust me..." even if it's not
      */
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastSeen: (map['lastSeen'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Userdata copyWith({int? unreadCount, String? profileImage, DateTime? lastSeen}) {
    return Userdata(
      uid: uid,
      username: username,
      email: email,
      unreadCount: unreadCount ?? this.unreadCount,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
