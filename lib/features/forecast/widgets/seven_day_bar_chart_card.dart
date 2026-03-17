import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/daily_forecast_item.dart';

class SevenDayBarChartCard extends StatelessWidget {
  final List<DailyForecastItem> items;

  const SevenDayBarChartCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = items.any((e) => e.aqi != null);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 28,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              Text(
                '7-Day Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 450,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, 450),
                      painter: _BarChartFramePainter(),
                    ),
                    Positioned.fill(
                      child: hasData
                          ? CustomPaint(
                              painter: _BarChartPainter(items: items),
                            )
                          : const Center(
                              child: Text(
                                'No 7-day forecast data yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarChartFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const left = 60.0;
    const right = 40.0;
    const top = 20.0;
    const bottom = 40.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartTop = top;
    final chartBottom = size.height - bottom;
    final chartHeight = chartBottom - chartTop;

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int y = 0; y <= 100; y += 25) {
      final py = chartBottom - (y / 100) * chartHeight;
      canvas.drawLine(
        Offset(chartLeft, py),
        Offset(chartRight, py),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: '$y',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartLeft - 28, py - 8));
    }

    final labels = ['Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', 'Mon'];

    for (int i = 0; i < labels.length; i++) {
      final barWidth = (chartRight - chartLeft - 6 * 10) / 7;
      final x = chartLeft + i * (barWidth + 10) + barWidth / 2;

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, chartBottom + 12));
    }

    textPainter.text = const TextSpan(
      text: 'AQI',
      style: TextStyle(
        fontSize: 14,
        color: Color(0xFF6B7280),
      ),
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(chartLeft - 40, chartTop + chartHeight / 2 + textPainter.width / 2);
    canvas.rotate(-1.5708);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChartPainter extends CustomPainter {
  final List<DailyForecastItem> items;

  _BarChartPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    const left = 60.0;
    const right = 40.0;
    const top = 20.0;
    const bottom = 40.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartTop = top;
    final chartBottom = size.height - bottom;
    final chartHeight = chartBottom - chartTop;

    final activeItems = items.take(7).toList();
    if (activeItems.isEmpty) return;

    final barWidth = (chartRight - chartLeft - ((activeItems.length - 1) * 10)) /
        activeItems.length;

    for (int i = 0; i < activeItems.length; i++) {
      final item = activeItems[i];
      final aqi = (item.aqi ?? 0).clamp(0, 100).toDouble();
      final barHeight = (aqi / 100) * chartHeight;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          chartLeft + i * (barWidth + 10),
          chartBottom - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      );

      final paint = Paint()..color = _barColor(item.aqi);
      canvas.drawRRect(rect, paint);
    }
  }

  Color _barColor(int? aqi) {
    if (aqi == null) return const Color(0xFF7EC4D5);
    if (aqi <= 50) return const Color(0xFF6BB8A8);
    if (aqi <= 100) return const Color(0xFF7EC4D5);
    if (aqi <= 150) return const Color(0xFFF4C84F);
    if (aqi <= 200) return const Color(0xFFF89C4F);
    if (aqi <= 300) return const Color(0xFFE67E73);
    return const Color(0xFFC85A5A);
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.items != items;
}