import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/utils/validators.dart';

void main() {
  group('Email validation', () {
    test('Valid emails pass', () {
      expect(Validators.isValidEmail('test@example.com'), true);
      expect(Validators.isValidEmail('user.name@domain.co.uk'), true);
    });

    test('Invalid emails fail', () {
      expect(Validators.isValidEmail('a@'), false);
      expect(Validators.isValidEmail('@b'), false);
      expect(Validators.isValidEmail('invalid.com'), false);
    });
  });

  group('Password validation', () {
    test('Strong passwords pass', () {
      expect(Validators.isValidPassword('Aa1!abcd'), true);
    });

    test('Weak passwords fail', () {
      expect(Validators.isValidPassword('abc'), false);
      expect(Validators.isValidPassword('password123'), false);
      expect(Validators.isValidPassword('ABC!@#'), false);
    });
  });
}
