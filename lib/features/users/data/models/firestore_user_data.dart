import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserdata {
  final String uid;
  final String username;
  final String email;

  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isOnline;

  FirestoreUserdata({
    required this.uid,
    required this.email,
    required this.username,
    this.profileImageUrl = '',
    required this.createdAt,
    required this.lastSeen,
    this.isOnline = true,
  });

  factory FirestoreUserdata.fromMap(Map<String, dynamic> map) {
    return FirestoreUserdata(
      uid: map['uid'] as String,
      username: map['username'],
      email: map['email'] as String,
      profileImageUrl: map['profileImageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastSeen: (map['lastSeen'] as Timestamp).toDate(),
      isOnline: map['isOnline'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'lastSeen': Timestamp.fromDate(lastSeen),
      'createdAt': Timestamp.fromDate(createdAt),
      'isOnline': isOnline,
    };
  }

  FirestoreUserdata copyWith({String? profileImage, DateTime? lastSeen, bool? isOnline}) {
    return FirestoreUserdata(
      uid: uid,
      username: username,
      email: email,
      profileImageUrl: profileImage ?? profileImageUrl,
      createdAt: createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
