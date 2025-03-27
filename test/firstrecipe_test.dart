import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diametics/Screens/FirstRecipe.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

void main() {
  group('FirstRecipe Screen - Unit & Widget Tests', () {
    // Unit Test: Used to Verify title and image
    testWidgets('FirstRecipe screen displays correct title and image',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: FirstRecipe()));

      // Checks if title exists
      expect(find.text('Diabetic Friendly Pizza'), findsOneWidget);

      // Checks if the recipe image is displayed
      expect(find.byType(Image), findsOneWidget);
    });

    // Widget Test: for Back button navigation
    testWidgets('Clicking Back button pops navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const FirstRecipe(),
            ),
          ),
        ),
      ));

      // Tap the back button
      await tester.tap(find.text("Back"));
      await tester.pumpAndSettle();

      // Verify that we navigated back or not
      expect(find.byType(FirstRecipe), findsNothing);
    });

    // Widget Test: Checks whether Clicking Hospital button navigates to HospitalLocator
    testWidgets('Clicking hospital icon navigates to HospitalLocator screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: FirstRecipe(),
      ));

      // Tap the hospital button
      await tester.tap(find.byIcon(Icons.local_hospital));
      await tester.pumpAndSettle();

      // Verify navigation to HospitalLocator
      expect(find.byType(HospitalLocator), findsOneWidget);
    });
  });
}
