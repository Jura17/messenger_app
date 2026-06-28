class AppUserData {
  final String uid;
  final String username;
  final String email;

  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isOnline;

  AppUserData({
    required this.uid,
    required this.email,
    required this.username,
    this.profileImageUrl = '',
    required this.createdAt,
    required this.lastSeen,
    this.isOnline = true,
  });
}
