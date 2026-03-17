import 'package:flutter/material.dart';

class PollutantItem {
  final String name;
  final String unit;
  final String description;
  final String? valueText;
  final bool? isSafe;
  final IconData icon;

  const PollutantItem({
    required this.name,
    required this.unit,
    required this.description,
    required this.icon,
    this.valueText,
    this.isSafe,
  });
}