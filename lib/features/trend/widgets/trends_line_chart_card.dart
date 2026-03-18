import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/trend_point.dart';

class TrendsLineChartCard extends StatefulWidget {
  final List<TrendPoint> points;

  const TrendsLineChartCard({
    super.key,
    required this.points,
  });

  @override
  State<TrendsLineChartCard> createState() => _TrendsLineChartCardState();
}

class _TrendsLineChartCardState extends State<TrendsLineChartCard> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final hasData = widget.points.isNotEmpty;

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
                Icons.trending_up,
                size: 28,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              Text(
                'Historical Air Quality Trend',
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
                      pointCount: widget.points.length,
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
                        painter: _HistoricalFramePainter(widget.points),
                      ),
                      Positioned.fill(
                        child: hasData
                            ? CustomPaint(
                                painter: _HistoricalLinePainter(
                                  widget.points,
                                  hoveredIndex: _hoveredIndex,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No historical trend data yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ),
                      ),
                      if (hasData && _hoveredIndex != null)
                        _TooltipOverlayTrendLine(
                          points: widget.points,
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

class _HistoricalFramePainter extends CustomPainter {
  final List<TrendPoint> points;

  _HistoricalFramePainter(this.points);

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
    final maxY = _computeMaxY(points);

    final axisPaint = Paint()
      ..color = const Color(0xFF666666)
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

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
        style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartLeft - 36, py - 8));
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

    final xLabels = _visibleLabels(points);

    for (final entry in xLabels.entries) {
      final x = chartLeft + entry.key * (chartRight - chartLeft);

      textPainter.text = TextSpan(
        text: entry.value,
        style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartBottom + 12),
      );
    }

    textPainter.text = const TextSpan(
      text: 'AQI',
      style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(
      chartLeft - 42,
      chartTop + chartHeight / 2 + textPainter.width / 2,
    );
    canvas.rotate(-1.5708);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  Map<double, String> _visibleLabels(List<TrendPoint> points) {
    if (points.isEmpty) return {};

    if (points.length <= 7) {
      final map = <double, String>{};
      for (int i = 0; i < points.length; i++) {
        final pos = points.length == 1 ? 0.0 : i / (points.length - 1);
        map[pos] = points[i].label;
      }
      return map;
    }

    const visibleCount = 6;
    final map = <double, String>{};

    for (int i = 0; i < visibleCount; i++) {
      final pointIndex =
          ((points.length - 1) * (i / (visibleCount - 1))).round();
      final pos = i / (visibleCount - 1);
      map[pos] = points[pointIndex].label;
    }

    return map;
  }

  double _computeMaxY(List<TrendPoint> points) {
    if (points.isEmpty) return 100;
    final rawMax = points.map((e) => e.value).reduce(math.max);
    final stepped = (rawMax / 50).ceil() * 50;
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
  bool shouldRepaint(covariant _HistoricalFramePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _HistoricalLinePainter extends CustomPainter {
  final List<TrendPoint> points;
  final int? hoveredIndex;

  _HistoricalLinePainter(
    this.points, {
    required this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const left = 60.0;
    const right = 30.0;
    const top = 20.0;
    const bottom = 52.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartBottom = size.height - bottom;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - top;
    final maxY = _computeMaxY(points);

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()..color = AppColors.primary;
    final pointFillPaint = Paint()..color = AppColors.white;
    final path = Path();
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = points.length == 1
          ? chartLeft
          : chartLeft + (i / (points.length - 1)) * chartWidth;
      final y = chartBottom - (points[i].value / maxY) * chartHeight;
      offsets.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < offsets.length; i++) {
      final radius = hoveredIndex == i ? 6.0 : 4.5;
      canvas.drawCircle(offsets[i], radius, pointFillPaint);
      canvas.drawCircle(offsets[i], radius - 1.8, pointPaint);
    }
  }

  double _computeMaxY(List<TrendPoint> points) {
    if (points.isEmpty) return 100;
    final rawMax = points.map((e) => e.value).reduce(math.max);
    final stepped = (rawMax / 50).ceil() * 50;
    return math.max(100, stepped).toDouble();
  }

  @override
  bool shouldRepaint(covariant _HistoricalLinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}

class _TooltipOverlayTrendLine extends StatelessWidget {
  final List<TrendPoint> points;
  final int hoveredIndex;
  final Size size;

  const _TooltipOverlayTrendLine({
    required this.points,
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
    final maxY = _computeMaxY(points);

    final point = points[hoveredIndex];
    final dx = points.length == 1
        ? chartLeft
        : chartLeft + (hoveredIndex / (points.length - 1)) * chartWidth;
    final dy = chartBottom - (point.value / maxY) * chartHeight;

    const tooltipWidth = 150.0;

    double tooltipLeft = dx - tooltipWidth / 2;
    if (tooltipLeft < chartLeft) tooltipLeft = chartLeft;
    if (tooltipLeft + tooltipWidth > chartRight) {
      tooltipLeft = chartRight - tooltipWidth;
    }

    double tooltipTop = dy - 110;
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
                    point.label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AQI: ${point.value.round()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7EC4D5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _aqiCategory(point.value.round()),
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

  double _computeMaxY(List<TrendPoint> points) {
    if (points.isEmpty) return 100;
    final rawMax = points.map((e) => e.value).reduce(math.max);
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