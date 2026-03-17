import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/insight_item.dart';

class TrendsInsightsCard extends StatelessWidget {
  final List<InsightItem> items;

  const TrendsInsightsCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isNotEmpty ? items : const [
      InsightItem(
        title: 'Daily Pattern',
        body: 'Insights will appear when trend data is available.',
        borderColor: Color(0xFF3B82F6),
        backgroundColor: Color(0xFFEFF6FF),
        titleColor: Color(0xFF1E40AF),
        bodyColor: Color(0xFF1D4ED8),
      ),
      InsightItem(
        title: 'Weekly Pattern',
        body: 'Insights will appear when trend data is available.',
        borderColor: Color(0xFF22C55E),
        backgroundColor: Color(0xFFF0FDF4),
        titleColor: Color(0xFF166534),
        bodyColor: Color(0xFF15803D),
      ),
      InsightItem(
        title: 'Seasonal Consideration',
        body: 'Insights will appear when trend data is available.',
        borderColor: Color(0xFFF97316),
        backgroundColor: Color(0xFFFFF7ED),
        titleColor: Color(0xFF9A3412),
        bodyColor: Color(0xFFC2410C),
      ),
      InsightItem(
        title: 'Long-term Planning',
        body: 'Insights will appear when trend data is available.',
        borderColor: Color(0xFFA855F7),
        backgroundColor: Color(0xFFFAF5FF),
        titleColor: Color(0xFF6B21A8),
        bodyColor: Color(0xFF7E22CE),
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
          const Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                size: 28,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              Text(
                'Pattern Insights & Recommendations',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...displayItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border(
                    left: BorderSide(
                      color: item.borderColor,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: item.titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 18,
                        color: item.bodyColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}