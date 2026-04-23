import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrition_tracker/features/nutrition/providers/nutrition_provider.dart';
import 'package:nutrition_tracker/features/auth/providers/auth_provider.dart';
import 'package:nutrition_tracker/features/nutrition/widgets/health_score_gauge.dart';
import 'package:nutrition_tracker/features/nutrition/widgets/nutrient_progress_card.dart';
import 'package:nutrition_tracker/features/nutrition/screens/ai_scanner_screen.dart';
import 'package:nutrition_tracker/features/nutrition/screens/manual_entry_screen.dart';
import 'package:nutrition_tracker/core/theme/app_colors.dart';
import 'package:nutrition_tracker/features/nutrition/screens/activity_heatmap_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background, // Centralized background color
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header
              _buildHeader(context, user),
              const SizedBox(height: 24),

              // Goal Progress Section
              _buildGoalProgressCard(context, nutritionProvider.healthScore),
              const SizedBox(height: 16),

              // Activity Heatmap Button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActivityHeatmapScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.indigo,
                  ),
                  label: const Text(
                    'View Yearly Activity',
                    style: TextStyle(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Today's Progress Section
              _buildSectionHeader('Today\'s Progress', 'Edit Goals', () {}),
              const SizedBox(height: 16),
              NutrientProgressCard(
                title: 'Energy (Calories)',
                value:
                    '${nutritionProvider.totalCalories.toInt()} / ${nutritionProvider.calorieGoal.toInt()} kcal',
                progress:
                    nutritionProvider.totalCalories /
                    nutritionProvider.calorieGoal,
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.calories, // Sun-orange for energy
                backgroundColor: AppColors.calories.withValues(alpha: 0.1),
                statusText: 'Active',
                statusColor: AppColors.calories,
              ),
              NutrientProgressCard(
                title: 'Protein',
                value:
                    '${nutritionProvider.totalProtein.toInt()} / ${nutritionProvider.proteinGoal.toInt()} g',
                progress:
                    nutritionProvider.totalProtein /
                    nutritionProvider.proteinGoal,
                icon: Icons.fitness_center_rounded,
                iconColor: AppColors.protein, // Indigo for protein/muscle
                backgroundColor: AppColors.protein.withValues(alpha: 0.1),
                statusText: nutritionProvider.totalProtein < 20
                    ? 'Low'
                    : 'Good',
                statusColor: nutritionProvider.totalProtein < 20
                    ? Colors.red
                    : Colors.green,
              ),
              // Water card with quick-add button
              _buildWaterCard(context, nutritionProvider),

              const SizedBox(height: 24),

              // Add Your Meal Section
              const Text(
                'Add Your Meal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Add Meal',
                      'Take a photo of your food',
                      Icons.camera_alt_rounded,
                      Colors.green[50]!,
                      Colors.green[600]!,
                      () => _handleAiScan(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Quick Add',
                      'Search & add food manually',
                      Icons.add_circle_outline_rounded,
                      Colors.purple[50]!,
                      Colors.purple[600]!,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManualEntryScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  void _handleAiScan(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (source != null) {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AiScannerScreen(imagePath: image.path),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    NutritionProvider provider,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.indigo, // Premium Indigo
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
              secondary: AppColors.indigo,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: AppColors.indigo,
              headerForegroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              dayStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              todayBorder: const BorderSide(
                color: AppColors.indigo,
                width: 1.5,
              ),
              todayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                return AppColors.indigo;
              }),
              dayShape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected))
                  return AppColors.indigo;
                return null;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                if (states.contains(WidgetState.disabled))
                  return Colors.grey[300];
                return Colors.black87;
              }),
              dayOverlayColor: WidgetStateProperty.all(
                AppColors.indigo.withValues(alpha: 0.1),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.indigo,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != provider.selectedDate) {
      provider.setSelectedDate(picked);
    }
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
    final nutritionProvider = Provider.of<NutritionProvider>(context);
    final userProfile = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).userProfile;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final selected = DateTime(
      nutritionProvider.selectedDate.year,
      nutritionProvider.selectedDate.month,
      nutritionProvider.selectedDate.day,
    );

    String dateText;
    if (selected == today) {
      dateText = 'Today, ${DateFormat('d MMM').format(selected)}';
    } else if (selected == yesterday) {
      dateText = 'Yesterday, ${DateFormat('d MMM').format(selected)}';
    } else {
      dateText = DateFormat('EEE, d MMM yyyy').format(selected);
    }

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context, nutritionProvider),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        dateText,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey[700],
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey[200],
          child: Text(
            (userProfile?.name ?? user?.displayName ?? user?.email ?? 'U')[0]
                .toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalProgressCard(BuildContext context, int score) {
    final accentColor = score >= 70
        ? const Color(0xFF4CAF50)
        : score >= 40
        ? const Color(0xFFFF9800)
        : const Color(0xFFF44336);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Goal Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        score >= 70
                            ? 'Excellent'
                            : score >= 40
                            ? 'On Track'
                            : 'Starting Out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.stars_rounded, size: 20, color: accentColor),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text(
                        'Goal Progress',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Goal Progress is calculated based on your daily achievement across key targets:',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 16),
                          _GoalProgressFactorRow(
                            label: 'Calories (40%)',
                            description: 'Staying within your daily energy gap.',
                            color: Colors.orange,
                          ),
                          SizedBox(height: 12),
                          _GoalProgressFactorRow(
                            label: 'Protein (40%)',
                            description: 'Meeting your muscle maintenance needs.',
                            color: Colors.indigo,
                          ),
                          SizedBox(height: 12),
                          _GoalProgressFactorRow(
                            label: 'Water (20%)',
                            description: 'Maintaining optimal hydration levels.',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                        ),
                        children: [
                          TextSpan(
                            text: '$score',
                            style: TextStyle(color: accentColor),
                          ),
                          const TextSpan(
                            text: ' /100',
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 18,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      score >= 70
                          ? 'Amazing work today! 🎉'
                          : score >= 40
                          ? 'You\'re doing great! 🚀'
                          : 'Start your journey 🍽️',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 3, child: HealthScoreGauge(score: score)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCard(BuildContext context, NutritionProvider provider) {
    final progress = (provider.totalWater / provider.waterGoal).clamp(0.0, 1.0);
    final isGoalReached = provider.totalWater >= provider.waterGoal;
    final percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Intake',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${provider.waterGlasses} / ${provider.waterGlassGoal} glasses • ${provider.totalWater.toStringAsFixed(1)}L',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: provider.waterStatusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.waterStatusText,
                  style: TextStyle(
                    color: provider.waterStatusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                progress >= 1.0 ? 'Hydrated!' : 'Goal: ${provider.waterGoal}L',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Quick-add button with selection popup
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isGoalReached
                  ? null
                  : () => _showWaterSelectionDialog(context, provider),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'Add Water',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                disabledBackgroundColor: Colors.grey[100],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWaterSelectionDialog(
    BuildContext context,
    NutritionProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Add Water Intake',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select the amount you consumed',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildPopupAmountOption(
                  context,
                  provider,
                  '250 ml',
                  0.25,
                  Icons.local_drink_rounded,
                ),
                const SizedBox(width: 12),
                _buildPopupAmountOption(
                  context,
                  provider,
                  '500 ml',
                  0.5,
                  Icons.water_drop_rounded,
                ),
                const SizedBox(width: 12),
                _buildPopupAmountOption(
                  context,
                  provider,
                  '1 Liter',
                  1.0,
                  Icons.opacity_rounded,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupAmountOption(
    BuildContext context,
    NutritionProvider provider,
    String label,
    double amount,
    IconData icon,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          provider.addWater(amount);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue[100]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.blue[700], size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalProgressFactorRow extends StatelessWidget {
  final String label;
  final String description;
  final Color color;

  const _GoalProgressFactorRow({
    required this.label,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
