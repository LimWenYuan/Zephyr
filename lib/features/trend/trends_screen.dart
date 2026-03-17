import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/trends_history_service.dart';
import '../dashboard/widgets/dashboard_bottom_nav.dart';
import '../dashboard/widgets/dashboard_top_brand_bar.dart';
import 'models/distribution_item.dart';
import 'models/insight_item.dart';
import 'models/trends_summary_data.dart';
import 'models/trends_view_data.dart';
import 'models/weekly_bar_item.dart';
import 'widgets/trends_bar_chart_card.dart';
import 'widgets/trends_distribution_card.dart';
import 'widgets/trends_header_section.dart';
import 'widgets/trends_insights_card.dart';
import 'widgets/trends_line_chart_card.dart';
import 'widgets/trends_range_selector.dart';
import 'widgets/trends_summary_cards.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final TrendsHistoryService _trendsHistoryService = const TrendsHistoryService();

  static const List<int> _ranges = [7, 30, 90];

  int selectedRangeIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  TrendsViewData _data = const TrendsViewData(
    selectedRangeIndex: 0,
    summaries: [],
    historicalPoints: [],
    weeklyBars: [],
    distributionItems: [],
    insights: [],
  );

  String get _selectedLocation {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) {
      return args;
    }
    return 'Kuala Lumpur City Centre';
  }

  int get _selectedDays => _ranges[selectedRangeIndex];

  List<TrendsSummaryData> get _summaryItems =>
      _data.summaries.isNotEmpty
          ? _data.summaries
          : const [
        TrendsSummaryData(
          title: 'Average AQI',
          valueText: '--',
          subtitle: 'No data yet',
          valueColor: AppColors.primary,
        ),
        TrendsSummaryData(
          title: 'Highest AQI',
          valueText: '--',
          subtitle: 'No data yet',
          valueColor: Color(0xFFEA580C),
        ),
        TrendsSummaryData(
          title: 'Lowest AQI',
          valueText: '--',
          subtitle: 'No data yet',
          valueColor: Color(0xFF16A34A),
        ),
        TrendsSummaryData(
          title: 'Unhealthy Days',
          valueText: '--',
          subtitle: 'No data yet',
          valueColor: Color(0xFFDC2626),
        ),
      ];

  List<WeeklyBarItem> get _weeklyItems =>
      _data.weeklyBars.isNotEmpty
          ? _data.weeklyBars
          : const [
        WeeklyBarItem(label: 'Week 1', value: 0),
        WeeklyBarItem(label: 'Week 2', value: 0),
        WeeklyBarItem(label: 'Week 3', value: 0),
        WeeklyBarItem(label: 'Week 4', value: 0),
      ];

  List<DistributionItem> get _distributionItems =>
      _data.distributionItems.isNotEmpty
          ? _data.distributionItems
          : const [
        DistributionItem(
          label: 'Good',
          count: 0,
          percentage: 0,
          color: Color(0xFF6BB8A8),
        ),
        DistributionItem(
          label: 'Moderate',
          count: 0,
          percentage: 0,
          color: Color(0xFF7EC4D5),
        ),
      ];

  List<InsightItem> get _insightItems =>
      _data.insights.isNotEmpty
          ? _data.insights
          : const [
        InsightItem(
          title: 'Daily Pattern',
          body: 'Insights will appear when trend data is available.',
          borderColor: Color(0xFF3B82F6),
          backgroundColor: Color(0xFFEFF6FF),
          titleColor: Color(0xFF1E40AF),
          bodyColor: Color(0xFF1D4ED8),
        ),
        InsightItem(
          title: 'Weekly Pattern',
          body: 'Insights will appear when trend data is available.',
          borderColor: Color(0xFF22C55E),
          backgroundColor: Color(0xFFF0FDF4),
          titleColor: Color(0xFF166534),
          bodyColor: Color(0xFF15803D),
        ),
        InsightItem(
          title: 'Seasonal Consideration',
          body: 'Insights will appear when trend data is available.',
          borderColor: Color(0xFFF97316),
          backgroundColor: Color(0xFFFFF7ED),
          titleColor: Color(0xFF9A3412),
          bodyColor: Color(0xFFC2410C),
        ),
        InsightItem(
          title: 'Long-term Planning',
          body: 'Insights will appear when trend data is available.',
          borderColor: Color(0xFFA855F7),
          backgroundColor: Color(0xFFFAF5FF),
          titleColor: Color(0xFF6B21A8),
          bodyColor: Color(0xFF7E22CE),
        ),
      ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _trendsHistoryService.loadTrends(
        days: _selectedDays,
        location: _selectedLocation,
      );

      if (!mounted) return;

      setState(() {
        _data = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
        _data = const TrendsViewData(
          selectedRangeIndex: 0,
          summaries: [],
          historicalPoints: [],
          weeklyBars: [],
          distributionItems: [],
          insights: [],
        );
      });
    }
  }

  void _handleBottomNav(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        '/dashboard',
        arguments: _selectedLocation,
      );
    } else if (index == 1) {
      Navigator.pushReplacementNamed(
        context,
        '/forecast',
        arguments: _selectedLocation,
      );
    } else if (index == 2) {
      return;
    } else if (index == 3) {
      Navigator.pushReplacementNamed(
        context,
        '/health',
        arguments: _selectedLocation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showWeeklyChart = selectedRangeIndex != 0;

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
                            const TrendsHeaderSection(),
                            TrendsRangeSelector(
                              selectedIndex: selectedRangeIndex,
                              onSelected: (index) async {
                                if (index == selectedRangeIndex) return;

                                setState(() {
                                  selectedRangeIndex = index;
                                });

                                await _loadData();
                              },
                            ),
                            if (_isLoading)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: LinearProgressIndicator(),
                              ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  'Failed to load trend data: $_errorMessage',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            TrendsSummaryCards(items: _summaryItems),
                            TrendsLineChartCard(points: _data.historicalPoints),
                            if (showWeeklyChart)
                              TrendsBarChartCard(items: _weeklyItems),
                            TrendsDistributionCard(items: _distributionItems),
                            TrendsInsightsCard(items: _insightItems),
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
            currentIndex: 2,
            onTap: (index) => _handleBottomNav(context, index),
          ),
        ],
      ),
    );
  }
}