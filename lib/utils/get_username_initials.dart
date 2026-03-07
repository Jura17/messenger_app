//
String? getUsernameInitials(String? username) {
  if (username == null) return null;

  List<String> initals = [];
  List<String> parts = username.split(' ');
  // extract initials of first name
  initals.add(parts[0][0]);

  // if username is longer than one name extract the initials of the last name as well
  if (parts.length > 1) {
    initals.add(parts[parts.length - 1][0]);
  }

  return initals.join('').toUpperCase();
}
