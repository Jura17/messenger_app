class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class RequiresRecentLoginException implements Exception {}

class InvalidCredentials implements Exception {}
