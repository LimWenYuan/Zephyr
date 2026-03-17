import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/dashboard_view_data.dart';
import 'weather_stat_card.dart';

class DashboardHeroSection extends StatelessWidget {
  final DashboardViewData data;

  const DashboardHeroSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = data.heroImagePath;

    return SizedBox(
      width: double.infinity,
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath != null && imagePath.isNotEmpty)
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            )
          else
            Container(
              color: const Color(0xFFD6D6D6),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xB3000000),
                  Color(0x66000000),
                  Color(0x00000000),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 32, 32, 44),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.cityName ?? '--',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      data.subtitle ?? 'Real-time Air Quality Monitoring',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Color(0xE6FFFFFF),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 22,
                      runSpacing: 16,
                      children: [
                        WeatherStatCard(
                          icon: Icons.air,
                          label: 'Wind Speed',
                          value: data.windSpeed,
                        ),
                        WeatherStatCard(
                          icon: Icons.water_drop_outlined,
                          label: 'Humidity',
                          value: data.humidity,
                        ),
                        WeatherStatCard(
                          icon: Icons.speed,
                          label: 'Temperature',
                          value: data.temperature,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}