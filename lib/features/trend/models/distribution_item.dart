import 'package:flutter/material.dart';

class DistributionItem {
  final String label;
  final int count;
  final int percentage;
  final Color color;

  const DistributionItem({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });
}