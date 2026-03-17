import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AqiScaleCard extends StatelessWidget {
  final int? aqi;
  final VoidCallback? onHealthPressed;

  const AqiScaleCard({
    super.key,
    this.aqi,
    this.onHealthPressed,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = aqi?.toString() ?? '--';
    final leftFraction = aqi == null ? 0.0 : (aqi!.clamp(0, 200) / 200);

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'AQI Scale & Your Reading',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final indicatorLeft = constraints.maxWidth * leftFraction;

              return Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF22C55E),
                              Color(0xFF84CC16),
                              Color(0xFFEAB308),
                              Color(0xFFFACC15),
                              Color(0xFFF59E0B),
                              Color(0xFFFB923C),
                              Color(0xFFF97316),
                              Color(0xFFEF4444),
                              Color(0xFFDC2626),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _ScaleLabel(text: 'Good', size: 20),
                              _ScaleLabel(text: 'Moderate', size: 20),
                              _ScaleLabel(text: 'Sensitive', size: 18),
                              _ScaleLabel(text: 'Unhealthy', size: 20),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: indicatorLeft.clamp(0.0, constraints.maxWidth - 1),
                        top: 72,
                        child: Transform.translate(
                          offset: const Offset(-24, 0),
                          child: Column(
                            children: [
                              CustomPaint(
                                size: const Size(40, 24),
                                painter: _TrianglePainter(),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFD97706),
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x1A000000),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  displayValue,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BottomScaleText('0'),
                      _BottomScaleText('50'),
                      _BottomScaleText('100'),
                      _BottomScaleText('150'),
                      _BottomScaleText('200'),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          _HealthButton(onPressed: onHealthPressed),
        ],
      ),
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  final String text;
  final double size;

  const _ScaleLabel({
    required this.text,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        shadows: const [
          Shadow(
            color: Color(0x55000000),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _BottomScaleText extends StatelessWidget {
  final String text;

  const _BottomScaleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedForeground,
      ),
    );
  }
}

class _HealthButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _HealthButton({this.onPressed});

  @override
  State<_HealthButton> createState() => _HealthButtonState();
}

class _HealthButtonState extends State<_HealthButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: hovering ? 1.05 : 1.0,
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: const Icon(Icons.favorite_border, size: 28),
          label: const Text(
            'Learn more about Health Recommendation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: hovering
                ? AppColors.primary.withValues(alpha: 0.9)
                : AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: hovering ? 10 : 6,
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.foreground;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}