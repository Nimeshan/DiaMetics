import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:diametics/Screens/Account.dart';
import 'package:diametics/Screens/HospitalLocator.dart';
import 'package:diametics/Screens/HamburgerMenu.dart';

// Create manual mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
  });

  group('Account Screen Tests', () {
    // Test default UI elements that don't depend on Firebase
    testWidgets('Basic UI elements render correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Account(),
        ),
      );

      // Verify basic UI components
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.local_hospital), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    // Test navigation to HospitalLocator
    testWidgets('Hospital icon navigates to HospitalLocator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Account(),
          routes: {
            '/hospital-locator': (context) => const HospitalLocator(),
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.local_hospital));
      await tester.pumpAndSettle();

      expect(find.byType(HospitalLocator), findsOneWidget);
    });

    // Test drawer opening (without testing drawer contents)
    testWidgets('Menu button opens drawer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Account(),
        ),
      );

      expect(find.byType(HamburgerMenu), findsNothing);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.byType(HamburgerMenu), findsOneWidget);
    });

    // Note: Testing Firebase-dependent functionality is limited without modifying the original file
    // We can only test the default states (guest user)
    testWidgets('Shows guest user when no user is logged in',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Account(),
        ),
      );

      expect(find.text('Guest User'), findsOneWidget);
      expect(find.text('No email found'), findsOneWidget);
    });
  });
}
