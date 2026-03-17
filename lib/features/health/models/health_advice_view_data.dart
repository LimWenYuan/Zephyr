import 'package:flutter/material.dart';

class HealthAdviceViewData {
  final String location;
  final int? aqi;
  final String categoryText;
  final String adviceTitle;
  final String description;
  final List<String> recommendations;
  final Color accentColor;
  final IconData statusIcon;

  const HealthAdviceViewData({
    required this.location,
    required this.aqi,
    required this.categoryText,
    required this.adviceTitle,
    required this.description,
    required this.recommendations,
    required this.accentColor,
    required this.statusIcon,
  });
}