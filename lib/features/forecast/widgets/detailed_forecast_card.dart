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
    final style = _aqiStyle(item.aqi);
    final recommendation = _activityRecommendation(item.aqi);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: style.textColor,
          width: 2,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 28,
                color: style.textColor,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 320,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: style.textColor,
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
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: style.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _InfoBox(
                      label: 'Air Quality Category',
                      value: item.category ?? '--',
                      valueColor: style.textColor,
                      backgroundColor: Colors.white.withValues(alpha: 0.45),
                    ),
                    const SizedBox(height: 16),
                    _InfoBox(
                      label: 'Temperature',
                      value: item.temperature ?? '--',
                      backgroundColor: Colors.white.withValues(alpha: 0.45),
                    ),
                    const SizedBox(height: 16),
                    _InfoBox(
                      label: 'Humidity',
                      value: item.humidity ?? '--',
                      backgroundColor: Colors.white.withValues(alpha: 0.45),
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
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: style.textColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity Recommendation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: AppColors.foreground,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        recommendation.icon,
                        size: 22,
                        color: recommendation.iconColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        recommendation.text,
                        style: const TextStyle(
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

  _ActivityRecommendation _activityRecommendation(int? aqi) {
    if (aqi == null) {
      return const _ActivityRecommendation(
        text: 'Forecast recommendation is unavailable because AQI data is missing.',
        icon: Icons.help_outline,
        iconColor: Color(0xFF6B7280),
      );
    }

    if (aqi <= 50) {
      return const _ActivityRecommendation(
        text: 'Air quality is good. Outdoor activities, jogging, walking, and exercise are generally safe for everyone.',
        icon: Icons.check_circle_outline,
        iconColor: Color(0xFF16A34A),
      );
    }

    if (aqi <= 100) {
      return const _ActivityRecommendation(
        text: 'Air quality is moderate. Most people can continue normal outdoor activities, but sensitive individuals may prefer lighter activity.',
        icon: Icons.info_outline,
        iconColor: Color(0xFFCA8A04),
      );
    }

    if (aqi <= 150) {
      return const _ActivityRecommendation(
        text: 'Sensitive groups should reduce prolonged or intense outdoor activity. Consider shorter outdoor sessions and take breaks when needed.',
        icon: Icons.warning_amber_rounded,
        iconColor: Color(0xFFF97316),
      );
    }

    if (aqi <= 200) {
      return const _ActivityRecommendation(
        text: 'Air quality is unhealthy. Limit outdoor activities and avoid strenuous exercise. Staying indoors is recommended where possible.',
        icon: Icons.error_outline,
        iconColor: Color(0xFFDC2626),
      );
    }

    if (aqi <= 300) {
      return const _ActivityRecommendation(
        text: 'Air quality is very unhealthy. Avoid outdoor activities unless absolutely necessary. Use a mask if you need to go outside.',
        icon: Icons.dangerous_outlined,
        iconColor: Color(0xFF9333EA),
      );
    }

    return const _ActivityRecommendation(
      text: 'Air quality is hazardous. Remain indoors, keep windows closed, and avoid all outdoor physical activity.',
      icon: Icons.warning_rounded,
      iconColor: Color(0xFF7F1D1D),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final Color backgroundColor;

  const _InfoBox({
    required this.label,
    required this.value,
    this.valueColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
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

class _AqiVisualStyle {
  final Color backgroundColor;
  final Color textColor;

  const _AqiVisualStyle({
    required this.backgroundColor,
    required this.textColor,
  });
}

class _ActivityRecommendation {
  final String text;
  final IconData icon;
  final Color iconColor;

  const _ActivityRecommendation({
    required this.text,
    required this.icon,
    required this.iconColor,
  });
}