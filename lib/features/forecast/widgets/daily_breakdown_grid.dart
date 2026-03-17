import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/daily_forecast_item.dart';
import 'daily_forecast_card.dart';

class DailyBreakdownGrid extends StatelessWidget {
  final List<DailyForecastItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DailyBreakdownGrid({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isNotEmpty ? items : _placeholders;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Breakdown',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 305,
            ),
            itemBuilder: (context, index) {
              return DailyForecastCard(
                item: displayItems[index],
                selected: selectedIndex == index,
                onTap: () => onSelected(index),
              );
            },
          ),
        ],
      ),
    );
  }

  static const _placeholders = [
    DailyForecastItem(),
    DailyForecastItem(),
    DailyForecastItem(),
    DailyForecastItem(),
    DailyForecastItem(),
    DailyForecastItem(),
    DailyForecastItem(),
  ];
}