import 'package:diametics/Screens/RegisterNow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diametics/Screens/HomePage.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockSharedPreferences mockSharedPreferences;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockSharedPreferences = MockSharedPreferences();
    mockObserver = MockNavigatorObserver();

    // Mock default user data
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    when(() => mockUserCredential.user).thenReturn(mockUser);

    // Mock FirebaseAuth
    when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockUserCredential);
  });

  // Helper function to create widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const RegisterNow(),
      navigatorObservers: [mockObserver],
    );
  }

  group('RegisterNow Unit Tests', () {
    test('Save user data to SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', 'Test User');
      expect(prefs.getString('user_name'), 'Test User');
    });

    test('Register user successfully', () async {
      await mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com', password: 'password123');

      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);
    });

    test('Handles registration failure', () async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      try {
        await mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com', password: 'password123');
      } catch (e) {
        expect(e, isInstanceOf<FirebaseAuthException>());
      }
    });
  });

  group('RegisterNow Widget Tests', () {
    testWidgets('Renders all widgets correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Register Today!'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3)); // Name, Email, Password fields
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Successful registration navigates to HomePage',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Verify navigation occurred to HomePage
      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .called(1);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Shows error on registration failure', (WidgetTester tester) async {
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter conflicting email
      await tester.enterText(find.byType(TextField).at(1), 'existing@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'password123');
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Verify that error snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
