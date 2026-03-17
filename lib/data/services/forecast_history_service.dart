import 'package:supabase_flutter/supabase_flutter.dart';

class ForecastHistoryService {
  final _client = Supabase.instance.client;

  static const Map<String, int> _stationNameToId = {
    'Kuala Lumpur': 1,
    'Kuala Lumpur City Centre': 1,
    'Putrajaya': 2,
    'Subang Jaya': 3,
    'Petaling Jaya': 4,
    'Klang': 5,
    'Seremban': 6,
    'George Town': 7,
    'Ipoh': 8,
    'Alor Setar': 9,
    'Melaka': 10,
    'Johor Bahru': 11,
    'Batu Pahat': 12,
    'Kuantan': 13,
    'Kuala Terengganu': 14,
    'Kota Bharu': 15,
    'Kuching': 16,
    'Miri': 17,
    'Kota Kinabalu': 18,
    'Sandakan': 19,
  };

  int _resolveStationId(String stationName) {
    return _stationNameToId[stationName] ?? 1;
  }

  Future<List<Map<String, dynamic>>> fetchSevenDayForecast({
    required String stationName,
  }) async {
    final stationId = _resolveStationId(stationName);

    final response = await _client
        .from('air_quality_reading')
        .select('''
          station_id,
          api_value,
          pm25,
          pm10,
          o3,
          no2,
          co,
          so2,
          reading_time,
          air_temperature,
          air_humidity,
          created_at,
          forecasting_date
        ''')
        .eq('station_id', stationId)
        .order('forecasting_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}