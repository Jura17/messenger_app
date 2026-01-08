class Userdata {
  final String uid;
  final String username;
  final String email;
  final int unreadCount;
  final String profileImage;

  Userdata({
    required this.uid,
    required this.email,
    required this.username,
    this.unreadCount = 0,
    this.profileImage = '',
  });

  factory Userdata.fromMap(Map<String, dynamic> map) {
    return Userdata(
      uid: map['uid'] as String,
      username: map['username'],
      email: map['email'] as String,
      profileImage: map['profileImage'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profileImage': profileImage,
    };
  }

  Userdata copyWith({int? unreadCount, String? profileImage}) {
    return Userdata(
      uid: uid,
      username: username,
      email: email,
      unreadCount: unreadCount ?? this.unreadCount,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
