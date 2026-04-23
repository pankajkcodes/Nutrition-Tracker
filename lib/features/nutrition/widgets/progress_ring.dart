import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double value;
  final double goal;
  final String label;
  final String unit;
  final Color color;

  const ProgressRing({
    super.key,
    required this.value,
    required this.goal,
    required this.label,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 10,
                color: color.withAlpha(25),
              ),
            ),
            SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                color: color,
              ),
            ),
            Column(
              children: [
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${value.toInt()} / ${goal.toInt()} $unit',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
