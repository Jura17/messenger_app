import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/utils/get_username_initials.dart';

void main() {
  group('Test different string inputs', () {
    test('return one capital letter for one name', () {
      final initials = getUsernameInitials('Julian');
      expect(initials, 'J');
    });

    test('return first capital letter for first name and second letter for the name at last position', () {
      final initials = getUsernameInitials('Piet de Vries');
      expect(initials, 'PV');
    });

    test('return two capital letters and ignore leading and trailing whitespace', () {
      final initials = getUsernameInitials(' Julian        Rakow  ');
      expect(initials, 'JR');
    });

    test('return two capital letters for multiple names', () {
      final initials = getUsernameInitials(' Achmed van Bobsen ');
      expect(initials, 'AB');
    });

    test('return two capital letters for multiple names including hyphen', () {
      final initials = getUsernameInitials('Jean-Paul Sartre');
      expect(initials, 'JS');
    });
    test('ignore mixed whitespace characters', () {
      final initials = getUsernameInitials('  Julian \t  Rakow\n');
      expect(initials, 'JR');
    });

    test('ignore mixed whitespace characters', () {
      final initials = getUsernameInitials('Bob');
      expect(initials, 'B');
    });

    test('return null if input is empty or whitespace', () {
      final initials = getUsernameInitials(' ');
      expect(initials, null);
    });
  });
}
