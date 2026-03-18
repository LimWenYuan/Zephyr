import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../features/dashboard/models/dashboard_view_data.dart';
import '../../features/dashboard/models/pollutant_item.dart';
import '../../features/forecast/models/hourly_forecast_point.dart';

class AirQualityLocation {
  final String name;
  final String query;

  const AirQualityLocation({
    required this.name,
    required this.query,
  });
}

class AirQualityService {
  static const String _token = '738f01ba9c2a6b61f48f41843edf9d6c3305a929';

  static const List<AirQualityLocation> locations = [
    AirQualityLocation(
      name: 'Kuala Lumpur City Centre',
      query: '@5780',
    ),
    AirQualityLocation(
      name: 'Putrajaya',
      query: 'geo:2.9264;101.6964',
    ),
    AirQualityLocation(
      name: 'Subang Jaya',
      query: 'geo:3.0449;101.5855',
    ),
    AirQualityLocation(
      name: 'Petaling Jaya',
      query: 'geo:3.1073;101.6067',
    ),
    AirQualityLocation(
      name: 'Klang',
      query: 'geo:3.0442;101.4456',
    ),
    AirQualityLocation(
      name: 'Seremban',
      query: 'geo:2.7258;101.9424',
    ),
    AirQualityLocation(
      name: 'George Town, Penang',
      query: 'geo:5.4141;100.3288',
    ),
    AirQualityLocation(
      name: 'Ipoh',
      query: 'geo:4.5975;101.0901',
    ),
    AirQualityLocation(
      name: 'Alor Setar',
      query: 'geo:6.1184;100.3685',
    ),
    AirQualityLocation(
      name: 'Malacca City',
      query: 'geo:2.1896;102.2501',
    ),
    AirQualityLocation(
      name: 'Johor Bahru',
      query: 'geo:1.4927;103.7414',
    ),
    AirQualityLocation(
      name: 'Batu Pahat',
      query: 'geo:1.8494;102.9288',
    ),
    AirQualityLocation(
      name: 'Kuantan',
      query: 'geo:3.8077;103.3260',
    ),
    AirQualityLocation(
      name: 'Kuala Terengganu',
      query: 'geo:5.3302;103.1408',
    ),
    AirQualityLocation(
      name: 'Kota Bharu',
      query: 'geo:6.1254;102.2381',
    ),
    AirQualityLocation(
      name: 'Kuching',
      query: 'geo:1.5533;110.3592',
    ),
    AirQualityLocation(
      name: 'Miri',
      query: 'geo:4.3995;113.9842',
    ),
    AirQualityLocation(
      name: 'Kota Kinabalu',
      query: 'geo:5.9804;116.0735',
    ),
    AirQualityLocation(
      name: 'Sandakan',
      query: 'geo:5.8394;118.1172',
    ),
  ];

  static List<String> get locationNames {
    return locations.map((location) => location.name).toList();
  }

  Future<DashboardViewData> fetchDashboardData(String locationName) async {
    final location = locations.firstWhere(
      (item) => item.name == locationName,
      orElse: () => locations.first,
    );

    final data = await _fetchWaqiData(location);

    final iaqi = (data['iaqi'] as Map<String, dynamic>?) ?? {};
    final forecast = (data['forecast'] as Map<String, dynamic>?) ?? {};
    final daily = (forecast['daily'] as Map<String, dynamic>?) ?? {};

    final int? aqi = _parseAqi(data, daily);

    return DashboardViewData(
      cityName: location.name,
      subtitle: 'Real-time Air Quality Monitoring',
      heroImagePath: 'assets/images/factorysmoke.jpg',
      windSpeed: _formatValue(_safeValue(iaqi, 'w'), 'm/s'),
      humidity: _formatValue(_safeValue(iaqi, 'h'), '%'),
      temperature: _formatValue(_safeValue(iaqi, 't'), '°C'),
      aqi: aqi,
      aqiCategory: _aqiCategory(aqi),
      lastUpdated: _extractLastUpdated(data),
      selectedLocation: location.name,
      selectedNavIndex: 0,
      pollutants: [
        PollutantItem(
          name: 'PM2.5',
          unit: 'µg/m³',
          description: 'Fine particles that can penetrate deep into lungs',
          icon: Icons.water_drop_outlined,
          valueText: _pollutantValueWithFallback(
            iaqi: iaqi,
            daily: daily,
            key: 'pm25',
          ),
          isSafe: _isSafe(
            'pm25',
            _numericValueWithFallback(
              iaqi: iaqi,
              daily: daily,
              key: 'pm25',
            ),
          ),
        ),
        PollutantItem(
          name: 'PM10',
          unit: 'µg/m³',
          description: 'Inhalable particles from dust and smoke',
          icon: Icons.air,
          valueText: _pollutantValueWithFallback(
            iaqi: iaqi,
            daily: daily,
            key: 'pm10',
          ),
          isSafe: _isSafe(
            'pm10',
            _numericValueWithFallback(
              iaqi: iaqi,
              daily: daily,
              key: 'pm10',
            ),
          ),
        ),
        PollutantItem(
          name: 'O₃',
          unit: 'ppb',
          description: 'Ground-level ozone, harmful to respiratory system',
          icon: Icons.show_chart,
          valueText: _pollutantValueWithFallback(
            iaqi: iaqi,
            daily: daily,
            key: 'o3',
          ),
          isSafe: _isSafe(
            'o3',
            _numericValueWithFallback(
              iaqi: iaqi,
              daily: daily,
              key: 'o3',
            ),
          ),
        ),
        PollutantItem(
          name: 'NO₂',
          unit: 'ppb',
          description: 'Nitrogen dioxide from vehicle emissions',
          icon: Icons.warning_amber_outlined,
          valueText: _pollutantValueWithFallback(
            iaqi: iaqi,
            daily: daily,
            key: 'no2',
          ),
          isSafe: _isSafe(
            'no2',
            _numericValueWithFallback(
              iaqi: iaqi,
              daily: daily,
              key: 'no2',
            ),
          ),
        ),
        PollutantItem(
          name: 'SO₂',
          unit: 'ppb',
          description: 'Sulfur dioxide from industrial sources',
          icon: Icons.speed,
          valueText: _pollutantValueWithFallback(
            iaqi: iaqi,
            daily: daily,
            key: 'so2',
          ),
          isSafe: _isSafe(
            'so2',
            _numericValueWithFallback(
              iaqi: iaqi,
              daily: daily,
              key: 'so2',
            ),
          ),
        ),
        PollutantItem(
          name: 'CO',
          unit: 'ppm',
          description: 'Carbon monoxide, can reduce oxygen delivery',
          icon: Icons.error_outline,
          valueText: _pollutantValueWithFallback(
            iaqi: iaqi,
            daily: daily,
            key: 'co',
          ),
          isSafe: _isSafe(
            'co',
            _numericValueWithFallback(
              iaqi: iaqi,
              daily: daily,
              key: 'co',
            ),
          ),
        ),
      ],
    );
  }

  Future<List<HourlyForecastPoint>> fetchEstimatedHourlyForecast(
    String locationName,
  ) async {
    final location = locations.firstWhere(
      (item) => item.name == locationName,
      orElse: () => locations.first,
    );

    final data = await _fetchWaqiData(location);
    final forecast = (data['forecast'] as Map<String, dynamic>?) ?? {};
    final daily = (forecast['daily'] as Map<String, dynamic>?) ?? {};

    final pm25List = (daily['pm25'] as List?)?.cast<dynamic>() ?? [];
    final pm10List = (daily['pm10'] as List?)?.cast<dynamic>() ?? [];

    final today = DateTime.now();
    final todayKey =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowKey =
        '${tomorrow.year.toString().padLeft(4, '0')}-'
        '${tomorrow.month.toString().padLeft(2, '0')}-'
        '${tomorrow.day.toString().padLeft(2, '0')}';

    final todayAvg =
        _findDailyAverageByDate(pm25List, todayKey) ??
        _findDailyAverageByDate(pm10List, todayKey) ??
        _dailyAverage(daily, 'pm25') ??
        _dailyAverage(daily, 'pm10') ??
        60.0;

    final tomorrowAvg =
        _findDailyAverageByDate(pm25List, tomorrowKey) ??
        _findDailyAverageByDate(pm10List, tomorrowKey) ??
        todayAvg;

    return _buildEstimatedHourlyPoints(
      todayAverage: todayAvg,
      tomorrowAverage: tomorrowAvg,
    );
  }

  Future<Map<String, dynamic>> _fetchWaqiData(AirQualityLocation location) async {
    final uri = Uri.parse(
      'https://api.waqi.info/feed/${location.query}/?token=$_token',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch WAQI data');
    }

    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonMap['status'] != 'ok') {
      throw Exception('WAQI returned status: ${jsonMap['status']}');
    }

    return jsonMap['data'] as Map<String, dynamic>;
  }

  List<HourlyForecastPoint> _buildEstimatedHourlyPoints({
    required double todayAverage,
    required double tomorrowAverage,
  }) {
    const hourLabels = [
      '00:00',
      '01:00',
      '02:00',
      '03:00',
      '04:00',
      '05:00',
      '06:00',
      '07:00',
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00',
    ];

    final baseline = todayAverage;
    final nextInfluence = tomorrowAverage - todayAverage;

    return List.generate(24, (index) {
      final h = index.toDouble();

      double value = baseline;

      value += _gaussian(h, mean: 4.0, sigma: 1.8) * (-0.32 * baseline);
      value += _gaussian(h, mean: 13.5, sigma: 3.6) * (0.12 * baseline);
      value += _gaussian(h, mean: 18.8, sigma: 2.1) * (0.30 * baseline);
      value += math.sin((h / 24) * 2 * math.pi - 0.9) * 4.0;
      value += (nextInfluence * (h / 23.0)) * 0.28;

      final bounded = value.clamp(
        math.max(10.0, baseline * 0.68),
        math.max(25.0, baseline * 1.32),
      );

      return HourlyForecastPoint(
        hourLabel: hourLabels[index],
        aqi: double.parse(bounded.toStringAsFixed(1)),
      );
    });
  }

  double _gaussian(
    double x, {
    required double mean,
    required double sigma,
  }) {
    final exponent = -math.pow(x - mean, 2) / (2 * math.pow(sigma, 2));
    return math.exp(exponent);
  }

  double? _findDailyAverageByDate(List<dynamic> values, String dateKey) {
    for (final item in values) {
      if (item is Map<String, dynamic> && item['day']?.toString() == dateKey) {
        final avg = item['avg'];
        if (avg != null) {
          return double.tryParse(avg.toString());
        }
      }
    }
    return null;
  }

  int? _parseAqi(Map<String, dynamic> data, Map<String, dynamic> daily) {
    final rawAqi = data['aqi'];
    final parsed = double.tryParse(rawAqi?.toString() ?? '');
    if (parsed != null) return parsed.ceil();

    final fallback = _dailyAverage(daily, 'pm25');
    if (fallback != null) {
      return fallback.ceil();
    }

    return null;
  }

  String? _extractLastUpdated(Map<String, dynamic> data) {
    final time = data['time'];
    if (time is Map<String, dynamic>) {
      return time['s']?.toString();
    }
    return null;
  }

  double? _safeValue(Map<String, dynamic> iaqi, String key) {
    final item = iaqi[key];
    if (item is Map<String, dynamic> && item['v'] != null) {
      return double.tryParse(item['v'].toString());
    }
    return null;
  }

  String _displayFromNumber(double value) {
    return value.ceil().toString();
  }

  String _pollutantValueWithFallback({
    required Map<String, dynamic> iaqi,
    required Map<String, dynamic> daily,
    required String key,
  }) {
    final direct = _safeValue(iaqi, key);
    if (direct != null) {
      return _displayFromNumber(direct);
    }

    final fallback = _dailyAverage(daily, key);
    if (fallback != null) {
      return '${_displayFromNumber(fallback)} (avg)';
    }

    return '--';
  }

  double? _numericValueWithFallback({
    required Map<String, dynamic> iaqi,
    required Map<String, dynamic> daily,
    required String key,
  }) {
    return _safeValue(iaqi, key) ?? _dailyAverage(daily, key);
  }

  double? _dailyAverage(Map<String, dynamic> daily, String key) {
    final values = daily[key];
    if (values is List && values.isNotEmpty) {
      final first = values.first;
      if (first is Map<String, dynamic> && first['avg'] != null) {
        return double.tryParse(first['avg'].toString());
      }
    }
    return null;
  }

  String? _formatValue(double? value, String unit) {
    if (value == null) return null;
    return '${value.ceil()}$unit';
  }

  String? _aqiCategory(int? aqi) {
    if (aqi == null) return null;
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  bool? _isSafe(String key, double? value) {
    if (value == null) return null;

    switch (key) {
      case 'pm25':
        return value <= 15;
      case 'pm10':
        return value <= 45;
      case 'o3':
        return value <= 100;
      case 'no2':
        return value <= 80;
      case 'so2':
        return value <= 75;
      case 'co':
        return value <= 9;
      default:
        return null;
    }
  }
}