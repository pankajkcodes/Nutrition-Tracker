import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrition_tracker/features/nutrition/providers/nutrition_provider.dart';
import 'package:nutrition_tracker/features/nutrition/models/food_library_item.dart';
import 'package:nutrition_tracker/features/nutrition/data/food_seed_data.dart';
import 'package:nutrition_tracker/core/theme/app_colors.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  void initState() {
    super.initState();
    // Seed the library with initial data if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NutritionProvider>().seedFoodLibrary(initialFoodSeedData);
    });
  }

  final Set<int> _selectedIndices = {};
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final calorieProgress = (nutritionProvider.totalCalories / nutritionProvider.calorieGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: 6,
        child: Column(
          children: [
            // Header with Glassmorphism-style overlay
            _buildPremiumHeader(nutritionProvider, calorieProgress),
            
            // Premium Pill Tabs
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                tabAlignment: TabAlignment.start,
                indicator: BoxDecoration(
                  color: AppColors.indigo,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.indigo.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                tabs: const [
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Fruit'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Vegetables'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Recipe'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Dry fruits'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Seeds'))),
                  Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Others'))),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                children: [
                  _buildFoodList(nutritionProvider, 'fruit'),
                  _buildFoodList(nutritionProvider, 'vegetables'),
                  _buildFoodList(nutritionProvider, 'recipe'),
                  _buildFoodList(nutritionProvider, 'dry fruits'),
                  _buildFoodList(nutritionProvider, 'seeds'),
                  _buildFoodList(nutritionProvider, 'others'),
                ],
              ),
            ),

            // Save Button with premium styling
            _buildPremiumSaveButton(nutritionProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(NutritionProvider provider, double progress) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1543339308-43e59d6b73a6?w=800&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Fuel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Nutrition Guide',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      '${provider.calorieGoal.toInt()} cal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.totalCalories.toInt()} consumed',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVegBadge(bool isVeg) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: isVeg ? Colors.green : Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: isVeg ? Colors.green : Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildFoodList(NutritionProvider provider, String category) {
    final filteredItems = provider.foodLibrary.where((item) => item.category == category).toList();

    if (filteredItems.isEmpty && provider.foodLibrary.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu_rounded, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No items in $category',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = _selectedIndices.contains(index);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.indigo : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedIndices.remove(index);
                  } else {
                    _selectedIndices.add(index);
                  }
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: _buildVegBadge(item.isVeg),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              Text(
                                item.dailyUse,
                                style: TextStyle(
                                  color: AppColors.indigo,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.calories.toInt()} kcal',
                                  style: const TextStyle(
                                    color: Colors.orange, 
                                    fontSize: 11, 
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.protein}g protein',
                                  style: const TextStyle(
                                    color: Colors.blue, 
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.benefits,
                            style: TextStyle(
                              fontSize: 11, 
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.indigo : Colors.grey[50],
                        border: Border.all(
                          color: isSelected ? AppColors.indigo : Colors.grey[300]!,
                          width: 1.5,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppColors.indigo.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ] : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumSaveButton(NutritionProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      color: AppColors.background,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedIndices.isEmpty || _isSaving
              ? null
              : () async {
                  setState(() => _isSaving = true);
                  try {
                    for (final index in _selectedIndices) {
                      final item = provider.foodLibrary[index];
                      await provider.addManualEntry(item.name, item.calories, item.protein);
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Text('${_selectedIndices.length} items logged successfully!'),
                            ],
                          ),
                          backgroundColor: AppColors.indigo,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(20),
                        ),
                      );
                      setState(() => _selectedIndices.clear());
                    }
                  } finally {
                    if (mounted) setState(() => _isSaving = false);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.indigo,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: AppColors.indigo.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _isSaving
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  'LOG ${_selectedIndices.length} ITEMS',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
        ),
      ),
    );
  }
}
