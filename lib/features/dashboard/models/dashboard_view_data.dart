import 'pollutant_item.dart';

class DashboardViewData {
  final String? cityName;
  final String? subtitle;
  final String? heroImagePath;
  final String? windSpeed;
  final String? humidity;
  final String? temperature;
  final int? aqi;
  final String? aqiCategory;
  final String? lastUpdated;
  final List<PollutantItem> pollutants;
  final String? selectedLocation;
  final int selectedNavIndex;

  const DashboardViewData({
    this.cityName,
    this.subtitle,
    this.heroImagePath,
    this.windSpeed,
    this.humidity,
    this.temperature,
    this.aqi,
    this.aqiCategory,
    this.lastUpdated,
    this.pollutants = const [],
    this.selectedLocation,
    this.selectedNavIndex = 0,
  });
}