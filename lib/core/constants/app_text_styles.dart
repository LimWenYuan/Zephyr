import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle appName = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.5,
  );

  static const TextStyle homeTitle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: AppColors.foreground,
    height: 1.25,
  );

  static const TextStyle homeDescription = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedForeground,
    height: 1.625,
  );

  static const TextStyle ctaText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.5,
  );

  static const TextStyle badgeCaption = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedForeground,
    height: 1.5,
  );

  static const TextStyle badgeTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.5,
  );

  static const TextStyle dialogTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.foreground,
  );

  static const TextStyle dialogBody = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedForeground,
    height: 1.5,
  );
}