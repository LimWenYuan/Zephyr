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
      description: 'Fine particles that can penetrate deep into lungs',
      icon: Icons.water_drop_outlined,
    ),
    PollutantItem(
      name: 'PM10',
      unit: 'µg/m³',
      description: 'Inhalable particles from dust and smoke',
      icon: Icons.air,
    ),
    PollutantItem(
      name: 'O₃',
      unit: 'ppb',
      description: 'Ground-level ozone, harmful to respiratory system',
      icon: Icons.show_chart,
    ),
    PollutantItem(
      name: 'NO₂',
      unit: 'ppb',
      description: 'Nitrogen dioxide from vehicle emissions',
      icon: Icons.warning_amber_outlined,
    ),
    PollutantItem(
      name: 'SO₂',
      unit: 'ppb',
      description: 'Sulfur dioxide from industrial sources',
      icon: Icons.speed,
    ),
    PollutantItem(
      name: 'CO',
      unit: 'ppm',
      description: 'Carbon monoxide, can reduce oxygen delivery',
      icon: Icons.error_outline,
    ),
  ];
}