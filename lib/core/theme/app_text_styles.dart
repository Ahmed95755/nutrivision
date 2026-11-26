import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  static const heading = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.text);
  static const sectionTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text);
  static const body = TextStyle(fontSize: 14, color: AppColors.text);
  static const caption = TextStyle(fontSize: 12, color: AppColors.muted);
  static const button = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);
}
