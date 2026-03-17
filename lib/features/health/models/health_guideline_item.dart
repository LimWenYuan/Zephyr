import 'package:flutter/material.dart';

class HealthGuidelineItem {
  final IconData icon;
  final String title;
  final List<String> bullets;

  const HealthGuidelineItem({
    required this.icon,
    required this.title,
    required this.bullets,
  });
}