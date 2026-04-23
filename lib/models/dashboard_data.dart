import 'package:flutter/material.dart';

class NutrientStatus {
  final String name;
  final String status;
  final String suggestion;
  final IconData icon;
  final Color color;

  NutrientStatus({
    required this.name,
    required this.status,
    required this.suggestion,
    required this.icon,
    required this.color,
  });
}

class SmartSuggestion {
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final bool isButton;
  final VoidCallback? onTap;

  SmartSuggestion({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.isButton = false,
    this.onTap,
  });
}
