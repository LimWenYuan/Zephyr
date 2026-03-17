import 'distribution_item.dart';
import 'insight_item.dart';
import 'trend_point.dart';
import 'trends_summary_data.dart';
import 'weekly_bar_item.dart';

class TrendsViewData {
  final int selectedRangeIndex;
  final List<TrendsSummaryData> summaries;
  final List<TrendPoint> historicalPoints;
  final List<WeeklyBarItem> weeklyBars;
  final List<DistributionItem> distributionItems;
  final List<InsightItem> insights;

  const TrendsViewData({
    this.selectedRangeIndex = 1,
    this.summaries = const [],
    this.historicalPoints = const [],
    this.weeklyBars = const [],
    this.distributionItems = const [],
    this.insights = const [],
  });
}