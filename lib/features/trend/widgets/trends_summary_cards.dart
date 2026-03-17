import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/trends_summary_data.dart';

class TrendsSummaryCards extends StatelessWidget {
  final List<TrendsSummaryData> items;

  const TrendsSummaryCards({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isNotEmpty ? items : const [
      TrendsSummaryData(
        title: 'Average AQI',
        valueText: '--',
        subtitle: '--',
        valueColor: AppColors.primary,
      ),
      TrendsSummaryData(
        title: 'Highest AQI',
        valueText: '--',
        subtitle: '--',
        valueColor: Color(0xFFEA580C),
      ),
      TrendsSummaryData(
        title: 'Lowest AQI',
        valueText: '--',
        subtitle: '--',
        valueColor: Color(0xFF16A34A),
      ),
      TrendsSummaryData(
        title: 'Unhealthy Days',
        valueText: '--',
        subtitle: '--',
        valueColor: Color(0xFFDC2626),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: List.generate(displayItems.length, (index) {
          final item = displayItems[index];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == displayItems.length - 1 ? 0 : 16),
              child: Container(
                padding: const EdgeInsets.all(20),
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
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.valueText,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: item.valueColor,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}