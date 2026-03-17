import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/daily_forecast_item.dart';

class DetailedForecastCard extends StatelessWidget {
  final DailyForecastItem item;

  const DetailedForecastCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(item.aqi);

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
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 28,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Detailed Forecast for ${item.weekday ?? '--'}, ${item.dateLabel ?? '--'}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.foreground,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: categoryColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item.aqi?.toString() ?? '--',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.category ?? '--',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _InfoBox(
                      label: 'Air Quality Category',
                      value: item.category ?? '--',
                      valueColor: categoryColor,
                    ),
                    const SizedBox(height: 16),
                    _InfoBox(
                      label: 'Temperature',
                      value: item.temperature ?? '--',
                    ),
                    const SizedBox(height: 16),
                    _InfoBox(
                      label: 'Humidity',
                      value: item.humidity ?? '--',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0x33A8D5E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity Recommendation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: AppColors.foreground,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 22,
                        color: Color(0xFFEA580C),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Recommendation will appear when forecast data is available.',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.foreground,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _categoryColor(int? aqi) {
    if (aqi == null) return const Color(0xFF7EC4D5);
    if (aqi <= 50) return const Color(0xFF6BB8A8);
    if (aqi <= 100) return const Color(0xFF7EC4D5);
    if (aqi <= 150) return const Color(0xFFF4C84F);
    if (aqi <= 200) return const Color(0xFFF89C4F);
    if (aqi <= 300) return const Color(0xFFE67E73);
    return const Color(0xFFC85A5A);
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoBox({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x80E8F4F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.foreground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}