import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../data/models/meal_analysis_model.dart';

class NutritionResultCard extends StatelessWidget {
  final MealAnalysisModel analysis;

  const NutritionResultCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nutrition Results', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.sm),

        const Text(
          'Demo results - not a real nutritional analysis.',
          style: AppTextStyles.caption,
        ),

        const SizedBox(height: AppSpacing.md),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sample Total Calories',
                style: TextStyle(color: AppColors.lightGreen, fontSize: 14),
              ),

              const SizedBox(height: AppSpacing.sm),

              Row(
                children: [
                  Text(
                    '${analysis.calories}',
                    style: const TextStyle(
                      color: AppColors.surface,
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.sm),

                  const Text(
                    'kcal',
                    style: TextStyle(color: AppColors.lightGreen, fontSize: 16),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.accent,
                    size: 44,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                analysis.mealDescription,
                style: const TextStyle(
                  color: AppColors.lightGreen,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: nutritionItem(
                'Protein',
                '${analysis.protein}g',
                Icons.fitness_center,
                AppColors.primary,
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: nutritionItem(
                'Carbs',
                '${analysis.carbs}g',
                Icons.grain,
                AppColors.secondary,
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: nutritionItem(
                'Fat',
                '${analysis.fat}g',
                Icons.water_drop_outlined,
                AppColors.accent,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Energy Distribution',
                style: AppTextStyles.sectionTitle,
              ),

              const SizedBox(height: AppSpacing.md),

              buildNutritionBar(),

              const SizedBox(height: AppSpacing.md),

              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  legend('Protein', AppColors.primary),
                  legend('Carbs', AppColors.secondary),
                  legend('Fat', AppColors.accent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget nutritionItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),

          const SizedBox(height: AppSpacing.md),

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(title, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget buildNutritionBar() {
    final proteinEnergy = analysis.protein * 4;
    final carbsEnergy = analysis.carbs * 4;
    final fatEnergy = analysis.fat * 9;

    final total = proteinEnergy + carbsEnergy + fatEnergy;

    if (total <= 0) {
      return Container(
        height: 12,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          if (proteinEnergy > 0)
            Expanded(
              flex: proteinEnergy,
              child: Container(height: 12, color: AppColors.primary),
            ),

          if (carbsEnergy > 0)
            Expanded(
              flex: carbsEnergy,
              child: Container(height: 12, color: AppColors.secondary),
            ),

          if (fatEnergy > 0)
            Expanded(
              flex: fatEnergy,
              child: Container(height: 12, color: AppColors.accent),
            ),
        ],
      ),
    );
  }

  Widget legend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: AppSpacing.sm),

        Text(title, style: AppTextStyles.caption),
      ],
    );
  }
}
