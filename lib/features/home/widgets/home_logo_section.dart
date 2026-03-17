import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeLogoSection extends StatelessWidget {
  const HomeLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          child: const Icon(
            Icons.air,
            size: 52,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          AppStrings.appName,
          style: AppTextStyles.appName,
        ),
      ],
    );
  }
}