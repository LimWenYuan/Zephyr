import 'package:flutter/material.dart';
import '../../data/services/air_quality_service.dart';
import 'models/dashboard_view_data.dart';
import 'models/pollutant_item.dart';
import 'widgets/aqi_main_card.dart';
import 'widgets/aqi_scale_card.dart';
import 'widgets/dashboard_bottom_nav.dart';
import 'widgets/dashboard_hero_section.dart';
import 'widgets/dashboard_top_brand_bar.dart';
import 'widgets/location_selector_card.dart';
import 'widgets/pollutant_grid.dart';
import 'widgets/pollutant_section_header.dart';

class DashboardScreen extends StatefulWidget {
  final String? selectedLocation;

  const DashboardScreen({
    super.key,
    this.selectedLocation,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AirQualityService _airQualityService = AirQualityService();

  late String selectedLocation;
  late DashboardViewData data;

  bool isLoading = false;
  String? errorMessage;

  List<String> get availableLocations => AirQualityService.locationNames;

  @override
  void initState() {
    super.initState();

    selectedLocation = widget.selectedLocation != null &&
        AirQualityService.locationNames.contains(widget.selectedLocation)
        ? widget.selectedLocation!
        : AirQualityService.locationNames.first;

    data = _emptyDashboardData(selectedLocation);

    _loadAirQualityData();
  }

  DashboardViewData _emptyDashboardData(String location) {
    return DashboardViewData(
      cityName: location,
      subtitle: 'Real-time Air Quality Monitoring',
      heroImagePath: 'assets/images/factorysmoke.jpg',
      windSpeed: null,
      humidity: null,
      temperature: null,
      aqi: null,
      aqiCategory: null,
      lastUpdated: null,
      selectedLocation: location,
      selectedNavIndex: 0,
      pollutants: const [
        PollutantItem(
          name: 'PM2.5',
          unit: 'µg/m³',
          description: 'Fine particles that can penetrate deep into lungs',
          icon: Icons.water_drop_outlined,
        ),
        PollutantItem(
          name: 'PM10',
          unit: 'µg/m³',
          description: 'Inhalable particles from dust and smoke',
          icon: Icons.air,
        ),
        PollutantItem(
          name: 'O₃',
          unit: 'ppb',
          description: 'Ground-level ozone, harmful to respiratory system',
          icon: Icons.show_chart,
        ),
        PollutantItem(
          name: 'NO₂',
          unit: 'ppb',
          description: 'Nitrogen dioxide from vehicle emissions',
          icon: Icons.warning_amber_outlined,
        ),
        PollutantItem(
          name: 'SO₂',
          unit: 'ppb',
          description: 'Sulfur dioxide from industrial sources',
          icon: Icons.speed,
        ),
        PollutantItem(
          name: 'CO',
          unit: 'ppm',
          description: 'Carbon monoxide, can reduce oxygen delivery',
          icon: Icons.error_outline,
        ),
      ],
    );
  }

  Future<void> _loadAirQualityData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedData = await _airQualityService.fetchDashboardData(selectedLocation);

      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        data = _emptyDashboardData(selectedLocation);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateSelectedLocation(String? value) async {
    if (value == null || value == selectedLocation) return;

    setState(() {
      selectedLocation = value;
      data = _emptyDashboardData(selectedLocation);
    });

    await _loadAirQualityData();
  }

    void _handleBottomNav(BuildContext context, int index) {
  if (index == 0) {
    return;
  } else if (index == 1) {
    Navigator.pushReplacementNamed(context, '/forecast', arguments: selectedLocation);
  } else if (index == 2) {
    Navigator.pushReplacementNamed(context, '/trends', arguments: selectedLocation);
  } else if (index == 3) {
    Navigator.pushReplacementNamed(context, '/health', arguments: selectedLocation);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFE8F4F0),
                  Color(0xFFB8D9D3),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardTopBrandBar(),
                  DashboardHeroSection(data: data),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AqiMainCard(data: data),
                            AqiScaleCard(
                              aqi: data.aqi,
                              onHealthPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/health',
                                  arguments: selectedLocation,
                                );
                              },
                            ),
                            if (isLoading) ...[
                              const SizedBox(height: 8),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                            if (errorMessage != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Failed to load air quality data: $errorMessage',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            const PollutantSectionHeader(),
                            const SizedBox(height: 24),
                            PollutantGrid(items: data.pollutants),
                            const SizedBox(height: 32),
                            LocationSelectorCard(
                              selectedLocation: selectedLocation,
                              locations: availableLocations,
                              onChanged: _updateSelectedLocation,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DashboardBottomNav(
            currentIndex: data.selectedNavIndex,
            onTap: (index) => _handleBottomNav(context, index),
          ),
        ],
      ),
    );
  }
}