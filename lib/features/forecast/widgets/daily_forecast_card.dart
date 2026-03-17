import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/daily_forecast_item.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecastItem item;
  final bool selected;
  final VoidCallback onTap;

  const DailyForecastCard({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AppColors.primary
        : _categoryBorder(item.aqi);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              item.weekday ?? '--',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.dateLabel ?? '--',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.mutedForeground,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _circleColor(item.aqi),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  item.aqi?.toString() ?? '--',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              item.category ?? '--',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _circleColor(item.aqi),
                height: 1.3,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Temp',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                    height: 1.2,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Humidity',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.temperature ?? '--',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    height: 1.2,
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  item.humidity ?? '--',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryBorder(int? aqi) {
    if (aqi == null) return const Color(0xFF93C5FD);
    if (aqi <= 50) return const Color(0xFF86EFAC);
    if (aqi <= 100) return const Color(0xFF93C5FD);
    if (aqi <= 150) return const Color(0xFFF4C84F);
    if (aqi <= 200) return const Color(0xFFFDBA74);
    if (aqi <= 300) return const Color(0xFFE67E73);
    return const Color(0xFFC85A5A);
  }

  Color _circleColor(int? aqi) {
    if (aqi == null) return const Color(0xFF7EC4D5);
    if (aqi <= 50) return const Color(0xFF6BB8A8);
    if (aqi <= 100) return const Color(0xFF7EC4D5);
    if (aqi <= 150) return const Color(0xFFF4C84F);
    if (aqi <= 200) return const Color(0xFFF89C4F);
    if (aqi <= 300) return const Color(0xFFE67E73);
    return const Color(0xFFC85A5A);
  }
}