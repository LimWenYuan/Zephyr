import 'package:flutter/material.dart';
import '../dashboard/widgets/dashboard_bottom_nav.dart';
import '../dashboard/widgets/dashboard_top_brand_bar.dart';
import 'models/daily_forecast_item.dart';
import 'models/forecast_view_data.dart';
import 'models/hourly_forecast_point.dart';
import 'widgets/daily_breakdown_grid.dart';
import 'widgets/detailed_forecast_card.dart';
import 'widgets/forecast_header_section.dart';
import 'widgets/forecast_line_chart_card.dart';
import 'widgets/high_risk_alert_card.dart';
import 'widgets/recommendation_cards_section.dart';
import 'widgets/seven_day_bar_chart_card.dart';
import '../../data/services/forecast_history_service.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final _historyService = ForecastHistoryService();
  bool _hasLoadedHistory = false;
  bool _isLoadingHistory = false;

  final ForecastViewData data = const ForecastViewData(
    // Mock 24-hour AQI forecast just for UI demo
    // Lowest period: 02:00 - 06:00
    // Highest period: 16:00 - 20:00
    hourlyPoints: [
      HourlyForecastPoint(hourLabel: '00:00', aqi: 52),
      HourlyForecastPoint(hourLabel: '01:00', aqi: 48),
      HourlyForecastPoint(hourLabel: '02:00', aqi: 44),
      HourlyForecastPoint(hourLabel: '03:00', aqi: 41),
      HourlyForecastPoint(hourLabel: '04:00', aqi: 39),
      HourlyForecastPoint(hourLabel: '05:00', aqi: 43),
      HourlyForecastPoint(hourLabel: '06:00', aqi: 47),
      HourlyForecastPoint(hourLabel: '07:00', aqi: 53),
      HourlyForecastPoint(hourLabel: '08:00', aqi: 58),
      HourlyForecastPoint(hourLabel: '09:00', aqi: 62),
      HourlyForecastPoint(hourLabel: '10:00', aqi: 66),
      HourlyForecastPoint(hourLabel: '11:00', aqi: 70),
      HourlyForecastPoint(hourLabel: '12:00', aqi: 74),
      HourlyForecastPoint(hourLabel: '13:00', aqi: 78),
      HourlyForecastPoint(hourLabel: '14:00', aqi: 81),
      HourlyForecastPoint(hourLabel: '15:00', aqi: 83),
      HourlyForecastPoint(hourLabel: '16:00', aqi: 85),
      HourlyForecastPoint(hourLabel: '17:00', aqi: 88),
      HourlyForecastPoint(hourLabel: '18:00', aqi: 91),
      HourlyForecastPoint(hourLabel: '19:00', aqi: 86),
      HourlyForecastPoint(hourLabel: '20:00', aqi: 82),
      HourlyForecastPoint(hourLabel: '21:00', aqi: 72),
      HourlyForecastPoint(hourLabel: '22:00', aqi: 64),
      HourlyForecastPoint(hourLabel: '23:00', aqi: 58),
    ],

    // Leave 7-day data blank for now, will connect to DB later
    dailyItems: [],

    // Recommendation cards based on the mock 24-hour forecast above
    bestTimeRange: '02:00 - 06:00',
    bestTimeDescription:
    'Ideal for walks, exercise, and outdoor activities. Air quality is at its best during this period.',
    bestTimeMeta: 'Avg AQI: 44',

    stayIndoorsRange: '16:00 - 20:00',
    stayIndoorsDescription:
    'Air quality is poorest during these hours. Consider staying indoors with air conditioning or purifiers.',
    stayIndoorsMeta: 'Avg AQI: 85',

    exerciseRange: '02:00 - 06:00',
    exerciseDescription:
    'Perfect conditions for jogging, cycling, or other aerobic activities.',
    exerciseMeta: '✓ All activities safe',

    showHighRiskAlert: false,
    highRiskText: null,
    selectedNavIndex: 1,
  );

  List<DailyForecastItem> _historyDailyItems = [];

  int selectedDayIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoadedHistory) return;
    _hasLoadedHistory = true;

    final String location =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
            'Kuala Lumpur City Centre';

    _loadHistory(location);
  }

  Future<void> _loadHistory(String location) async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final rows = await _historyService.fetchHistory(
        stationName: location,
        limit: 120,
      );

      final grouped = <String, List<Map<String, dynamic>>>{};

      for (final row in rows) {
        final rawCreatedAt = row['created_at']?.toString();
        if (rawCreatedAt == null || rawCreatedAt.isEmpty) continue;

        final dt = DateTime.tryParse(rawCreatedAt);
        if (dt == null) continue;

        final localDt = dt.toLocal();
        final dateKey =
            '${localDt.year.toString().padLeft(4, '0')}-'
            '${localDt.month.toString().padLeft(2, '0')}-'
            '${localDt.day.toString().padLeft(2, '0')}';

        grouped.putIfAbsent(dateKey, () => []).add(row);
      }

      final sortedKeys = grouped.keys.toList()..sort();
      final latest7Keys = sortedKeys.reversed.take(7).toList().reversed.toList();

      final mappedDailyItems = latest7Keys.map((dateKey) {
        final items = grouped[dateKey] ?? [];

        final avgAqi = _averageNum(items.map((e) => e['api_value']).toList());
        final avgTemp =
        _averageNum(items.map((e) => e['air_temperature']).toList());
        final avgHumidity =
        _averageNum(items.map((e) => e['air_humidity']).toList());

        final parsedDate = DateTime.parse('$dateKey 00:00:00');

        return DailyForecastItem(
          weekday: _weekdayLabel(parsedDate),
          dateLabel: _dateLabel(parsedDate),
          aqi: avgAqi?.round(),
          category: _aqiCategory(avgAqi?.round()),
          temperature: avgTemp == null ? '--' : '${avgTemp.round()}°C',
          humidity: avgHumidity == null ? '--' : '${avgHumidity.round()}%',
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        _historyDailyItems = mappedDailyItems;
        if (selectedDayIndex >= _displayItems.length) {
          selectedDayIndex = 0;
        }
      });
    } catch (e) {
      debugPrint('Failed to load forecast/history: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  double? _averageNum(List<dynamic> values) {
    final nums = values
        .map((e) => e is num ? e.toDouble() : double.tryParse('$e'))
        .whereType<double>()
        .toList();

    if (nums.isEmpty) return null;

    final sum = nums.reduce((a, b) => a + b);
    return sum / nums.length;
  }

  String _weekdayLabel(DateTime dt) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[dt.weekday - 1];
  }

  String _dateLabel(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}';
  }

  String _aqiCategory(int? aqi) {
    if (aqi == null) return '--';
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy SG';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  List<DailyForecastItem> get _displayItems {
    if (_historyDailyItems.isNotEmpty) return _historyDailyItems;
    if (data.dailyItems.isNotEmpty) return data.dailyItems;
    return const [
      DailyForecastItem(),
      DailyForecastItem(),
      DailyForecastItem(),
      DailyForecastItem(),
      DailyForecastItem(),
      DailyForecastItem(),
      DailyForecastItem(),
    ];
  }

  void _handleBottomNav(BuildContext context, int index, String location) {
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
        arguments: location,
      );
    } else if (index == 1) {
      return;
    } else if (index == 2) {
      Navigator.pushReplacementNamed(
        context,
        '/trends',
        arguments: location,
      );
    } else if (index == 3) {
      Navigator.pushReplacementNamed(
        context,
        '/health',
        arguments: location,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
            'Kuala Lumpur City Centre';

    final selectedItem = _displayItems[selectedDayIndex];

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardTopBrandBar(),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ForecastHeaderSection(),
                            if (data.showHighRiskAlert)
                              HighRiskAlertCard(
                                text: data.highRiskText ??
                                    'High-risk forecast alert will appear here when AQI exceeds your threshold.',
                              ),
                            ForecastLineChartCard(points: data.hourlyPoints),
                            RecommendationCardsSection(
                              bestTimeRange: data.bestTimeRange,
                              bestTimeDescription: data.bestTimeDescription,
                              bestTimeMeta: data.bestTimeMeta,
                              stayIndoorsRange: data.stayIndoorsRange,
                              stayIndoorsDescription:
                              data.stayIndoorsDescription,
                              stayIndoorsMeta: data.stayIndoorsMeta,
                              exerciseRange: data.exerciseRange,
                              exerciseDescription: data.exerciseDescription,
                              exerciseMeta: data.exerciseMeta,
                            ),
                            SevenDayBarChartCard(items: _displayItems),
                            DailyBreakdownGrid(
                              items: _displayItems,
                              selectedIndex: selectedDayIndex,
                              onSelected: (index) {
                                setState(() {
                                  selectedDayIndex = index;
                                });
                              },
                            ),
                            DetailedForecastCard(item: selectedItem),
                            if (_isLoadingHistory)
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
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
            currentIndex: 1,
            onTap: (index) => _handleBottomNav(context, index, location),
          ),
        ],
      ),
    );
  }
}