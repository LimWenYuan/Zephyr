import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeIntroText extends StatelessWidget {
  const HomeIntroText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.homeTitle,
          textAlign: TextAlign.left,
          style: AppTextStyles.homeTitle,
        ),
        SizedBox(height: 32),
        Text(
          AppStrings.homeDescription,
          textAlign: TextAlign.left,
          style: AppTextStyles.homeDescription,
        ),
      ],
    );
  }
}