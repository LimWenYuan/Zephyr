import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/dashboard_view_data.dart';

class AqiMainCard extends StatelessWidget {
  final DashboardViewData data;

  const AqiMainCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final style = _aqiStyle(data.aqi);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: style.textColor,
          width: 4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                style.icon,
                size: 64,
                color: style.textColor,
              ),
              const SizedBox(width: 16),
              Text(
                'Air Quality: ${data.aqiCategory ?? '--'}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: style.textColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            data.aqi?.toString() ?? '--',
            style: TextStyle(
              fontSize: 144,
              fontWeight: FontWeight.bold,
              color: style.textColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Air Quality Index (AQI)',
            style: TextStyle(
              fontSize: 30,
              color: style.textColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 24,
                color: style.textColor.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 8),
              Text(
                'Last updated at ${data.lastUpdated ?? '--'}',
                style: TextStyle(
                  fontSize: 20,
                  color: style.textColor.withValues(alpha: 0.8),
                ),
              ),
            ],
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
        icon: Icons.help_outline,
      );
    }
    if (aqi <= 50) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFDCFCE7),
        textColor: Color(0xFF16A34A),
        icon: Icons.thumb_up_alt_outlined,
      );
    }
    if (aqi <= 100) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFFEF9C3),
        textColor: Color(0xFFCA8A04),
        icon: Icons.info_outline,
      );
    }
    if (aqi <= 150) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFFFEDD5),
        textColor: Color(0xFFF97316),
        icon: Icons.warning_amber_outlined,
      );
    }
    if (aqi <= 200) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFFEE2E2),
        textColor: Color(0xFFDC2626),
        icon: Icons.cancel_outlined,
      );
    }
    if (aqi <= 300) {
      return const _AqiVisualStyle(
        backgroundColor: Color(0xFFF3E8FF),
        textColor: Color(0xFF9333EA),
        icon: Icons.cancel_outlined,
      );
    }
    return const _AqiVisualStyle(
      backgroundColor: Color(0xFFFECACA),
      textColor: Color(0xFF7F1D1D),
      icon: Icons.dangerous_outlined,
    );
  }
}

class _AqiVisualStyle {
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const _AqiVisualStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}