import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrition_tracker/features/nutrition/providers/nutrition_provider.dart';
import 'package:nutrition_tracker/features/nutrition/models/food_entry.dart';
import 'package:nutrition_tracker/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_tracker/features/nutrition/screens/activity_heatmap_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeeklyPerformance(nutritionProvider),
                  const SizedBox(height: 16),
                  _buildMacronutrientMix(nutritionProvider),
                  const SizedBox(height: 16),
                  _buildTopFoods(nutritionProvider),
                  const SizedBox(height: 16),
                  _buildConsistencyStreak(nutritionProvider, context),
                  const SizedBox(height: 16),
                  _buildAiInsightsCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        centerTitle: false,
        title: const Text(
          'Insights',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyPerformance(NutritionProvider provider) {
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
    
    // Map logs to daily sums
    Map<String, double> dailyCals = {};
    for (var log in provider.yearlyLogs) {
      final key = DateFormat('yyyy-MM-dd').format(log.timestamp);
      dailyCals[key] = (dailyCals[key] ?? 0) + log.calories;
    }

    final dataPoints = last7Days.map((date) {
      final key = DateFormat('yyyy-MM-dd').format(date);
      return dailyCals[key] ?? 0.0;
    }).toList();

    double maxVal = dataPoints.fold(0, (max, v) => v > max ? v : max);
    if (maxVal < provider.calorieGoal) maxVal = provider.calorieGoal;
    if (maxVal == 0) maxVal = 2000;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Performance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Goal: ${provider.calorieGoal.toInt()} cal',
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final val = dataPoints[index];
                final heightFactor = (val / maxVal).clamp(0.05, 1.0);
                final isToday = index == 6;
                final isAboveGoal = val >= provider.calorieGoal;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 60 * heightFactor,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isAboveGoal
                                ? [AppColors.indigo, AppColors.indigo.withValues(alpha: 0.7)]
                                : [Colors.grey[200]!, Colors.grey[100]!],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('E').format(last7Days[index]).substring(0, 1),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday ? AppColors.indigo : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacronutrientMix(NutritionProvider provider) {
    // Calculate weekly average protein vs calories
    final now = DateTime.now();
    double weekTotalCals = 0;
    double weekTotalPro = 0;
    int activeDays = 0;

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(date);
      final dailyLogs = provider.yearlyLogs.where((l) => DateFormat('yyyy-MM-dd').format(l.timestamp) == key);
      
      if (dailyLogs.isNotEmpty) {
        weekTotalCals += dailyLogs.fold(0.0, (sum, l) => sum + l.calories);
        weekTotalPro += dailyLogs.fold(0.0, (sum, l) => sum + l.protein);
        activeDays++;
      }
    }

    final avgCals = activeDays > 0 ? weekTotalCals / activeDays : 0.0;
    final avgPro = activeDays > 0 ? weekTotalPro / activeDays : 0.0;
    
    final calProgress = (avgCals / provider.calorieGoal).clamp(0.0, 1.0);
    final proProgress = (avgPro / provider.proteinGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrient Balance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildNutrientBar('Calories', '${avgCals.toInt()} cal', calProgress, AppColors.calories),
          const SizedBox(height: 12),
          _buildNutrientBar('Protein', '${avgPro.toInt()}g', proProgress, AppColors.protein),
          const SizedBox(height: 8),
          Text(
            'Based on $activeDays active days.',
            style: TextStyle(color: Colors.grey[400], fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopFoods(NutritionProvider provider) {
    // Count food frequency for the last 7 days
    Map<String, int> counts = {};
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    for (var log in provider.yearlyLogs) {
      if (log.timestamp.isAfter(sevenDaysAgo)) {
        counts[log.name] = (counts[log.name] ?? 0) + 1;
      }
    }

    var sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topItems = sortedEntries.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Logged (Week)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (topItems.isEmpty)
            Text('Log some meals to see insights!', style: TextStyle(color: Colors.grey[400]))
          else
            ...topItems.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.indigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.star_rounded, color: AppColors.indigo, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Text(
                    '${entry.value} times',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildConsistencyStreak(NutritionProvider provider, BuildContext context) {
    int streak = 0;
    final now = DateTime.now();
    
    // Simple streak calculation from progress map
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final score = provider.yearlyProgress[DateTime(date.year, date.month, date.day)] ?? 0;
      if (score >= 50) {
        streak++;
      } else if (i > 0) {
        break; // Break only if it's not today (allow today to be 0 and keep streak from yesterday)
      }
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivityHeatmapScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.indigo.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$streak Day Streak!',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Keep logging to maintain your habit.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAiInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.indigo.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.purple, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'AI Personal Insight',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'You tend to reach your protein goal 40% more often on days you log eggs or salmon. Keep it up!',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
