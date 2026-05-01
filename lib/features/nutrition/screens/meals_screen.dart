import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrition_tracker/features/nutrition/providers/nutrition_provider.dart';
import 'package:nutrition_tracker/features/nutrition/models/food_library_item.dart';
import 'package:nutrition_tracker/core/theme/app_colors.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final Set<String> _selectedItemIds = {};
  bool _isSaving = false;

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedItemIds.contains(id)) {
        _selectedItemIds.remove(id);
      } else {
        _selectedItemIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nutritionProvider = context.watch<NutritionProvider>();
    final calorieProgress = (nutritionProvider.totalCalories / nutritionProvider.calorieGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: 7,
        child: Column(
          children: [
            _buildPremiumHeader(nutritionProvider, calorieProgress),
            
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12), // Space BETWEEN tabs
                indicatorPadding: EdgeInsets.zero,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  color: AppColors.indigo,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.indigo.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFCA28)),
                          SizedBox(width: 8),
                          Text('Starred'),
                        ],
                      ),
                    ),
                  ),
                  _buildTab('Fruit'),
                  _buildTab('Vegetables'),
                  _buildTab('Recipe'),
                  _buildTab('Dry fruits'),
                  _buildTab('Seeds'),
                  _buildTab('Others'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  FoodListTab(category: 'starred', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                  FoodListTab(category: 'fruit', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                  FoodListTab(category: 'vegetables', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                  FoodListTab(category: 'recipe', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                  FoodListTab(category: 'dry fruits', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                  FoodListTab(category: 'seeds', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                  FoodListTab(category: 'others', selectedItemIds: _selectedItemIds, onToggle: _toggleSelection),
                ],
              ),
            ),

            _buildPremiumSaveButton(nutritionProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(text),
      ),
    );
  }

  Widget _buildPremiumHeader(NutritionProvider provider, double progress) {
    return Container(
      height: 140,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Nutrition Guide',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ],
                    ),
                    Text(
                      '${provider.calorieGoal.toInt()} cal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.totalCalories.toInt()} consumed',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
                          ),
                          borderRadius: BorderRadius.circular(2),
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

  Widget _buildPremiumSaveButton(NutritionProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      color: AppColors.background,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _selectedItemIds.isEmpty || _isSaving
              ? null
              : () async {
                  setState(() => _isSaving = true);
                  try {
                    final selectedItems = provider.foodLibrary.where((item) => _selectedItemIds.contains(item.id)).toList();
                    for (final item in selectedItems) {
                      await provider.addManualEntry(item.name, item.calories, item.protein);
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Text('${_selectedItemIds.length} items logged successfully!'),
                            ],
                          ),
                          backgroundColor: AppColors.indigo,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(20),
                        ),
                      );
                      setState(() => _selectedItemIds.clear());
                    }
                  } finally {
                    if (mounted) setState(() => _isSaving = false);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.indigo,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: AppColors.indigo.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isSaving
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  'LOG ${_selectedItemIds.length} ITEMS',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
        ),
      ),
    );
  }
}

class FoodListTab extends StatefulWidget {
  final String category;
  final Set<String> selectedItemIds;
  final Function(String) onToggle;

  const FoodListTab({
    super.key, 
    required this.category, 
    required this.selectedItemIds, 
    required this.onToggle
  });

  @override
  State<FoodListTab> createState() => _FoodListTabState();
}

class _FoodListTabState extends State<FoodListTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<NutritionProvider>();
    
    List<FoodLibraryItem> filteredItems;
    if (widget.category == 'starred') {
      filteredItems = List<FoodLibraryItem>.from(provider.starredMeals);
      filteredItems.sort((a, b) => a.name.compareTo(b.name));
    } else {
      filteredItems = provider.foodLibrary.where((item) => item.category == widget.category).toList();
      filteredItems.sort((a, b) {
        final aStarred = provider.isStarred(a.id);
        final bStarred = provider.isStarred(b.id);
        if (aStarred != bStarred) {
          return aStarred ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
    }

    if (filteredItems.isEmpty && provider.foodLibrary.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu_rounded, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              widget.category == 'starred' ? 'No starred meals yet' : 'No items in ${widget.category}',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = widget.selectedItemIds.contains(item.id);
        final isStarred = provider.isStarred(item.id);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.indigo : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onToggle(item.id),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    _buildItemImage(item),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildItemHeader(item, isStarred, provider),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildNutrientBadges(item),
                              const Spacer(),
                              Text(
                                item.dailyUse,
                                style: TextStyle(color: AppColors.indigo, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          _buildBenefitsText(item),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildSelectionIndicator(isSelected),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemImage(FoodLibraryItem item) {
    return Stack(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(top: 2, left: 2, child: _buildVegBadge(item.isVeg)),
      ],
    );
  }

  Widget _buildVegBadge(bool isVeg) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: isVeg ? Colors.green : Colors.red, width: 1.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Container(
        width: 6, height: 6,
        decoration: BoxDecoration(color: isVeg ? Colors.green : Colors.red, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildItemHeader(FoodLibraryItem item, bool isStarred, NutritionProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: -0.2),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () => provider.toggleStar(item.id),
          child: Icon(
            isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isStarred ? const Color(0xFFFFCA28) : Colors.grey[300],
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientBadges(FoodLibraryItem item) {
    return Row(
      children: [
        _buildBadge('${item.calories.toInt()} kcal', Colors.orange),
        const SizedBox(width: 6),
        _buildBadge('${item.protein}g protein', Colors.blue),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBenefitsText(FoodLibraryItem item) {
    return Text(
      item.benefits,
      style: TextStyle(fontSize: 9.5, color: Colors.grey[600], fontStyle: FontStyle.italic),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSelectionIndicator(bool isSelected) {
    return Container(
      width: 24, height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.indigo : Colors.grey[50],
        border: Border.all(color: isSelected ? AppColors.indigo : Colors.grey[200]!, width: 1.2),
      ),
      child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }
}
