import 'package:flutter/material.dart';
import '../models/pollutant_item.dart';
import 'pollutant_card.dart';

class PollutantGrid extends StatelessWidget {
  final List<PollutantItem> items;

  const PollutantGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = items.isNotEmpty ? items : _defaultItems;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 280,
      ),
      itemBuilder: (context, index) {
        return PollutantCard(item: displayItems[index]);
      },
    );
  }

  static const _defaultItems = [
    PollutantItem(
      name: 'PM2.5',
      unit: 'µg/m³',
      description:
          'Very fine dust that can go deep into the lungs. Lower is better.',
      icon: Icons.water_drop_outlined,
    ),
    PollutantItem(
      name: 'PM10',
      unit: 'µg/m³',
      description:
          'Larger dust and smoke particles that may irritate airways. Lower is better.',
      icon: Icons.air,
    ),
    PollutantItem(
      name: 'O₃',
      unit: 'ppb',
      description:
          'Ground-level ozone may irritate breathing, especially outdoors. Lower is better.',
      icon: Icons.show_chart,
    ),
    PollutantItem(
      name: 'NO₂',
      unit: 'ppb',
      description:
          'Traffic-related gas that may irritate the lungs. Lower is better.',
      icon: Icons.warning_amber_outlined,
    ),
    PollutantItem(
      name: 'SO₂',
      unit: 'ppb',
      description:
          'Industrial gas that may trigger breathing discomfort. Lower is better.',
      icon: Icons.speed,
    ),
    PollutantItem(
      name: 'CO',
      unit: 'ppm',
      description:
          'Gas that can reduce oxygen carried in the body. Lower is better.',
      icon: Icons.error_outline,
    ),
  ];
}