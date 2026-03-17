class DailyForecastItem {
  final String? weekday;
  final String? dateLabel;
  final int? aqi;
  final String? category;
  final String? temperature;
  final String? humidity;

  const DailyForecastItem({
    this.weekday,
    this.dateLabel,
    this.aqi,
    this.category,
    this.temperature,
    this.humidity,
  });
}