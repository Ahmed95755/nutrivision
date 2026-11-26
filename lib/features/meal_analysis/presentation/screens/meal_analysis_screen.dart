import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../data/models/meal_analysis_model.dart';
import '../../data/services/meal_analysis_service.dart';

import '../widgets/meal_input.dart';
import '../widgets/meal_image_picker.dart';
import '../widgets/nutrition_result_card.dart';

class MealAnalysisScreen extends StatefulWidget {
  const MealAnalysisScreen({super.key});

  @override
  State<MealAnalysisScreen> createState() => _MealAnalysisScreenState();
}

class _MealAnalysisScreenState extends State<MealAnalysisScreen> {
  final TextEditingController mealController = TextEditingController();

  final MealAnalysisService mealService = MealAnalysisService();

  final ImagePicker imagePicker = ImagePicker();

  Uint8List? imageBytes;

  MealAnalysisModel? result;

  bool isLoading = false;
  bool isPicking = false;

  String? errorMessage;

  Future<void> pickImage(ImageSource source) async {
    if (isLoading || isPicking) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isPicking = true;
      errorMessage = null;
    });

    try {
      final XFile? image = await imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (image == null || !mounted) return;

      final size = await image.length();

      if (size > 10 * 1024 * 1024) {
        if (!mounted) return;

        setState(() {
          errorMessage = 'Please select an image smaller than 10 MB.';
        });

        return;
      }

      final bytes = await image.readAsBytes();

      if (!mounted) return;

      if (bytes.isEmpty) {
        setState(() {
          errorMessage = 'The selected image is empty.';
        });
        return;
      }

      setState(() {
        imageBytes = bytes;
        result = null;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to open the camera or select an image.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isPicking = false;
        });
      }
    }
  }

  void removeImage() {
    setState(() {
      imageBytes = null;
      result = null;
      errorMessage = null;
    });
  }

  Future<void> analyzeMeal() async {
    if (isLoading || isPicking) return;

    final meal = mealController.text.trim();

    if (meal.isEmpty && imageBytes == null) {
      setState(() {
        errorMessage = 'Please select a photo or describe your meal.';
        result = null;
      });

      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      final analysis = await mealService.analyzeMeal(
        meal,
        imageBytes: imageBytes,
      );

      if (!mounted) return;

      setState(() {
        result = analysis;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Unable to analyze your meal. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void resetMeal() {
    mealController.clear();

    setState(() {
      imageBytes = null;
      result = null;
      errorMessage = null;
    });
  }

  void onMealChanged(String value) {
    if (result != null || errorMessage != null) {
      setState(() {
        result = null;
        errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    mealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text('Meal Analysis', style: AppTextStyles.heading),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),

                  const SizedBox(height: AppSpacing.lg),

                  MealImagePicker(
                    imageBytes: imageBytes,
                    isBusy: isLoading || isPicking,

                    onCamera: () {
                      pickImage(ImageSource.camera);
                    },

                    onGallery: () {
                      pickImage(ImageSource.gallery);
                    },

                    onRemove: removeImage,
                  ),

                  if (isPicking) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Center(
                      child: Text(
                        'Opening image picker...',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  const Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.border)),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          'OR / ADD DETAILS',
                          style: AppTextStyles.caption,
                        ),
                      ),

                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  MealInput(
                    controller: mealController,
                    isLoading: isLoading || isPicking,
                    onChanged: onMealChanged,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  const Text(
                    'Description is optional when a photo is selected.',
                    style: AppTextStyles.caption,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  buildAnalyzeButton(),

                  if (isLoading) ...[
                    const SizedBox(height: AppSpacing.lg),

                    const Center(
                      child: Text(
                        'Analyzing your meal...',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],

                  if (errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    buildErrorMessage(),
                  ],

                  if (result != null) ...[
                    const SizedBox(height: AppSpacing.lg),

                    NutritionResultCard(analysis: result!),

                    const SizedBox(height: AppSpacing.md),

                    buildResetButton(),
                  ],

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.document_scanner_outlined,
              size: 28,
              color: AppColors.surface,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          const Text('Scan Your Meal', style: AppTextStyles.heading),

          const SizedBox(height: AppSpacing.sm),

          const Text(
            'Take a photo or describe your meal to explore its nutrition.',
            style: AppTextStyles.body,
          ),

          const SizedBox(height: AppSpacing.md),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              'Nutrition Assistant - Demo',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,

      child: ElevatedButton.icon(
        onPressed: isLoading || isPicking ? null : analyzeMeal,

        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.auto_awesome),

        label: Text(
          isLoading ? 'Analyzing...' : 'Analyze Meal',
          style: AppTextStyles.button,
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.secondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResetButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,

      child: OutlinedButton.icon(
        onPressed: isLoading || isPicking ? null : resetMeal,

        icon: const Icon(Icons.refresh),

        label: const Text('Analyze Another Meal'),

        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
