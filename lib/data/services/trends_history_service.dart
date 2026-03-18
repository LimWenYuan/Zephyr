import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../features/trend/models/distribution_item.dart';
import '../../features/trend/models/insight_item.dart';
import '../../features/trend/models/trend_point.dart';
import '../../features/trend/models/trends_summary_data.dart';
import '../../features/trend/models/trends_view_data.dart';
import '../../features/trend/models/weekly_bar_item.dart';

class TrendsHistoryService {
  const TrendsHistoryService();

  Future<TrendsViewData> loadTrends({
    required int days,
    required String location,
  }) async {
    final rows = _buildDemoRows(
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
      location: location,
    );

    return TrendsViewData(
      summaries: [
        TrendsSummaryData(
          title: 'Average AQI',
          valueText: average.toStringAsFixed(0),
          subtitle: '${rows.length} days',
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

  List<_TrendRow> _buildDemoRows({
    required int days,
    required String location,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final seed = _locationSeed(location);
    final profile = _locationProfile(location);

    final rows = <_TrendRow>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));

      final waveA = math.sin((days - i + seed) * 0.55) * profile.waveA;
      final waveB = math.cos((days - i + seed) * 0.22) * profile.waveB;
      final weeklyEffect = ((date.weekday % 3) - 1) * profile.weeklySwing;
      final trendBias = ((days - i) / days) * profile.trendBias;

      final value = profile.base + waveA + waveB + weeklyEffect + trendBias;

      rows.add(
        _TrendRow(
          date: date,
          aqi: value.clamp(profile.minClamp, profile.maxClamp).toDouble(),
        ),
      );
    }

    return rows;
  }

  _DemoProfile _locationProfile(String location) {
    final normalized = location.trim().toLowerCase();

    if (normalized.contains('kuala lumpur')) {
      return const _DemoProfile(
        base: 72,
        waveA: 13,
        waveB: 8,
        weeklySwing: 4,
        trendBias: 6,
        minClamp: 46,
        maxClamp: 118,
      );
    }

    if (normalized.contains('subang') || normalized.contains('shah alam')) {
      return const _DemoProfile(
        base: 78,
        waveA: 14,
        waveB: 9,
        weeklySwing: 5,
        trendBias: 8,
        minClamp: 50,
        maxClamp: 126,
      );
    }

    if (normalized.contains('putrajaya')) {
      return const _DemoProfile(
        base: 60,
        waveA: 10,
        waveB: 7,
        weeklySwing: 3,
        trendBias: 4,
        minClamp: 38,
        maxClamp: 98,
      );
    }

    if (normalized.contains('klang')) {
      return const _DemoProfile(
        base: 82,
        waveA: 15,
        waveB: 10,
        weeklySwing: 5,
        trendBias: 7,
        minClamp: 54,
        maxClamp: 132,
      );
    }

    if (normalized.contains('johor')) {
      return const _DemoProfile(
        base: 66,
        waveA: 11,
        waveB: 7,
        weeklySwing: 4,
        trendBias: 5,
        minClamp: 42,
        maxClamp: 104,
      );
    }

    if (normalized.contains('kuching') || normalized.contains('miri')) {
      return const _DemoProfile(
        base: 52,
        waveA: 9,
        waveB: 6,
        weeklySwing: 3,
        trendBias: 3,
        minClamp: 34,
        maxClamp: 88,
      );
    }

    return const _DemoProfile(
      base: 68,
      waveA: 12,
      waveB: 8,
      weeklySwing: 4,
      trendBias: 5,
      minClamp: 40,
      maxClamp: 110,
    );
  }

  int _locationSeed(String location) {
    return location.codeUnits.fold<int>(0, (sum, item) => sum + item) % 17;
  }

  List<WeeklyBarItem> _buildWeeklyBars(List<_TrendRow> rows) {
    if (rows.isEmpty) return [];

    final List<List<_TrendRow>> chunks = [];
    for (int i = 0; i < rows.length; i += 7) {
      final end = math.min(i + 7, rows.length);
      chunks.add(rows.sublist(i, end));
    }

    return chunks.map((chunk) {
      final avg =
          chunk.map((e) => e.aqi).reduce((a, b) => a + b) / chunk.length;
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
    required String location,
  }) {
    final first = rows.first.aqi;
    final last = rows.last.aqi;
    final delta = last - first;

    final trendText = delta > 8
        ? 'Air quality is trending worse across the selected period.'
        : delta < -8
            ? 'Air quality is trending better across the selected period.'
            : 'Air quality remained relatively stable across the selected period.';

    final unhealthyPct = ((unhealthyDays / rows.length) * 100).round();

    return [
      InsightItem(
        title: 'Daily Pattern',
        body:
            'This demo trend simulates realistic AQI variation for $location across the selected range.',
        borderColor: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFFEFF6FF),
        titleColor: const Color(0xFF1E40AF),
        bodyColor: const Color(0xFF1D4ED8),
      ),
      InsightItem(
        title: 'Weekly Pattern',
        body:
            'Average AQI for this selected range is ${average.toStringAsFixed(0)}. $trendText',
        borderColor: const Color(0xFF22C55E),
        backgroundColor: const Color(0xFFF0FDF4),
        titleColor: const Color(0xFF166534),
        bodyColor: const Color(0xFF15803D),
      ),
      InsightItem(
        title: 'Highest Risk Day',
        body:
            'Highest AQI appears on ${_formatLongDate(highestRow.date)} at ${highestRow.aqi.toStringAsFixed(0)}.',
        borderColor: const Color(0xFFF97316),
        backgroundColor: const Color(0xFFFFF7ED),
        titleColor: const Color(0xFF9A3412),
        bodyColor: const Color(0xFFC2410C),
      ),
      InsightItem(
        title: 'Long-term Planning',
        body:
            '$unhealthyPct% of selected days are above AQI 100. Best air quality appears on ${_formatLongDate(lowestRow.date)}.',
        borderColor: const Color(0xFFA855F7),
        backgroundColor: const Color(0xFFFAF5FF),
        titleColor: const Color(0xFF6B21A8),
        bodyColor: const Color(0xFF7E22CE),
      ),
    ];
  }

  String _formatShortDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatMiniDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  String _formatLongDate(DateTime date) {
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

class _DemoProfile {
  final double base;
  final double waveA;
  final double waveB;
  final double weeklySwing;
  final double trendBias;
  final double minClamp;
  final double maxClamp;

  const _DemoProfile({
    required this.base,
    required this.waveA,
    required this.waveB,
    required this.weeklySwing,
    required this.trendBias,
    required this.minClamp,
    required this.maxClamp,
  });
}