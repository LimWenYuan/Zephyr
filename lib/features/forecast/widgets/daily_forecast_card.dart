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
    final style = _aqiStyle(item.aqi);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: style.textColor,
            width: selected ? 3 : 2,
          ),
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
                color: style.textColor,
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
                color: style.textColor,
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

  _AqiVisualStyle _aqiStyle(int? aqi) {
    if (aqi == null) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFF3F4F6),
        textColor: AppColors.foreground,
      );
    }
    if (aqi <= 50) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFDCFCE7),
        textColor: Color(0xFF16A34A),
      );
    }
    if (aqi <= 100) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFFEF9C3),
        textColor: Color(0xFFCA8A04),
      );
    }
    if (aqi <= 150) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFFFEDD5),
        textColor: Color(0xFFF97316),
      );
    }
    if (aqi <= 200) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFFEE2E2),
        textColor: Color(0xFFDC2626),
      );
    }
    if (aqi <= 300) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFF3E8FF),
        textColor: Color(0xFF9333EA),
      );
    }
    return const _AqiVisualStyle(
      backgroundColor: Color(0xFFFECACA),
      textColor: Color(0xFF7F1D1D),
    );
  }
}

class _AqiVisualStyle {
  final Color backgroundColor;
  final Color textColor;

  const _AqiVisualStyle({
    required this.backgroundColor,
    required this.textColor,
  });
}