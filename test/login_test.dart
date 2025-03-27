import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diametics/Screens/Login.dart';
import 'package:diametics/Screens/RegisterNow.dart';
import 'package:diametics/Screens/LoginNow.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
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
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockSharedPreferences = MockSharedPreferences();
    mockObserver = MockNavigatorObserver();

    // Setup default mock behaviors for user
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.uid).thenReturn('123');
    when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
    when(() => mockUserCredential.user).thenReturn(mockUser);

    // Mock Firebase Authentication behavior
    when(() => mockFirebaseAuth.signInWithCredential(any()))
        .thenAnswer((_) async => mockUserCredential);

    // Mock Google Sign-In behavior
    when(() => mockGoogleSignIn.signIn())
        .thenAnswer((_) async => mockGoogleSignInAccount);
    when(() => mockGoogleSignInAccount.authentication)
        .thenAnswer((_) async => mockGoogleSignInAuthentication);
    when(() => mockGoogleSignInAuthentication.accessToken)
        .thenReturn('fake-access-token');
    when(() => mockGoogleSignInAuthentication.idToken)
        .thenReturn('fake-id-token');

    // Mock SharedPreferences behavior
    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
  });

  group('LoginPage Widget Tests', () {
    testWidgets('Renders all widgets correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('DiaMetics'), findsOneWidget);
      expect(find.text('Your Sugar Tracker'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Register Now'), findsOneWidget);
      expect(find.text('Already Registered'), findsOneWidget);
    });

    testWidgets('Navigates to RegisterNow when Register button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.text('Register Now'));
      await tester.pumpAndSettle();

      verify(() =>
              mockObserver.didPush(any(that: isA<MaterialPageRoute>()), any()))
          .called(1);
      expect(find.byType(RegisterNow), findsOneWidget);
    });

    testWidgets('Navigates to LoginNow when Already Registered is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.text('Already Registered'));
      await tester.pumpAndSettle();

      verify(() =>
              mockObserver.didPush(any(that: isA<MaterialPageRoute>()), any()))
          .called(1);
      expect(find.byType(LoginNow), findsOneWidget);
    });

    testWidgets('Triggers Google Sign-In when Sign in with Google is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
        ),
      );

      await tester.tap(find.text('Sign in with Google'));
      await tester.pump();

      verify(() => mockGoogleSignIn.signIn()).called(1);
      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
    });

    testWidgets('Shows error message when Google Sign-In fails',
        (WidgetTester tester) async {
      when(() => mockGoogleSignIn.signIn())
          .thenThrow(Exception('Google Sign-In failed'));

      await tester.pumpWidget(
        MaterialApp(
          home: const LoginPage(),
        ),
      );

      await tester.tap(find.text('Sign in with Google'));
      await tester.pump();

      expect(find.text("Sign-in failed"), findsOneWidget);
    });
  });
}
