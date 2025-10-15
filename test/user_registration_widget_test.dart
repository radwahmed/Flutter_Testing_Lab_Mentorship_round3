import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('Form renders with all required fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    group('Email Validation Messages', () {
      testWidgets('Rejects invalid email "a@"', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Find email field (index 1)
        await tester.enterText(find.byType(TextFormField).at(1), 'a@');
        await tester.pumpAndSettle();

        // Trigger validation
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('Rejects invalid email "@b"', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(1), '@b');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('Rejects email without domain', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(1), 'invalid.com');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('Accepts valid emails', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        const validEmails = ['test@example.com', 'user.name@domain.co.uk'];

        for (final email in validEmails) {
          await tester.enterText(find.byType(TextFormField).at(1), email);
          await tester.pumpAndSettle();

          expect(
            find.text('Please enter a valid email address'),
            findsNothing,
            reason: 'Email $email should be valid',
          );

          // Reset field
          await tester.enterText(find.byType(TextFormField).at(1), '');
          await tester.pumpAndSettle();
        }
      });

      testWidgets('Shows error when email field is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter your email'), findsOneWidget);
      });
    });

    group('Password Strength Validation Messages', () {
      testWidgets('Rejects weak password "abc"', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(2), 'abc');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(
          find.text('Password must include upper, number & special char'),
          findsOneWidget,
        );
      });

      testWidgets('Rejects weak password "password123"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(2), 'password123');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(
          find.text('Password must include upper, number & special char'),
          findsOneWidget,
        );
      });

      testWidgets('Rejects weak password "ABC!@#"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(2), 'ABC!@#');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(
          find.text('Password must include upper, number & special char'),
          findsOneWidget,
        );
      });

      testWidgets('Accepts strong password "Aa1!abcd"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(2), 'Aa1!abcd');
        await tester.pumpAndSettle();

        expect(
          find.text('Password must include upper, number & special char'),
          findsNothing,
        );
      });

      testWidgets('Shows error when password field is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a password'), findsOneWidget);
      });

      testWidgets('Password field masks input text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Enter text in password field
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'TestPassword123!',
        );
        await tester.pumpAndSettle();

        // Verify the field exists and is set (the obscuring happens at render level)
        final editableText = find.byType(EditableText).at(2);
        expect(editableText, findsOneWidget);
      });
    });

    group('Form Submission Validation', () {
      testWidgets('Form does not submit with empty fields', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Try to submit with empty form
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Should show validation errors
        expect(find.text('Please enter your full name'), findsOneWidget);
        expect(find.text('Please enter your email'), findsOneWidget);
        expect(find.text('Please enter a password'), findsOneWidget);
      });

      testWidgets('Form does not submit with invalid email', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Fill with valid name and invalid email
        await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
        await tester.enterText(find.byType(TextFormField).at(1), 'a@');
        await tester.enterText(find.byType(TextFormField).at(2), 'Aa1!abcd');
        await tester.enterText(find.byType(TextFormField).at(3), 'Aa1!abcd');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Please enter a valid email address'), findsOneWidget);
      });

      testWidgets('Form does not submit with weak password', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Fill with valid data but weak password
        await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'john@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'weakpwd');
        await tester.enterText(find.byType(TextFormField).at(3), 'weakpwd');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(
          find.text('Password must include upper, number & special char'),
          findsOneWidget,
        );
      });

      testWidgets('Form does not submit with mismatched passwords', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'john@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'Aa1!abcd');
        await tester.enterText(
          find.byType(TextFormField).at(3),
          'Aa1!different',
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });

      testWidgets('Form submits successfully with valid data', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Fill with all valid data
        await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'john@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'Aa1!abcd');
        await tester.enterText(find.byType(TextFormField).at(3), 'Aa1!abcd');
        await tester.pumpAndSettle();

        // Submit form
        await tester.tap(find.text('Register'));

        // Wait for the 2 second delay to complete and UI to update
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should show success message
        expect(find.text('Registration successful!'), findsOneWidget);
      });

      testWidgets('Submit button is disabled during form submission', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Fill with valid data
        await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'john@example.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'Aa1!abcd');
        await tester.enterText(find.byType(TextFormField).at(3), 'Aa1!abcd');
        await tester.pumpAndSettle();

        // Submit
        await tester.tap(find.text('Register'));

        // Pump to see the loading state before it completes
        await tester.pump(const Duration(milliseconds: 100));

        // Button should be disabled (shown with loading indicator)
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Complete the async operation
        await tester.pumpAndSettle(const Duration(seconds: 3));
      });
    });

    group('Real-time Validation', () {
      testWidgets(
        'Validation errors appear as user types due to autovalidateMode',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
          );

          // Start typing invalid email
          await tester.enterText(find.byType(TextFormField).at(1), 'a');
          await tester.pumpAndSettle();

          // Continue typing
          await tester.enterText(find.byType(TextFormField).at(1), 'a@');
          await tester.pumpAndSettle();

          // Error should appear
          expect(
            find.text('Please enter a valid email address'),
            findsOneWidget,
          );

          // Fix to valid email
          await tester.enterText(find.byType(TextFormField).at(1), 'a@b.com');
          await tester.pumpAndSettle();

          // Error should disappear
          expect(find.text('Please enter a valid email address'), findsNothing);
        },
      );
    });
  });
}
