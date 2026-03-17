import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TrendsHeaderSection extends StatelessWidget {
  const TrendsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                size: 32,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              Text(
                'Air Quality Trends & History',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                  height: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Understand patterns and seasonal trends in air pollution',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}