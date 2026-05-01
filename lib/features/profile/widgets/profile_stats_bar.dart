import 'package:flutter/material.dart';

class ProfileStatsBar extends StatelessWidget {
  final int mealsCount;
  final int streakCount;
  final int healthScore;

  const ProfileStatsBar({
    super.key,
    required this.mealsCount,
    required this.streakCount,
    required this.healthScore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatItem('Meals', '$mealsCount', Icons.restaurant_rounded),
          _buildStatDivider(),
          _buildStatItem('Streak', '$streakCount', Icons.local_fire_department_rounded),
          _buildStatDivider(),
          _buildStatItem('Score', '$healthScore%', Icons.insights_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6366F1)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[200],
    );
  }
}
