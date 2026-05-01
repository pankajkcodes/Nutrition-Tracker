import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_tracker/features/auth/providers/auth_provider.dart';
import 'package:nutrition_tracker/features/nutrition/providers/nutrition_provider.dart';
import 'package:nutrition_tracker/core/common/widgets/option_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final nutritionProvider = context.watch<NutritionProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Account Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
            ),
            title: const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(user?.email ?? 'No email provided', style: const TextStyle(color: Colors.black54)),
          ),
          const Divider(height: 32),
          _buildDangerZone(context, nutritionProvider),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _buildDangerZone(BuildContext context, NutritionProvider provider) {
    final theme = Theme.of(context);
    final selectedDateStr = DateFormat('MMM dd, yyyy').format(provider.selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            'DANGER ZONE',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.red[700],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              OptionTile(
                icon: Icons.history_rounded,
                color: Colors.red[400]!,
                title: 'Reset Selected Date ($selectedDateStr)',
                onTap: () => _selectAndResetDate(context, provider),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectAndResetDate(BuildContext context, NutritionProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && context.mounted) {
      final pickedStr = DateFormat('MMM dd, yyyy').format(picked);
      _showResetConfirmationDialog(context, provider, picked, pickedStr);
    }
  }

  void _showResetConfirmationDialog(
    BuildContext context, 
    NutritionProvider provider, 
    DateTime date,
    String dateStr,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Daily Data?'),
        content: Text(
          'This will permanently delete all food logs and water intake for $dateStr. This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Close confirmation dialog
              
              // Show loading indicator using the original screen context
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingContext) => const Center(child: CircularProgressIndicator()),
              );

              try {
                await provider.resetDataForDate(date);
                
                if (context.mounted) {
                  Navigator.pop(context); // Close loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data reset for $dateStr'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Close loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error resetting data: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              }
            },
            child: const Text('Reset Data', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
