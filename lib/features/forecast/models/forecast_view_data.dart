import 'daily_forecast_item.dart';
import 'hourly_forecast_point.dart';

class ForecastViewData {
  final List<HourlyForecastPoint> hourlyPoints;
  final List<DailyForecastItem> dailyItems;

  final String? bestTimeRange;
  final String? bestTimeDescription;
  final String? bestTimeMeta;

  final String? stayIndoorsRange;
  final String? stayIndoorsDescription;
  final String? stayIndoorsMeta;

  final String? exerciseRange;
  final String? exerciseDescription;
  final String? exerciseMeta;

  final bool showHighRiskAlert;
  final String? highRiskText;

  final int selectedNavIndex;

  const ForecastViewData({
    this.hourlyPoints = const [],
    this.dailyItems = const [],
    this.bestTimeRange,
    this.bestTimeDescription,
    this.bestTimeMeta,
    this.stayIndoorsRange,
    this.stayIndoorsDescription,
    this.stayIndoorsMeta,
    this.exerciseRange,
    this.exerciseDescription,
    this.exerciseMeta,
    this.showHighRiskAlert = false,
    this.highRiskText,
    this.selectedNavIndex = 1,
  });
}