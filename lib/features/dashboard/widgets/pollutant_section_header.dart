import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PollutantSectionHeader extends StatelessWidget {
  const PollutantSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.show_chart,
          size: 40,
          color: AppColors.primary,
        ),
        SizedBox(width: 12),
        Text(
          'Detailed Pollutant Levels',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground,
          ),
        ),
      ],
    );
  }
}