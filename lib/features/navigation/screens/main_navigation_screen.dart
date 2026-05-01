import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_tracker/features/nutrition/screens/dashboard_screen.dart';
import 'package:nutrition_tracker/features/profile/screens/profile_screen.dart';
import 'package:nutrition_tracker/features/nutrition/widgets/add_food_dialog.dart';
import 'package:nutrition_tracker/features/nutrition/screens/meals_screen.dart';
import 'package:nutrition_tracker/features/nutrition/screens/insights_screen.dart';
import 'package:nutrition_tracker/core/theme/app_colors.dart';
import 'package:nutrition_tracker/core/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MealsScreen(),
    const InsightsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop ?? false) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: navProvider.currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.symmetric(vertical: 4),
          height: 60,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home_rounded, 'Home', 0),
              _buildNavItem(context, Icons.restaurant_menu_rounded, 'Meals', 1),
              const SizedBox(width: 32),
              _buildNavItem(context, Icons.insights_rounded, 'Insights', 2),
              _buildNavItem(context, Icons.person_rounded, 'Profile', 3),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: 48,
          height: 48,
          child: FloatingActionButton(
            onPressed: () => _showAddOptions(context),
            backgroundColor: AppColors.indigo,
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the Nutrition Tracker?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final navProvider = context.read<NavigationProvider>();
    final isSelected = navProvider.currentIndex == index;
    return GestureDetector(
      onTap: () => navProvider.setIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.indigo : Colors.grey,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.indigo : Colors.grey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFoodDialog(),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title Coming Soon',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
