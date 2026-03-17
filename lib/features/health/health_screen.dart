import 'package:flutter/material.dart';

import '../../data/services/air_quality_service.dart';
import '../dashboard/models/dashboard_view_data.dart';
import '../dashboard/widgets/dashboard_bottom_nav.dart';
import '../dashboard/widgets/dashboard_top_brand_bar.dart';
import 'models/health_advice_view_data.dart';
import 'models/health_contact_item.dart';
import 'models/health_guideline_item.dart';
import 'widgets/additional_resources_card.dart';
import 'widgets/current_air_quality_card.dart';
import 'widgets/health_guidelines_section.dart';
import 'widgets/health_header_card.dart';
import 'widgets/important_contacts_card.dart';
import 'widgets/warning_signs_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  void _handleBottomNav(BuildContext context, int index, String location) {
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
        arguments: location,
      );
    } else if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        '/forecast',
        arguments: location,
      );
    } else if (index == 2) {
      Navigator.pushReplacementNamed(
        context,
        '/trends',
        arguments: location,
      );
    } else if (index == 3) {
      return;
    }
  }

  HealthAdviceViewData _buildHealthAdvice(DashboardViewData data) {
    final int? aqi = data.aqi;
    final String category = data.aqiCategory ?? '--';
    final String resolvedLocation =
        data.cityName ?? data.selectedLocation ?? 'Unknown Location';

    if (aqi == null) {
      return HealthAdviceViewData(
        location: resolvedLocation,
        aqi: null,
        categoryText: '--',
        adviceTitle: 'Current air quality data unavailable',
        description:
        'Live AQI data could not be loaded right now, so health guidance cannot be determined.',
        recommendations: const [
          'Try refreshing again in a moment',
          'Check your network connection',
        ],
        accentColor: const Color(0xFF7AA5B5),
        statusIcon: Icons.help_outline,
      );
    }

    if (aqi <= 50) {
      return HealthAdviceViewData(
        location: resolvedLocation,
        aqi: aqi,
        categoryText: category,
        adviceTitle: 'Air quality is good',
        description:
        'Air quality poses little or no risk. It is a good time for normal outdoor activities.',
        recommendations: const [
          'Outdoor activities are safe for most people',
          'Fresh air ventilation is generally fine',
          'Sensitive groups usually do not need precautions',
        ],
        accentColor: const Color(0xFF4CAF50),
        statusIcon: Icons.check_circle_outline,
      );
    }

    if (aqi <= 100) {
      return HealthAdviceViewData(
        location: resolvedLocation,
        aqi: aqi,
        categoryText: category,
        adviceTitle: 'Air quality is acceptable',
        description:
        'Air quality is acceptable for most people. Sensitive individuals may experience minor effects.',
        recommendations: const [
          'Most outdoor activities are fine',
          'If you have respiratory issues, monitor how you feel',
          'Consider shorter outdoor sessions if you are sensitive',
        ],
        accentColor: const Color(0xFF7AA5B5),
        statusIcon: Icons.info_outline,
      );
    }

    if (aqi <= 150) {
      return HealthAdviceViewData(
        location: resolvedLocation,
        aqi: aqi,
        categoryText: category,
        adviceTitle: 'Sensitive groups should take care',
        description:
        'Children, older adults, and people with heart or lung conditions should reduce prolonged outdoor exertion.',
        recommendations: const [
          'Sensitive groups should limit time outdoors',
          'Reduce heavy outdoor exercise',
          'Keep medication nearby if you have asthma or breathing issues',
        ],
        accentColor: const Color(0xFFF59E0B),
        statusIcon: Icons.warning_amber_rounded,
      );
    }

    if (aqi <= 200) {
      return HealthAdviceViewData(
        location: resolvedLocation,
        aqi: aqi,
        categoryText: category,
        adviceTitle: 'Air quality is unhealthy',
        description:
        'Everyone may begin to experience health effects, especially sensitive groups.',
        recommendations: const [
          'Limit outdoor activities',
          'Avoid strenuous outdoor exercise',
          'Close windows and stay indoors when possible',
        ],
        accentColor: const Color(0xFFEF4444),
        statusIcon: Icons.error_outline,
      );
    }

    if (aqi <= 300) {
      return HealthAdviceViewData(
        location: resolvedLocation,
        aqi: aqi,
        categoryText: category,
        adviceTitle: 'Health alert: very unhealthy air',
        description:
        'Health risk is increased for everyone. Outdoor exposure should be minimized.',
        recommendations: const [
          'Stay indoors as much as possible',
          'Wear a mask if you must go outside',
          'Avoid outdoor workouts or long exposure',
        ],
        accentColor: const Color(0xFF8B5CF6),
        statusIcon: Icons.dangerous_outlined,
      );
    }

    return HealthAdviceViewData(
      location: resolvedLocation,
      aqi: aqi,
      categoryText: category,
      adviceTitle: 'Hazardous air quality',
      description:
      'This is an emergency-level pollution condition. Everyone should avoid outdoor exposure.',
      recommendations: const [
        'Stay indoors and keep doors and windows closed',
        'Use air purification if available',
        'Go outside only if absolutely necessary',
      ],
      accentColor: const Color(0xFF7F1D1D),
      statusIcon: Icons.warning_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String location =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
            'Kuala Lumpur City Centre';

    const guidelineItems = [
      HealthGuidelineItem(
        icon: Icons.shield_outlined,
        title: 'General Health Protection',
        bullets: [
          'Wear a properly fitted N95 or KN95 mask when air quality is poor',
          'Keep windows and doors closed during high pollution periods',
          'Use air purifiers with HEPA filters in your home',
          'Stay hydrated to help your body naturally filter pollutants',
          'Avoid smoking or exposure to secondhand smoke',
        ],
      ),
      HealthGuidelineItem(
        icon: Icons.show_chart,
        title: 'Managing Outdoor Activities',
        bullets: [
          'Schedule outdoor activities during times when air quality is better (usually early morning)',
          'Reduce the intensity and duration of outdoor exercise on poor air quality days',
          'Choose indoor alternatives for exercise when AQI is above 100',
          'Take frequent breaks if you must be outdoors',
          'Avoid busy roads and high-traffic areas during rush hours',
        ],
      ),
      HealthGuidelineItem(
        icon: Icons.favorite_border,
        title: 'For Those with Health Conditions',
        bullets: [
          'Keep your prescribed medications readily available',
          'Monitor your symptoms closely (shortness of breath, chest pain, coughing)',
          'Consult with your doctor about an action plan for poor air quality days',
          'Consider using a peak flow meter if you have asthma',
          'Avoid prolonged exposure even on moderate air quality days',
        ],
      ),
      HealthGuidelineItem(
        icon: Icons.home_outlined,
        title: 'Indoor Air Quality',
        bullets: [
          'Vacuum regularly with a HEPA filter vacuum cleaner',
          'Avoid using products that release pollutants (aerosols, candles)',
          'Keep indoor plants that help purify air',
          'Ensure proper ventilation when air quality outside is good',
          'Change air conditioning filters regularly',
        ],
      ),
    ];

    const warningSigns = [
      'Severe difficulty breathing or shortness of breath',
      'Chest pain or tightness',
      'Rapid or irregular heartbeat',
      'Persistent coughing or wheezing',
      'Dizziness or confusion',
      'Unusual fatigue or weakness',
      'Blue lips or fingernails',
      'Worsening of existing conditions (asthma, COPD, heart disease)',
    ];

    const contactItems = [
      HealthContactItem(
        title: 'Emergency Services',
        number: '999',
        description: 'For immediate medical emergencies',
      ),
      HealthContactItem(
        title: 'Department of Environment',
        number: '1-800-88-\n2727',
        description: 'Air quality information and complaints',
      ),
      HealthContactItem(
        title: 'Health Ministry Hotline',
        number: '03-8883\n1000',
        description: 'General health inquiries',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFE8F4F0),
                  Color(0xFFA8D5E2),
                ],
              ),
            ),
            child: FutureBuilder<DashboardViewData>(
              future: AirQualityService().fetchDashboardData(location),
              builder: (context, snapshot) {
                final HealthAdviceViewData adviceData;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  adviceData = const HealthAdviceViewData(
                    location: 'Loading...',
                    aqi: null,
                    categoryText: '--',
                    adviceTitle: 'Loading current air quality...',
                    description:
                    'Please wait while we fetch the latest air quality data.',
                    recommendations: [
                      'Loading current AQI',
                    ],
                    accentColor: Color(0xFF7AA5B5),
                    statusIcon: Icons.hourglass_top,
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  adviceData = HealthAdviceViewData(
                    location: location,
                    aqi: null,
                    categoryText: '--',
                    adviceTitle: 'Current air quality data unavailable',
                    description:
                    'Live AQI data could not be loaded for this location.',
                    recommendations: const [
                      'Try again in a moment',
                      'Check your network or API connection',
                    ],
                    accentColor: const Color(0xFF7AA5B5),
                    statusIcon: Icons.help_outline,
                  );
                } else {
                  adviceData = _buildHealthAdvice(snapshot.data!);
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      const DashboardTopBrandBar(),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 48,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HealthHeaderCard(),
                                CurrentAirQualityCard(data: adviceData),
                                const HealthGuidelinesSection(
                                  items: guidelineItems,
                                ),
                                const WarningSignsCard(
                                  symptoms: warningSigns,
                                ),
                                const ImportantContactsCard(
                                  items: contactItems,
                                ),
                                const AdditionalResourcesCard(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          DashboardBottomNav(
            currentIndex: 3,
            onTap: (index) => _handleBottomNav(context, index, location),
          ),
        ],
      ),
    );
  }
}