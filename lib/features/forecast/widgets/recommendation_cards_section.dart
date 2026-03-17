import 'package:flutter/material.dart';

class RecommendationCardsSection extends StatelessWidget {
  final String? bestTimeRange;
  final String? bestTimeDescription;
  final String? bestTimeMeta;

  final String? stayIndoorsRange;
  final String? stayIndoorsDescription;
  final String? stayIndoorsMeta;

  final String? exerciseRange;
  final String? exerciseDescription;
  final String? exerciseMeta;

  const RecommendationCardsSection({
    super.key,
    this.bestTimeRange,
    this.bestTimeDescription,
    this.bestTimeMeta,
    this.stayIndoorsRange,
    this.stayIndoorsDescription,
    this.stayIndoorsMeta,
    this.exerciseRange,
    this.exerciseDescription,
    this.exerciseMeta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: [
          Expanded(
            child: _RecommendationCard(
              icon: Icons.wb_sunny_outlined,
              title: 'Best Time to Go Out',
              range: bestTimeRange ?? '--:-- - --:--',
              description: bestTimeDescription ??
                  'Recommendation will appear when forecast data is available.',
              meta: bestTimeMeta ?? 'Avg AQI: --',
              startColor: const Color(0xFFF0FDF4),
              endColor: const Color(0xFFDCFCE7),
              borderColor: const Color(0xFF86EFAC),
              iconBg: const Color(0xFF22C55E),
              titleColor: const Color(0xFF166534),
              bodyColor: const Color(0xFF15803D),
              smallColor: const Color(0xFF16A34A),
              dividerColor: const Color(0xFF86EFAC),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _RecommendationCard(
              icon: Icons.home_outlined,
              title: 'Stay Indoors',
              range: stayIndoorsRange ?? '--:-- - --:--',
              description: stayIndoorsDescription ??
                  'Recommendation will appear when forecast data is available.',
              meta: stayIndoorsMeta ?? 'Avg AQI: --',
              startColor: const Color(0xFFFFF7ED),
              endColor: const Color(0xFFFFEDD5),
              borderColor: const Color(0xFFFDBA74),
              iconBg: const Color(0xFFF97316),
              titleColor: const Color(0xFF9A3412),
              bodyColor: const Color(0xFFC2410C),
              smallColor: const Color(0xFFEA580C),
              dividerColor: const Color(0xFFFDBA74),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _RecommendationCard(
              icon: Icons.directions_bike_outlined,
              title: 'Light Exercise',
              range: exerciseRange ?? '--:-- - --:--',
              description: exerciseDescription ??
                  'Recommendation will appear when forecast data is available.',
              meta: exerciseMeta ?? 'Activity status: --',
              startColor: const Color(0xFFEFF6FF),
              endColor: const Color(0xFFDBEAFE),
              borderColor: const Color(0xFF93C5FD),
              iconBg: const Color(0xFF3B82F6),
              titleColor: const Color(0xFF1E40AF),
              bodyColor: const Color(0xFF1D4ED8),
              smallColor: const Color(0xFF2563EB),
              dividerColor: const Color(0xFF93C5FD),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String range;
  final String description;
  final String meta;

  final Color startColor;
  final Color endColor;
  final Color borderColor;
  final Color iconBg;
  final Color titleColor;
  final Color bodyColor;
  final Color smallColor;
  final Color dividerColor;

  const _RecommendationCard({
    required this.icon,
    required this.title,
    required this.range,
    required this.description,
    required this.meta,
    required this.startColor,
    required this.endColor,
    required this.borderColor,
    required this.iconBg,
    required this.titleColor,
    required this.bodyColor,
    required this.smallColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        gradient: LinearGradient(
          colors: [startColor, endColor],
        ),
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            range,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: bodyColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: bodyColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: dividerColor),
          const SizedBox(height: 8),
          Text(
            meta,
            style: TextStyle(
              fontSize: 14,
              color: smallColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}