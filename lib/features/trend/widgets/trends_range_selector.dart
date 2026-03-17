import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TrendsRangeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TrendsRangeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Last 7 Days',
      'Last 30 Days',
      'Last 90 Days',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 12),
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: isActive
                      ? null
                      : Border.all(
                          color: AppColors.borderPrimary20,
                          width: 2,
                        ),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColors.white : AppColors.foreground,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}