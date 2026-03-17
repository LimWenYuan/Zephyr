import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HealthHeaderCard extends StatelessWidget {
  const HealthHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 48),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.borderPrimary20,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 48,
                color: Color(0xFFEF4444),
              ),
              SizedBox(width: 16),
              Text(
                'Health Advice & Safety Tips',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 64),
            child: Text(
              'Protect your health and stay safe during varying air quality conditions',
              style: TextStyle(
                fontSize: 24,
                color: AppColors.mutedForeground,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}