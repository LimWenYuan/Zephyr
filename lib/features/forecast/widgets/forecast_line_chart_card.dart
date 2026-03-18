import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/hourly_forecast_point.dart';

class ForecastLineChartCard extends StatefulWidget {
  final List<HourlyForecastPoint> points;

  const ForecastLineChartCard({
    super.key,
    required this.points,
  });

  @override
  State<ForecastLineChartCard> createState() => _ForecastLineChartCardState();
}

class _ForecastLineChartCardState extends State<ForecastLineChartCard> {
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
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '24-Hour Forecast',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 450,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;

                return MouseRegion(
                  onHover: (event) {
                    if (!hasData) return;
                    final index = _getHoveredIndex(
                      localPosition: event.localPosition,
                      size: Size(chartWidth, 450),
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
                        size: Size(chartWidth, 450),
                        painter: _LineChartFramePainter(),
                      ),
                      Positioned.fill(
                        child: hasData
                            ? CustomPaint(
                                painter: _LineSeriesPainter(
                                  points: widget.points,
                                  hoveredIndex: _hoveredIndex,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'No hourly forecast data yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ),
                      ),
                      if (hasData && _hoveredIndex != null)
                        _TooltipOverlayHourly(
                          points: widget.points,
                          hoveredIndex: _hoveredIndex!,
                          size: Size(chartWidth, 450),
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
    const left = 80.0;
    const right = 100.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartWidth = chartRight - chartLeft;

    if (pointCount <= 1) return 0;

    final dx = localPosition.dx.clamp(chartLeft, chartRight);
    final ratio = ((dx - chartLeft) / chartWidth).clamp(0.0, 1.0);
    return (ratio * (pointCount - 1)).round();
  }
}

class _LineChartFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const left = 80.0;
    const right = 100.0;
    const top = 30.0;
    const bottom = 50.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartTop = top;
    final chartBottom = size.height - bottom;
    final chartHeight = chartBottom - chartTop;

    final axisPaint = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1.5;

    final gridPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

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

    final thresholds = [
      (50.0, 'Good'),
      (100.0, 'Moderate'),
      (150.0, 'Unhealthy'),
    ];

    for (final item in thresholds) {
      final y = chartBottom - (item.$1 / 200.0) * chartHeight;

      _drawDashedLine(
        canvas,
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: item.$2,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF9CA3AF),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartRight + 8, y - 8));
    }

    final xLabels = [
      '00:00',
      '03:00',
      '06:00',
      '09:00',
      '12:00',
      '15:00',
      '18:00',
      '21:00',
      '23:00',
    ];

    for (int i = 0; i < xLabels.length; i++) {
      final x =
          chartLeft + (i / (xLabels.length - 1)) * (chartRight - chartLeft);

      textPainter.text = TextSpan(
        text: xLabels[i],
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

    final yMarks = ['0', '45', '90', '135', '180'];
    final yValues = [0.0, 45.0, 90.0, 135.0, 180.0];

    for (int i = 0; i < yMarks.length; i++) {
      final y = chartBottom - (yValues[i] / 200.0) * chartHeight;
      textPainter.text = TextSpan(
        text: yMarks[i],
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartLeft - 36, y - 8));
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
      chartLeft - 48,
      chartTop + chartHeight / 2 + textPainter.width / 2,
    );
    canvas.rotate(-1.5708);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 6.0;
    double x = start.dx;

    while (x < end.dx) {
      final x2 = (x + dashWidth).clamp(start.dx, end.dx);
      canvas.drawLine(Offset(x, start.dy), Offset(x2, start.dy), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LineSeriesPainter extends CustomPainter {
  final List<HourlyForecastPoint> points;
  final int? hoveredIndex;

  _LineSeriesPainter({
    required this.points,
    required this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const left = 80.0;
    const right = 100.0;
    const top = 30.0;
    const bottom = 50.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartTop = top;
    final chartBottom = size.height - bottom;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    final path = Path();
    final areaPath = Path();
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = chartLeft + (i / (points.length - 1)) * chartWidth;
      final y =
          chartBottom - (points[i].aqi.clamp(0, 200) / 200.0) * chartHeight;
      offsets.add(Offset(x, y));
    }

    if (offsets.isEmpty) return;

    path.moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 1; i < offsets.length; i++) {
      path.lineTo(offsets[i].dx, offsets[i].dy);
    }

    areaPath.moveTo(offsets.first.dx, chartBottom);
    for (final point in offsets) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath.lineTo(offsets.last.dx, chartBottom);
    areaPath.close();

    final areaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x554CA393),
          Color(0x114CA393),
        ],
      ).createShader(
        Rect.fromLTWH(chartLeft, chartTop, chartWidth, chartHeight),
      )
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pointFill = Paint()..color = AppColors.primary;
    final pointStroke = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < offsets.length; i++) {
      final radius = hoveredIndex == i ? 7.0 : 5.0;
      canvas.drawCircle(offsets[i], radius, pointFill);
      canvas.drawCircle(offsets[i], radius, pointStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _LineSeriesPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.hoveredIndex != hoveredIndex;
}

class _TooltipOverlayHourly extends StatelessWidget {
  final List<HourlyForecastPoint> points;
  final int hoveredIndex;
  final Size size;

  const _TooltipOverlayHourly({
    required this.points,
    required this.hoveredIndex,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    const left = 80.0;
    const right = 100.0;
    const top = 30.0;
    const bottom = 50.0;

    final chartLeft = left;
    final chartRight = size.width - right;
    final chartBottom = size.height - bottom;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - top;

    final point = points[hoveredIndex];
    final dx = chartLeft + (hoveredIndex / (points.length - 1)) * chartWidth;
    final dy = chartBottom - (point.aqi.clamp(0, 200) / 200.0) * chartHeight;

    final tooltipWidth = 150.0;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    point.hourLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AQI: ${point.aqi.round()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7EC4D5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _aqiCategory(point.aqi.round()),
                    style: const TextStyle(
                      fontSize: 18,
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

  static String _aqiCategory(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy SG';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }
}