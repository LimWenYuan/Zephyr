import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HomeLogoSection extends StatelessWidget {
  const HomeLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/zephyrlogo.jpeg',
          height: 72,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 18),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Zephyr',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1.0,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your Breath of Fresh Air',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColors.mutedForeground,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}