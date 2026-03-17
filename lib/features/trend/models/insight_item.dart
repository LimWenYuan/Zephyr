import 'package:flutter/material.dart';

class InsightItem {
  final String title;
  final String body;
  final Color borderColor;
  final Color backgroundColor;
  final Color titleColor;
  final Color bodyColor;

  const InsightItem({
    required this.title,
    required this.body,
    required this.borderColor,
    required this.backgroundColor,
    required this.titleColor,
    required this.bodyColor,
  });
}