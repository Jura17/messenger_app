class Userdata {
  final String uid;
  final String email;
  final int unreadCount;

  Userdata({
    required this.uid,
    required this.email,
    this.unreadCount = 0,
  });

  factory Userdata.fromMap(Map<String, dynamic> map) {
    return Userdata(
      uid: map['uid'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  Userdata copyWith({int? unreadCount}) {
    return Userdata(
      uid: uid,
      email: email,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
