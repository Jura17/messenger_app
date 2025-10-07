class Userdata {
  final String uid;
  final String email;

  Userdata({
    required this.uid,
    required this.email,
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
}
