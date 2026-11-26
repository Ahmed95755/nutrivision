import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MealInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onChanged;

  const MealInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Describe your meal', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.sm),

        TextField(
          controller: controller,
          readOnly: isLoading,
          onChanged: onChanged,
          maxLines: 5,
          maxLength: 500,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: 'e.g. 200g grilled chicken, rice and salad',
            hintStyle: AppTextStyles.caption,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        const Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 18, color: AppColors.primary),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Include quantities for better accuracy.',
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
