import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrition_tracker/features/nutrition/providers/nutrition_provider.dart';
import 'package:nutrition_tracker/features/nutrition/widgets/heatmap_calendar.dart';
import 'package:nutrition_tracker/core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class ActivityHeatmapScreen extends StatefulWidget {
  const ActivityHeatmapScreen({super.key});

  @override
  State<ActivityHeatmapScreen> createState() => _ActivityHeatmapScreenState();
}

class _ActivityHeatmapScreenState extends State<ActivityHeatmapScreen> {
  int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final heatmapYear = nutritionProvider.heatmapYear;

    // Filter logs for selected month and year
    final monthLogs = nutritionProvider.yearlyLogs.where((entry) => 
      entry.timestamp.year == heatmapYear && entry.timestamp.month == _selectedMonth
    ).toList();
    
    // Sort by newest first
    monthLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Consistency Tracker',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildYearMonthPicker(context, nutritionProvider),
            const SizedBox(height: 24),
            HeatmapCalendar(
              datasets: nutritionProvider.yearlyProgress,
              year: heatmapYear,
              highlightMonth: _selectedMonth,
            ),
            const SizedBox(height: 32),
            const Text(
              'Monthly Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMonthStats(nutritionProvider),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meal History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${monthLogs.length} entries',
                    style: const TextStyle(color: AppColors.indigo, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (monthLogs.isEmpty)
              _buildEmptyLogs()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: monthLogs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _buildMealItem(monthLogs[index]),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLogs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Icon(Icons.restaurant_rounded, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No meals recorded for this month',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(dynamic entry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.calories.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood_rounded, color: AppColors.calories, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  DateFormat('MMM d, h:mm a').format(entry.timestamp),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.calories.toInt()} kcal',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.calories),
              ),
              Text(
                '${entry.protein.toInt()}g protein',
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearMonthPicker(BuildContext context, NutritionProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: provider.heatmapYear,
                items: [2024, 2025, 2026].map((y) => DropdownMenuItem(
                  value: y,
                  child: Text('Year $y', style: const TextStyle(fontWeight: FontWeight.bold)),
                )).toList(),
                onChanged: (y) => provider.setHeatmapYear(y!),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedMonth,
                items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(DateFormat('MMMM').format(DateTime(2024, m)), style: const TextStyle(fontWeight: FontWeight.bold)),
                )).toList(),
                onChanged: (m) => setState(() => _selectedMonth = m!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthStats(NutritionProvider provider) {
    final year = provider.heatmapYear;
    int completedDays = 0;
    double avgScore = 0;
    int dataPoints = 0;

    provider.yearlyProgress.forEach((date, score) {
      if (date.year == year && date.month == _selectedMonth) {
        if (score >= 70) completedDays++;
        avgScore += score;
        dataPoints++;
      }
    });

    if (dataPoints > 0) avgScore /= dataPoints;

    return Column(
      children: [
        _buildStatTile(
          'Average Goal Completion',
          '${avgScore.toInt()}%',
          Icons.analytics_rounded,
          AppColors.indigo,
        ),
        const SizedBox(height: 12),
        _buildStatTile(
          'Perfect Days (Score 70+)',
          '$completedDays Days',
          Icons.emoji_events_rounded,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }
}
