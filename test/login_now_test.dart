import 'package:diametics/Screens/LoginNow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diametics/Screens/ForgotPassword.dart';
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

  setUpAll(() {
    // Register fallback values
    registerFallbackValue(MaterialPageRoute(builder: (_) => const SizedBox()));
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockSharedPreferences = MockSharedPreferences();
    mockObserver = MockNavigatorObserver();

    // Setup default mock behaviors
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    when(() => mockUserCredential.user).thenReturn(mockUser);

    // Mock Firebase Authentication login success
    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockUserCredential);
  });

  // Helper function to create widget with mocks
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const LoginNow(),
      navigatorObservers: [mockObserver],
    );
  }

  group('LoginNow Widget Tests', () {
    testWidgets('Renders all widgets correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Login Now'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Navigates to ForgotPassword when link is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPush(any(), any()));
      expect(find.byType(ForgotPassword), findsOneWidget);
    });
  });

  group('LoginNow Functionality Tests', () {
    testWidgets('Successful login shows HomePage', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter test credentials
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Login'));

      // Wait for any async operations
      await tester.pumpAndSettle();

      // Verify navigation occurred (simulates a successful login)
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com', password: 'password123')).called(1);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Empty fields show validation', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Try to login without entering anything
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify error messages or UI feedback
      expect(find.text('Please enter email'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
    });
  });
}
