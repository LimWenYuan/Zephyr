import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/air_quality_service.dart';
import '../../features/trend/models/distribution_item.dart';
import '../../features/trend/models/insight_item.dart';
import '../../features/trend/models/trend_point.dart';
import '../../features/trend/models/trends_summary_data.dart';
import '../../features/trend/models/trends_view_data.dart';
import '../../features/trend/models/weekly_bar_item.dart';

class TrendsHistoryService {
  const TrendsHistoryService();

  static const String _tableName = 'air_quality_reading';

  SupabaseClient get _client => Supabase.instance.client;

  Future<TrendsViewData> loadTrends({
    required int days,
    required String location,
  }) async {
    final rows = await _fetchDailyRows(
      days: days,
      location: location,
    );

    if (rows.isEmpty) {
      return const TrendsViewData(
        summaries: [],
        historicalPoints: [],
        weeklyBars: [],
        distributionItems: [],
        insights: [],
      );
    }

    rows.sort((a, b) => a.date.compareTo(b.date));

    final values = rows.map((e) => e.aqi).toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final highestRow = rows.reduce((a, b) => a.aqi >= b.aqi ? a : b);
    final lowestRow = rows.reduce((a, b) => a.aqi <= b.aqi ? a : b);
    final unhealthyDays = rows.where((e) => e.aqi > 100).length;

    final historicalPoints = rows
        .map(
          (row) => TrendPoint(
        label: _formatShortDate(row.date),
        value: row.aqi,
      ),
    )
        .toList();

    final weeklyBars = days == 7 ? <WeeklyBarItem>[] : _buildWeeklyBars(rows);
    final distributionItems = _buildDistribution(rows);
    final insights = _buildInsights(
      rows: rows,
      average: average,
      unhealthyDays: unhealthyDays,
      highestRow: highestRow,
      lowestRow: lowestRow,
    );

    return TrendsViewData(
      summaries: [
        TrendsSummaryData(
          title: 'Average AQI',
          valueText: average.toStringAsFixed(0),
          subtitle: '${rows.length} days recorded',
          valueColor: const Color(0xFF0F766E),
        ),
        TrendsSummaryData(
          title: 'Highest AQI',
          valueText: highestRow.aqi.toStringAsFixed(0),
          subtitle: _formatLongDate(highestRow.date),
          valueColor: const Color(0xFFEA580C),
        ),
        TrendsSummaryData(
          title: 'Lowest AQI',
          valueText: lowestRow.aqi.toStringAsFixed(0),
          subtitle: _formatLongDate(lowestRow.date),
          valueColor: const Color(0xFF16A34A),
        ),
        TrendsSummaryData(
          title: 'Unhealthy Days',
          valueText: unhealthyDays.toString(),
          subtitle: 'AQI above 100',
          valueColor: const Color(0xFFDC2626),
        ),
      ],
      historicalPoints: historicalPoints,
      weeklyBars: weeklyBars,
      distributionItems: distributionItems,
      insights: insights,
    );
  }

  Future<List<_TrendRow>> _fetchDailyRows({
    required int days,
    required String location,
  }) async {
    final stationId = _stationIdFromLocation(location);
    if (stationId == null) return [];

    final now = DateTime.now().toUtc();
    final fromDate = now.subtract(Duration(days: days + 7));

    final response = await _client
        .from(_tableName)
        .select('station_id, api_value, created_at')
        .eq('station_id', stationId)
        .gte('created_at', fromDate.toIso8601String())
        .order('created_at', ascending: false);

    final Map<String, List<double>> grouped = {};

    for (final row in response) {
      final map = row;

      final createdAtRaw = map['created_at'];
      final apiValueRaw = map['api_value'];

      if (createdAtRaw == null || apiValueRaw == null) continue;

      final createdAt = DateTime.tryParse(createdAtRaw.toString());
      if (createdAt == null) continue;

      final aqi = (apiValueRaw as num).toDouble();

      final dateKey = _dateOnlyKey(createdAt.toLocal());
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(aqi);
    }

    final dailyRows = grouped.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final values = entry.value;
      final avg = values.reduce((a, b) => a + b) / values.length;

      return _TrendRow(
        date: date,
        aqi: avg,
      );
    }).toList();

    dailyRows.sort((a, b) => a.date.compareTo(b.date));

    if (dailyRows.length > days) {
      return dailyRows.sublist(dailyRows.length - days);
    }

    return dailyRows;
  }

  int? _stationIdFromLocation(String location) {
    final names = AirQualityService.locationNames;
    final index = names.indexWhere(
          (name) => name.trim().toLowerCase() == location.trim().toLowerCase(),
    );

    if (index == -1) return null;

    return index + 1;
  }

  List<WeeklyBarItem> _buildWeeklyBars(List<_TrendRow> rows) {
    if (rows.isEmpty) return [];

    final List<List<_TrendRow>> chunks = [];
    for (int i = 0; i < rows.length; i += 7) {
      final end = math.min(i + 7, rows.length);
      chunks.add(rows.sublist(i, end));
    }

    return chunks.map((chunk) {
      final avg = chunk.map((e) => e.aqi).reduce((a, b) => a + b) / chunk.length;
      final start = chunk.first.date;
      final end = chunk.last.date;

      return WeeklyBarItem(
        label: '${_formatMiniDate(start)}-${_formatMiniDate(end)}',
        value: avg,
      );
    }).toList();
  }

  List<DistributionItem> _buildDistribution(List<_TrendRow> rows) {
    if (rows.isEmpty) return const [];

    final total = rows.length;

    final buckets = <String, int>{
      'Good': 0,
      'Moderate': 0,
      'Unhealthy for SG': 0,
      'Unhealthy': 0,
      'Very Unhealthy': 0,
      'Hazardous': 0,
    };

    for (final row in rows) {
      final aqi = row.aqi;

      if (aqi <= 50) {
        buckets['Good'] = buckets['Good']! + 1;
      } else if (aqi <= 100) {
        buckets['Moderate'] = buckets['Moderate']! + 1;
      } else if (aqi <= 150) {
        buckets['Unhealthy for SG'] = buckets['Unhealthy for SG']! + 1;
      } else if (aqi <= 200) {
        buckets['Unhealthy'] = buckets['Unhealthy']! + 1;
      } else if (aqi <= 300) {
        buckets['Very Unhealthy'] = buckets['Very Unhealthy']! + 1;
      } else {
        buckets['Hazardous'] = buckets['Hazardous']! + 1;
      }
    }

    const colors = <String, Color>{
      'Good': Color(0xFF22C55E),
      'Moderate': Color(0xFFEAB308),
      'Unhealthy for SG': Color(0xFFF97316),
      'Unhealthy': Color(0xFFEF4444),
      'Very Unhealthy': Color(0xFF8B5CF6),
      'Hazardous': Color(0xFF7F1D1D),
    };

    return buckets.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => DistributionItem(
        label: entry.key,
        count: entry.value,
        percentage: ((entry.value / total) * 100).round(),
        color: colors[entry.key]!,
      ),
    )
        .toList();
  }

  List<InsightItem> _buildInsights({
    required List<_TrendRow> rows,
    required double average,
    required int unhealthyDays,
    required _TrendRow highestRow,
    required _TrendRow lowestRow,
  }) {
    final first = rows.first.aqi;
    final last = rows.last.aqi;
    final delta = last - first;

    final trendText = delta > 8
        ? 'Air quality is trending worse over this period.'
        : delta < -8
        ? 'Air quality is trending better over this period.'
        : 'Air quality remained relatively stable over this period.';

    final unhealthyPct = ((unhealthyDays / rows.length) * 100).round();

    return [
      const InsightItem(
        title: 'Daily Pattern',
        body: 'Trend is calculated from one daily batch grouped by created_at date.',
        borderColor: Color(0xFF3B82F6),
        backgroundColor: Color(0xFFEFF6FF),
        titleColor: Color(0xFF1E40AF),
        bodyColor: Color(0xFF1D4ED8),
      ),
      InsightItem(
        title: 'Weekly Pattern',
        body: 'Average AQI for this selected range is ${average.toStringAsFixed(0)}. $trendText',
        borderColor: const Color(0xFF22C55E),
        backgroundColor: const Color(0xFFF0FDF4),
        titleColor: const Color(0xFF166534),
        bodyColor: const Color(0xFF15803D),
      ),
      InsightItem(
        title: 'Highest Risk Day',
        body: 'Worst day was ${_formatLongDate(highestRow.date)} with AQI ${highestRow.aqi.toStringAsFixed(0)}.',
        borderColor: const Color(0xFFF97316),
        backgroundColor: const Color(0xFFFFF7ED),
        titleColor: const Color(0xFF9A3412),
        bodyColor: const Color(0xFFC2410C),
      ),
      InsightItem(
        title: 'Long-term Planning',
        body: '$unhealthyPct% of selected days were above AQI 100. Best day was ${_formatLongDate(lowestRow.date)}.',
        borderColor: const Color(0xFFA855F7),
        backgroundColor: const Color(0xFFFAF5FF),
        titleColor: const Color(0xFF6B21A8),
        bodyColor: const Color(0xFF7E22CE),
      ),
    ];
  }

  String _dateOnlyKey(DateTime dt) {
    final local = DateTime(dt.year, dt.month, dt.day);
    return local.toIso8601String().split('T').first;
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatMiniDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  String _formatLongDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _TrendRow {
  final DateTime date;
  final double aqi;

  const _TrendRow({
    required this.date,
    required this.aqi,
  });
}