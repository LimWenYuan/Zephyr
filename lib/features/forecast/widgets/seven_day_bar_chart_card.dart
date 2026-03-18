import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/daily_forecast_item.dart';

class SevenDayBarChartCard extends StatefulWidget {
  final List<DailyForecastItem> items;

  const SevenDayBarChartCard({
    super.key,
    required this.items,
  });

  @override
  State<SevenDayBarChartCard> createState() => _SevenDayBarChartCardState();
}

class _SevenDayBarChartCardState extends State<SevenDayBarChartCard> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final hasData = widget.items.any((e) => e.aqi != null);

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
                final size = Size(constraints.maxWidth, 450);

                return MouseRegion(
                  onHover: (event) {
                    if (!hasData) return;
                    final index = _getHoveredIndex(
                      localPosition: event.localPosition,
                      size: size,
                      pointCount: math.min(widget.items.length, 7),
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
                        painter: _AreaChartFramePainter(widget.items),
                      ),
                      Positioned.fill(
                        child: hasData
                            ? CustomPaint(
                                painter: _AreaChartPainter(
                                  items: widget.items,
                                  hoveredIndex: _hoveredIndex,
                                ),
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
                      if (hasData && _hoveredIndex != null)
                        _TooltipOverlayDaily(
                          items: widget.items.take(7).toList(),
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
    required int pointCount,
  }) {
    const left = 60.0;
    const right = 30.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartWidth = chartRight - chartLeft;

    if (pointCount <= 1) return 0;

    final dx = localPosition.dx.clamp(chartLeft, chartRight);
    final ratio = ((dx - chartLeft) / chartWidth).clamp(0.0, 1.0);
    return (ratio * (pointCount - 1)).round();
  }
}

class _AreaChartFramePainter extends CustomPainter {
  final List<DailyForecastItem> items;

  _AreaChartFramePainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    const left = 60.0;
    const right = 30.0;
    const top = 20.0;
    const bottom = 52.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartTop = top;
    final chartBottom = size.height - bottom;
    final chartHeight = chartBottom - chartTop;
    final maxY = _computeMaxY(items);

    final axisPaint = Paint()
      ..color = const Color(0xFF666666)
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 4; i++) {
      final value = (maxY / 4) * i;
      final py = chartBottom - (value / maxY) * chartHeight;

      _drawDashedLine(
        canvas,
        Offset(chartLeft, py),
        Offset(chartRight, py),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: value.round().toString(),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartLeft - 28, py - 8));
    }

    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );

    final activeItems = items.take(7).toList();

    for (int i = 0; i < activeItems.length; i++) {
      final x = activeItems.length == 1
          ? chartLeft
          : chartLeft + (i / (activeItems.length - 1)) * (chartRight - chartLeft);

      textPainter.text = TextSpan(
        text: activeItems[i].weekday ?? '--',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartBottom + 12),
      );
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
    canvas.translate(
      chartLeft - 38,
      chartTop + chartHeight / 2 + textPainter.width / 2,
    );
    canvas.rotate(-1.5708);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  double _computeMaxY(List<DailyForecastItem> items) {
    final values = items
        .take(7)
        .map((e) => e.aqi?.toDouble())
        .whereType<double>()
        .toList();

    if (values.isEmpty) return 100;

    final rawMax = values.reduce(math.max);
    final stepped = (rawMax / 25).ceil() * 25;
    return math.max(100, stepped).toDouble();
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double x = start.dx;

    while (x < end.dx) {
      final x2 = (x + dashWidth).clamp(start.dx, end.dx);
      canvas.drawLine(Offset(x, start.dy), Offset(x2, start.dy), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartFramePainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<DailyForecastItem> items;
  final int? hoveredIndex;

  _AreaChartPainter({
    required this.items,
    required this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activeItems = items.take(7).toList();
    if (activeItems.isEmpty) return;

    const left = 60.0;
    const right = 30.0;
    const top = 20.0;
    const bottom = 52.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartBottom = size.height - bottom;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - top;
    final maxY = _computeMaxY(activeItems);

    final points = <Offset>[];

    for (int i = 0; i < activeItems.length; i++) {
      final aqi = (activeItems[i].aqi ?? 0).toDouble();
      final x = activeItems.length == 1
          ? chartLeft
          : chartLeft + (i / (activeItems.length - 1)) * chartWidth;
      final y = chartBottom - (aqi / maxY) * chartHeight;
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    final areaPath = Path()..moveTo(points.first.dx, chartBottom);
    for (final point in points) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath.lineTo(points.last.dx, chartBottom);
    areaPath.close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xAA7EC4D5),
          Color(0x227EC4D5),
        ],
      ).createShader(Rect.fromLTWH(chartLeft, top, chartWidth, chartHeight))
      ..style = PaintingStyle.fill;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF4CA3B6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(areaPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    final pointPaint = Paint()..color = const Color(0xFF4CA3B6);
    final pointFillPaint = Paint()..color = AppColors.white;

    for (int i = 0; i < points.length; i++) {
      final radius = hoveredIndex == i ? 7.0 : 5.5;
      canvas.drawCircle(points[i], radius, pointFillPaint);
      canvas.drawCircle(points[i], radius - 2, pointPaint);
    }
  }

  double _computeMaxY(List<DailyForecastItem> items) {
    final values = items.map((e) => e.aqi?.toDouble()).whereType<double>().toList();

    if (values.isEmpty) return 100;

    final rawMax = values.reduce(math.max);
    final stepped = (rawMax / 25).ceil() * 25;
    return math.max(100, stepped).toDouble();
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.hoveredIndex != hoveredIndex;
  }
}

class _TooltipOverlayDaily extends StatelessWidget {
  final List<DailyForecastItem> items;
  final int hoveredIndex;
  final Size size;

  const _TooltipOverlayDaily({
    required this.items,
    required this.hoveredIndex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    const left = 60.0;
    const right = 30.0;
    const top = 20.0;
    const bottom = 52.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartBottom = size.height - bottom;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - top;

    final item = items[hoveredIndex];
    final maxY = _computeMaxY(items);
    final aqi = (item.aqi ?? 0).toDouble();

    final dx = items.length == 1
        ? chartLeft
        : chartLeft + (hoveredIndex / (items.length - 1)) * chartWidth;
    final dy = chartBottom - (aqi / maxY) * chartHeight;

    final tooltipWidth = 170.0;

    double tooltipLeft = dx - tooltipWidth / 2;
    if (tooltipLeft < chartLeft) tooltipLeft = chartLeft;
    if (tooltipLeft + tooltipWidth > chartRight) {
      tooltipLeft = chartRight - tooltipWidth;
    }

    double tooltipTop = dy - 118;
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${item.weekday ?? '--'}${item.dateLabel != null ? ', ${item.dateLabel}' : ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AQI: ${item.aqi ?? '--'}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7EC4D5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.category ?? '--',
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

  double _computeMaxY(List<DailyForecastItem> items) {
    final values = items.map((e) => e.aqi?.toDouble()).whereType<double>().toList();

    if (values.isEmpty) return 100;

    final rawMax = values.reduce(math.max);
    final stepped = (rawMax / 25).ceil() * 25;
    return math.max(100, stepped).toDouble();
  }
}