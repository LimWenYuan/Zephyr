import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/weekly_bar_item.dart';

class TrendsBarChartCard extends StatelessWidget {
  final List<WeeklyBarItem> items;

  const TrendsBarChartCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = items.isNotEmpty;

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
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 28,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              Text(
                'Weekly Average Comparison',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 400,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, 400),
                      painter: _WeeklyFramePainter(items),
                    ),
                    Positioned.fill(
                      child: hasData
                          ? CustomPaint(
                        painter: _WeeklyBarsPainter(items),
                      )
                          : const Center(
                        child: Text(
                          'No weekly comparison data yet',
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

class _WeeklyFramePainter extends CustomPainter {
  final List<WeeklyBarItem> items;

  _WeeklyFramePainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    const left = 60.0;
    const right = 20.0;
    const top = 20.0;
    const bottom = 52.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartTop = top;
    final chartBottom = size.height - bottom;
    final chartHeight = chartBottom - chartTop;
    final maxY = _computeMaxY(items);

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i <= 4; i++) {
      final value = (maxY / 4) * i;
      final py = chartBottom - (value / maxY) * chartHeight;

      canvas.drawLine(
        Offset(chartLeft, py),
        Offset(chartRight, py),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: value.round().toString(),
        style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartLeft - 36, py - 8));
    }

    textPainter.text = const TextSpan(
      text: 'AQI',
      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(chartLeft - 38, chartTop + chartHeight / 2 + textPainter.width / 2);
    canvas.rotate(-1.5708);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  double _computeMaxY(List<WeeklyBarItem> items) {
    if (items.isEmpty) return 100;
    final rawMax = items.map((e) => e.value).reduce(math.max);
    final stepped = (rawMax / 50).ceil() * 50;
    return math.max(100, stepped).toDouble();
  }

  @override
  bool shouldRepaint(covariant _WeeklyFramePainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

class _WeeklyBarsPainter extends CustomPainter {
  final List<WeeklyBarItem> items;

  _WeeklyBarsPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    const left = 60.0;
    const right = 20.0;
    const top = 20.0;
    const bottom = 52.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartBottom = size.height - bottom;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - top;
    final maxY = _computeMaxY(items);

    final gap = 10.0;
    final barWidth = (chartWidth - ((items.length - 1) * gap)) / items.length;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final barHeight = (item.value / maxY) * chartHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          chartLeft + i * (barWidth + gap),
          chartBottom - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(4),
      );

      final paint = Paint()..color = _barColor(item.value);
      canvas.drawRRect(rect, paint);

      textPainter.text = TextSpan(
        text: item.label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
      );
      textPainter.layout(maxWidth: barWidth + 20);
      textPainter.paint(
        canvas,
        Offset(
          chartLeft + i * (barWidth + gap) + barWidth / 2 - textPainter.width / 2,
          chartBottom + 12,
        ),
      );
    }
  }

  double _computeMaxY(List<WeeklyBarItem> items) {
    if (items.isEmpty) return 100;
    final rawMax = items.map((e) => e.value).reduce(math.max);
    final stepped = (rawMax / 50).ceil() * 50;
    return math.max(100, stepped).toDouble();
  }

  Color _barColor(double value) {
    if (value <= 50) return const Color(0xFF22C55E);
    if (value <= 100) return const Color(0xFFEAB308);
    if (value <= 150) return const Color(0xFFF97316);
    if (value <= 200) return const Color(0xFFEF4444);
    if (value <= 300) return const Color(0xFF8B5CF6);
    return const Color(0xFF7F1D1D);
  }

  @override
  bool shouldRepaint(covariant _WeeklyBarsPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}