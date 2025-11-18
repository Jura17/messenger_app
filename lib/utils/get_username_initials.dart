//
String? getUsernameInitials(String? username) {
  if (username == null) return null;

  List<String> initals = [];
  List<String> parts = username.split(' ');
  initals.add(parts[0][0]);
  if (parts.length > 1) initals.add(parts[parts.length - 1][0]);
  return initals.join('').toUpperCase();
}
