import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/weekly_bar_item.dart';

class TrendsBarChartCard extends StatefulWidget {
  final List<WeeklyBarItem> items;

  const TrendsBarChartCard({
    super.key,
    required this.items,
  });

  @override
  State<TrendsBarChartCard> createState() => _TrendsBarChartCardState();
}

class _TrendsBarChartCardState extends State<TrendsBarChartCard> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final hasData = widget.items.isNotEmpty;

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
                final size = Size(constraints.maxWidth, 400);

                return MouseRegion(
                  onHover: (event) {
                    if (!hasData) return;
                    final index = _getHoveredIndex(
                      localPosition: event.localPosition,
                      size: size,
                      itemCount: widget.items.length,
                    );
                    if (_hoveredIndex != index) {
                      setState(() {
                        _hoveredIndex = index;
                      });
                    }
                  },
                  onExit: (_) {
                    setState(() {
                      _hoveredIndex = null;
                    });
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: size,
                        painter: _WeeklyFramePainter(widget.items),
                      ),
                      Positioned.fill(
                        child: hasData
                            ? CustomPaint(
                                painter: _WeeklyBarsPainter(
                                  widget.items,
                                  hoveredIndex: _hoveredIndex,
                                ),
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
                      if (hasData && _hoveredIndex != null)
                        _TooltipOverlayWeeklyBar(
                          items: widget.items,
                          hoveredIndex: _hoveredIndex!,
                          size: size,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getHoveredIndex({
    required Offset localPosition,
    required Size size,
    required int itemCount,
  }) {
    const left = 60.0;
    const right = 20.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartWidth = chartRight - chartLeft;
    const gap = 10.0;

    final barWidth = (chartWidth - ((itemCount - 1) * gap)) / itemCount;
    final dx = localPosition.dx;

    for (int i = 0; i < itemCount; i++) {
      final start = chartLeft + i * (barWidth + gap);
      final end = start + barWidth;
      if (dx >= start && dx <= end) {
        return i;
      }
    }

    final ratio = ((dx - chartLeft) / chartWidth).clamp(0.0, 1.0);
    return (ratio * (itemCount - 1)).round();
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
    canvas.translate(
      chartLeft - 38,
      chartTop + chartHeight / 2 + textPainter.width / 2,
    );
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
  final int? hoveredIndex;

  _WeeklyBarsPainter(
    this.items, {
    required this.hoveredIndex,
  });

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

    const gap = 10.0;
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

      if (hoveredIndex == i) {
        final highlightPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.18);
        canvas.drawRRect(rect, highlightPaint);
      }

      textPainter.text = TextSpan(
        text: item.label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
      );
      textPainter.layout(maxWidth: barWidth + 20);
      textPainter.paint(
        canvas,
        Offset(
          chartLeft +
              i * (barWidth + gap) +
              barWidth / 2 -
              textPainter.width / 2,
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
    return oldDelegate.items != items ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}

class _TooltipOverlayWeeklyBar extends StatelessWidget {
  final List<WeeklyBarItem> items;
  final int hoveredIndex;
  final Size size;

  const _TooltipOverlayWeeklyBar({
    required this.items,
    required this.hoveredIndex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
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

    const gap = 10.0;
    final barWidth = (chartWidth - ((items.length - 1) * gap)) / items.length;

    final item = items[hoveredIndex];
    final dx = chartLeft + hoveredIndex * (barWidth + gap) + barWidth / 2;
    final dy = chartBottom - (item.value / maxY) * chartHeight;

    const tooltipWidth = 165.0;

    double tooltipLeft = dx - tooltipWidth / 2;
    if (tooltipLeft < chartLeft) tooltipLeft = chartLeft;
    if (tooltipLeft + tooltipWidth > chartRight) {
      tooltipLeft = chartRight - tooltipWidth;
    }

    double tooltipTop = dy - 105;
    if (tooltipTop < top) {
      tooltipTop = dy + 18;
    }

    return Stack(
      children: [
        Positioned(
          left: dx - 0.5,
          top: top,
          bottom: bottom,
          child: Container(
            width: 1,
            color: const Color(0x339CA3AF),
          ),
        ),
        Positioned(
          left: tooltipLeft,
          top: tooltipTop,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: tooltipWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AQI: ${item.value.round()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7EC4D5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _aqiCategory(item.value.round()),
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF4B5563),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _computeMaxY(List<WeeklyBarItem> items) {
    if (items.isEmpty) return 100;
    final rawMax = items.map((e) => e.value).reduce(math.max);
    final stepped = (rawMax / 50).ceil() * 50;
    return math.max(100, stepped).toDouble();
  }

  static String _aqiCategory(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy SG';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }
}