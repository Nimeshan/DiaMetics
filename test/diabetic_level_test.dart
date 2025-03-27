import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:diametics/Screens/DiabeticLevel.dart';
import 'dart:convert';

// Mock Classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockUser extends Mock implements User {}

void main() {
  group('DiabeticLevel Unit Tests', () {
    late SharedPreferences prefs;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseStorage mockFirebaseStorage;
    late MockUser mockUser;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // Mock Firebase
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseStorage = MockFirebaseStorage();
      mockUser = MockUser();

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    test('Sugar levels should load from SharedPreferences', () async {
      await prefs.setString('sugar_levels', '[100, 120, 140]');
      String? storedData = prefs.getString('sugar_levels');
      List<int> sugarLevels =
          storedData != null ? List<int>.from(json.decode(storedData)) : [];

      expect(sugarLevels, equals([100, 120, 140]));
    });

    test('Adding a sugar level should update the list and save it', () async {
      List<int> sugarLevels = [];
      int newSugarLevel = 110;

      sugarLevels.insert(0, newSugarLevel);
      if (sugarLevels.length > 14) {
        sugarLevels.removeLast();
      }

      await prefs.setString('sugar_levels', json.encode(sugarLevels));
      expect(sugarLevels.length, equals(1));
      expect(sugarLevels.first, equals(110));
    });
  });

  group('DiabeticLevel Widget Tests', () {
    testWidgets('UI should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DiabeticLevel(),
        ),
      );

      expect(find.text('Add Sugar Level'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Last 14 Days Sugar Levels:'), findsOneWidget);
    });

    testWidgets('Should add sugar level when button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DiabeticLevel(),
        ),
      );

      await tester.enterText(find.byType(TextField), '130');
      await tester.tap(find.text('Add Sugar Level'));
      await tester.pump();

      expect(find.text('Day 1: 130 mg/dl'), findsOneWidget);
    });
  });
}
