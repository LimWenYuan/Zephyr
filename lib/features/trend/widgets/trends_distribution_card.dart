import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/distribution_item.dart';

class TrendsDistributionCard extends StatelessWidget {
  final List<DistributionItem> items;

  const TrendsDistributionCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isNotEmpty
        ? items
        : const [
            DistributionItem(
              label: 'Good',
              count: 0,
              percentage: 0,
              color: Color(0xFF6BB8A8),
            ),
            DistributionItem(
              label: 'Moderate',
              count: 0,
              percentage: 0,
              color: Color(0xFF7EC4D5),
            ),
          ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Air Quality Distribution',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 24),
          ...displayItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: item.color,
                          ),
                        ),
                      ),
                      Text(
                        '${item.count} days (${item.percentage}%)',
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.foreground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0x4DE8F4F0),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: item.percentage / 100,
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}