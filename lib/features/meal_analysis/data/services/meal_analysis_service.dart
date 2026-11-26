import 'dart:typed_data';

import '../models/meal_analysis_model.dart';

class MealAnalysisService {
  Future<MealAnalysisModel> analyzeMeal(
    String mealDescription, {
    Uint8List? imageBytes,
  }) async {
    final description = mealDescription.trim();

    final hasImage = imageBytes != null && imageBytes.isNotEmpty;

    if (description.isEmpty && !hasImage) {
      throw Exception('Please provide a meal description or image');
    }

    // Simulate an API request.
    await Future.delayed(const Duration(seconds: 2));

    // Temporary mock results.
    return MealAnalysisModel(
      mealDescription: description.isNotEmpty
          ? description
          : 'Meal photo - Demo analysis',
      calories: 520,
      protein: 42,
      carbs: 52,
      fat: 16,
    );
  }
}
