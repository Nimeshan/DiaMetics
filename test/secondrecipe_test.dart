import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diametics/Screens/SecondRecipe.dart';
import 'package:diametics/Screens/HospitalLocator.dart';

void main() {
  group('SecondRecipe Screen - Unit & Widget Tests', () {
    // Unit Test: Checks the title and image
    testWidgets('SecondRecipe screen displays correct title and image',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SecondRecipe()));

      // Verify the recipe title
      expect(find.text('Diabetic-Friendly Avocado Egg Salad'), findsOneWidget);

      // Verify the image is displayed
      expect(find.byType(Image), findsOneWidget);
    });

    // Widget Test: Checks Back button navigation
    testWidgets('Clicking Back button pops navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const SecondRecipe(),
            ),
          ),
        ),
      ));

      // Tap the back button
      await tester.tap(find.text("Back"));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.byType(SecondRecipe), findsNothing);
    });

    // Widget Test: Checks whether Clicking Hospital button navigates to HospitalLocator
    testWidgets('Clicking hospital icon navigates to HospitalLocator screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SecondRecipe(),
      ));

      // Tap the hospital button
      await tester.tap(find.byIcon(Icons.local_hospital));
      await tester.pumpAndSettle();

      // Verify navigation to HospitalLocator
      expect(find.byType(HospitalLocator), findsOneWidget);
    });
  });
}
