import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class HealthBadgeCard extends StatelessWidget {
  const HealthBadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.badgePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.badgeRadius),
        border: Border.all(
          color: AppColors.borderPrimary20,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 40,
            color: AppColors.primary,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.badgeTop,
                style: AppTextStyles.badgeCaption,
              ),
              SizedBox(height: 4),
              Text(
                AppStrings.badgeBottom,
                style: AppTextStyles.badgeTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}