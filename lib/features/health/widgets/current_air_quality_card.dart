import 'package:flutter/material.dart';
import '../models/health_advice_view_data.dart';

class CurrentAirQualityCard extends StatelessWidget {
  final HealthAdviceViewData data;

  const CurrentAirQualityCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final style = _aqiStyle(data.aqi);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 48),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: style.textColor,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Air Quality in Your Area',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF173B3A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.location,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF5F7F7D),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AqiCircle(
                aqi: data.aqi,
                categoryText: data.categoryText,
                accentColor: style.textColor,
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _AdviceBox(
                  data: data,
                  accentColor: style.textColor,
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
        textColor: Color(0xFF374151),
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

class _AqiCircle extends StatelessWidget {
  final int? aqi;
  final String categoryText;
  final Color accentColor;

  const _AqiCircle({
    required this.aqi,
    required this.categoryText,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        children: [
          Container(
            width: 144,
            height: 144,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
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
                aqi?.toString() ?? '--',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            categoryText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceBox extends StatelessWidget {
  final HealthAdviceViewData data;
  final Color accentColor;

  const _AdviceBox({
    required this.data,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                data.statusIcon,
                size: 32,
                color: accentColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data.adviceTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xCC1A3A3A),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommendations:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF173B3A),
            ),
          ),
          const SizedBox(height: 12),
          ...data.recommendations.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF173B3A),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
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
  final IconData icon;

  const _AqiVisualStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}