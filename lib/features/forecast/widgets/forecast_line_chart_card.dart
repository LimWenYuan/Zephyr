import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/hourly_forecast_point.dart';

class ForecastLineChartCard extends StatelessWidget {
  final List<HourlyForecastPoint> points;

  const ForecastLineChartCard({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = points.isNotEmpty;

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
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(chartWidth, 450),
                      painter: _LineChartFramePainter(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: hasData
                          ? CustomPaint(
                              painter: _LineSeriesPainter(points: points),
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
      final x = chartLeft + (i / (xLabels.length - 1)) * (chartRight - chartLeft);

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
    canvas.translate(chartLeft - 48, chartTop + chartHeight / 2 + textPainter.width / 2);
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

  _LineSeriesPainter({required this.points});

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

    final path = Path();

    for (int i = 0; i < points.length; i++) {
      final x = chartLeft + (i / (points.length - 1)) * chartWidth;
      final y = chartBottom - (points[i].aqi.clamp(0, 200) / 200.0) * chartHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < points.length; i++) {
      final x = chartLeft + (i / (points.length - 1)) * chartWidth;
      final y = chartBottom - (points[i].aqi.clamp(0, 200) / 200.0) * chartHeight;

      canvas.drawCircle(Offset(x, y), 5, pointFill);
      canvas.drawCircle(Offset(x, y), 5, pointStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _LineSeriesPainter oldDelegate) =>
      oldDelegate.points != points;
}