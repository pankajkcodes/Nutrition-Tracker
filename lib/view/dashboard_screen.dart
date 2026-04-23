import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../providers/auth_provider.dart';
import 'widgets/health_score_gauge.dart';
import 'widgets/nutrient_progress_card.dart';
import 'ai_scanner_screen.dart';
import 'manual_entry_screen.dart';
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
      backgroundColor: Colors.grey[50], // Very light background
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

              // Health Score Section
              _buildHealthScoreCard(context, nutritionProvider.healthScore),
              const SizedBox(height: 32),

              // Today's Progress Section
              _buildSectionHeader('Today\'s Progress', 'Edit Goals', () {}),
              const SizedBox(height: 16),
              NutrientProgressCard(
                title: 'Energy (Calories)',
                value: '${nutritionProvider.totalCalories.toInt()} / ${nutritionProvider.calorieGoal.toInt()} kcal',
                progress: nutritionProvider.totalCalories / nutritionProvider.calorieGoal,
                icon: Icons.local_fire_department_rounded,
                iconColor: Colors.orange,
                backgroundColor: Colors.orange[50]!,
                statusText: 'On Track',
                statusColor: Colors.green,
              ),
              NutrientProgressCard(
                title: 'Protein',
                value: '${nutritionProvider.totalProtein.toInt()} / ${nutritionProvider.proteinGoal.toInt()} g',
                progress: nutritionProvider.totalProtein / nutritionProvider.proteinGoal,
                icon: Icons.fitness_center_rounded,
                iconColor: Colors.green[600]!,
                backgroundColor: Colors.green[50]!,
                statusText: nutritionProvider.totalProtein < 20 ? 'Low' : 'Good',
                statusColor: nutritionProvider.totalProtein < 20 ? Colors.red : Colors.green,
              ),
              NutrientProgressCard(
                title: 'Water',
                value: '${nutritionProvider.totalWater.toStringAsFixed(1)} / ${nutritionProvider.waterGoal.toInt()} L',
                progress: nutritionProvider.totalWater / nutritionProvider.waterGoal,
                icon: Icons.water_drop_rounded,
                iconColor: Colors.blue,
                backgroundColor: Colors.blue[50]!,
                statusText: 'Almost Done',
                statusColor: Colors.orange,
              ),

              const SizedBox(height: 24),

              // Essential Nutrients Section
              _buildSectionHeader('Essential Nutrients', 'View All', () {}),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: nutritionProvider.nutrientStatuses.map((nutrient) {
                    return _buildNutrientCard(
                      nutrient.name,
                      nutrient.status,
                      nutrient.suggestion,
                      nutrient.color,
                      nutrient.icon,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),

              // Smart Suggestions Section
              const Text(
                'Smart Suggestions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (nutritionProvider.smartSuggestions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'All caught up! 🎉',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: nutritionProvider.smartSuggestions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final suggestion = nutritionProvider.smartSuggestions[index];
                    return _buildSuggestionCard(
                      suggestion.title,
                      suggestion.subtitle,
                      suggestion.tag,
                      suggestion.icon,
                      suggestion.bgColor,
                      suggestion.iconColor,
                      isButton: suggestion.isButton,
                      onTap: suggestion.onTap,
                    );
                  },
                ),

              const SizedBox(height: 32),

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
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualEntryScreen())),
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

  Widget _buildHeader(BuildContext context, dynamic user) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, size: 28),
        ),
        Expanded(
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
                    'Today, ${DateFormat('d MMM').format(DateTime.now())}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 18),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none_rounded, size: 28),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey[200],
          child: Text(
            (user?.displayName ?? 'E')[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthScoreCard(BuildContext context, int score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Your Health Score',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 64, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: '$score', style: const TextStyle(color: Color(0xFF4CAF50))),
                          const TextSpan(text: ' /100', style: TextStyle(color: Colors.grey, fontSize: 24)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Good Job! Keep it up 💪',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: HealthScoreGauge(score: score),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onTap) {
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
            style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientCard(String name, String status, String suggestion, Color color, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: status == 'Good' ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Good' ? Colors.green : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            suggestion,
            style: TextStyle(color: Colors.grey[600], fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
    String title,
    String subtitle,
    String tag,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    bool isButton = false,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          if (isButton)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E7FF),
                foregroundColor: const Color(0xFF6366F1),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(tag, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
}
