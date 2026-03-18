import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/air_quality_service.dart';

class ForecastHistoryService {
  static const String _token = '738f01ba9c2a6b61f48f41843edf9d6c3305a929';

  Future<List<Map<String, dynamic>>> fetchSevenDayForecast({
    required String stationName,
  }) async {
    final location = AirQualityService.locations.firstWhere(
      (item) => item.name == stationName,
      orElse: () => AirQualityService.locations.first,
    );

    final uri = Uri.parse(
      'https://api.waqi.info/feed/${location.query}/?token=$_token',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch WAQI forecast data');
    }

    final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonMap['status'] != 'ok') {
      throw Exception('WAQI returned status: ${jsonMap['status']}');
    }

    final data = jsonMap['data'] as Map<String, dynamic>;
    final forecast = (data['forecast'] as Map<String, dynamic>?) ?? {};
    final daily = (forecast['daily'] as Map<String, dynamic>?) ?? {};

    final pm25List = (daily['pm25'] as List?) ?? const [];
    final iaqi = (data['iaqi'] as Map<String, dynamic>?) ?? {};

    final double? currentTemp = _safeValue(iaqi, 't');
    final double? currentHumidity = _safeValue(iaqi, 'h');

    final List<Map<String, dynamic>> rows = [];

    for (final item in pm25List) {
      if (item is! Map<String, dynamic>) continue;

      final day = item['day']?.toString();
      if (day == null || day.isEmpty) continue;

      final avgAqi = _toDouble(item['avg']);

      rows.add({
        'station_id': null,
        'api_value': avgAqi?.round(),
        'pm25': avgAqi,
        'pm10': _dailyValueForDay(daily, 'pm10', day),
        'o3': _dailyValueForDay(daily, 'o3', day),
        'no2': _dailyValueForDay(daily, 'no2', day),
        'co': _dailyValueForDay(daily, 'co', day),
        'so2': _dailyValueForDay(daily, 'so2', day),
        'reading_time': data['time'] is Map<String, dynamic>
            ? (data['time'] as Map<String, dynamic>)['s']
            : null,
        'air_temperature': currentTemp,
        'air_humidity': currentHumidity,
        'created_at': DateTime.now().toIso8601String(),
        'forecasting_date': day,
      });
    }

    return rows;
  }

  double? _safeValue(Map<String, dynamic> iaqi, String key) {
    final item = iaqi[key];
    if (item is Map<String, dynamic> && item['v'] != null) {
      return double.tryParse(item['v'].toString());
    }
    return null;
  }

  double? _dailyValueForDay(
    Map<String, dynamic> daily,
    String key,
    String day,
  ) {
    final values = daily[key];
    if (values is! List) return null;

    for (final item in values) {
      if (item is Map<String, dynamic> && item['day']?.toString() == day) {
        return _toDouble(item['avg']);
      }
    }

    return null;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}