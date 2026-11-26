import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/features/meal_analysis/data/services/meal_analysis_service.dart';
import '../lib/features/meal_analysis/presentation/screens/meal_analysis_screen.dart';
import '../lib/features/meal_analysis/presentation/widgets/meal_image_picker.dart';

void main() {
  group('Meal Analysis Service Tests', () {
    test('Reject empty input', () async {
      final service = MealAnalysisService();

      await expectLater(service.analyzeMeal('   '), throwsException);
    });

    test('Analyze meal using text only', () async {
      final service = MealAnalysisService();

      final result = await service.analyzeMeal('Chicken and rice');

      expect(result.mealDescription, 'Chicken and rice');
      expect(result.calories, 520);
      expect(result.protein, 42);
      expect(result.carbs, 52);
      expect(result.fat, 16);
    });

    test('Analyze meal using image only', () async {
      final service = MealAnalysisService();

      final imageBytes = Uint8List.fromList([1, 2, 3]);

      final result = await service.analyzeMeal('', imageBytes: imageBytes);

      expect(result.mealDescription, 'Meal photo - Demo analysis');
      expect(result.calories, 520);
    });

    test('Analyze meal using image and text', () async {
      final service = MealAnalysisService();

      final imageBytes = Uint8List.fromList([1, 2, 3]);

      final result = await service.analyzeMeal(
        'Grilled chicken',
        imageBytes: imageBytes,
      );

      expect(result.mealDescription, 'Grilled chicken');
      expect(result.calories, 520);
    });

    test('Reject empty image without description', () async {
      final service = MealAnalysisService();

      await expectLater(
        service.analyzeMeal('', imageBytes: Uint8List(0)),
        throwsException,
      );
    });
  });

  group('Meal Analysis Screen Tests', () {
    testWidgets('Display main screen elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MealAnalysisScreen()));

      expect(find.text('Meal Analysis'), findsOneWidget);
      expect(find.text('Scan Your Meal'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Analyze Meal'), findsOneWidget);
    });

    testWidgets('Show validation error for empty input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MealAnalysisScreen()));

      await tester.ensureVisible(find.text('Analyze Meal'));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Analyze Meal'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please select a photo or describe your meal.'),
        findsOneWidget,
      );
    });

    testWidgets('Analyze meal and reset results', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MealAnalysisScreen()));

      await tester.ensureVisible(find.byType(TextField));

      await tester.enterText(find.byType(TextField), '200g chicken and rice');

      await tester.ensureVisible(find.text('Analyze Meal'));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Analyze Meal'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      await tester.pumpAndSettle();

      expect(find.text('Nutrition Results'), findsOneWidget);

      expect(find.text('520'), findsOneWidget);
      expect(find.text('42g'), findsOneWidget);
      expect(find.text('52g'), findsOneWidget);
      expect(find.text('16g'), findsOneWidget);

      await tester.ensureVisible(find.text('Analyze Another Meal'));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Analyze Another Meal'));

      await tester.pumpAndSettle();

      expect(find.text('Nutrition Results'), findsNothing);

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.controller!.text, isEmpty);
      expect(find.byType(MealImagePicker), findsOneWidget);
    });
  });
}
