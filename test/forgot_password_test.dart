import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diametics/Screens/ForgotPassword.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();

    // Mock behavior for sending password reset email
    when(() =>
            mockFirebaseAuth.sendPasswordResetEmail(email: any(named: 'email')))
        .thenAnswer((_) async {});
  });

  // Helper function to create widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const ForgotPassword(),
    );
  }

  group('ForgotPassword Widget Tests', () {
    testWidgets('Renders all widgets correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify widgets are rendered correctly
      expect(find.text('Forgot Password'), findsOneWidget);
      expect(
          find.byType(TextField), findsOneWidget); // Only 1 email input field
      expect(find.text('Send Reset Link'), findsOneWidget);
    });

    testWidgets('Shows error if email field is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap on "Send Reset Link" button without entering email
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Verify that the error snack bar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Successfully sends password reset email',
        (WidgetTester tester) async {
      // Set up email input field
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), 'test@example.com');

      // Tap on "Send Reset Link" button
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Verify the password reset email was sent
      verify(() => mockFirebaseAuth.sendPasswordResetEmail(
          email: 'test@example.com')).called(1);

      // Verify that success message is shown
      expect(find.text('Password reset link sent! Check your email.'),
          findsOneWidget);
    });

    testWidgets('Handles password reset email error',
        (WidgetTester tester) async {
      // Simulate error in sending the password reset email
      when(() => mockFirebaseAuth.sendPasswordResetEmail(
              email: any(named: 'email')))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextField), 'test@example.com');

      // Tap on "Send Reset Link" button
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      // Verify error snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error: [user-not-found]'), findsOneWidget);
    });
  });
}
