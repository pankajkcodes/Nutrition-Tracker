import 'package:flutter/material.dart';
import '../models/food_entry.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';
import 'auth_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import 'dart:async';

import '../models/dashboard_data.dart';

class NutritionProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final AiService _aiService = AiService();
  final _uuid = const Uuid();
  final AuthProvider authProvider;

  List<FoodEntry> _todayLogs = [];
  double _calorieGoal = 2000.0;
  double _proteinGoal = 60.0; // Updated to match image
  double _waterGoal = 3.0; // Liters
  double _totalWater = 0.0;
  int _sunlightMinutes = 0;
  StreamSubscription? _logsSubscription;

  List<FoodEntry> get todayLogs => _todayLogs;
  double get calorieGoal => _calorieGoal;
  double get proteinGoal => _proteinGoal;
  double get waterGoal => _waterGoal;
  double get totalWater => _totalWater;
  int get sunlightMinutes => _sunlightMinutes;

  double get totalCalories => _todayLogs.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => _todayLogs.fold(0, (sum, item) => sum + item.protein);

  int get healthScore {
    double calProgress = (totalCalories / calorieGoal).clamp(0.0, 1.0);
    double proProgress = (totalProtein / proteinGoal).clamp(0.0, 1.0);
    double waterProgress = (totalWater / waterGoal).clamp(0.0, 1.0);
    
    // Weighted score: 40% Cal, 40% Pro, 20% Water
    return ((calProgress * 40) + (proProgress * 40) + (waterProgress * 20)).toInt();
  }

  List<NutrientStatus> get nutrientStatuses {
    return [
      NutrientStatus(
        name: 'Vitamin D',
        status: _sunlightMinutes < 15 ? 'Deficient' : 'Good',
        suggestion: _sunlightMinutes < 15 ? 'Get 15 min sunlight' : 'Keep it up!',
        icon: Icons.wb_sunny_rounded,
        color: _sunlightMinutes < 15 ? Colors.orange : Colors.green,
      ),
      NutrientStatus(
        name: 'Protein Co-factors',
        status: totalProtein < (proteinGoal / 2) ? 'Deficient' : 'Good',
        suggestion: totalProtein < (proteinGoal / 2) ? 'Add eggs, milk, paneer' : 'Great intake!',
        icon: Icons.biotech_rounded,
        color: totalProtein < (proteinGoal / 2) ? Colors.purple : Colors.green,
      ),
      NutrientStatus(
        name: 'Iron',
        status: totalCalories < (calorieGoal / 2) ? 'Low' : 'Good',
        suggestion: totalCalories < (calorieGoal / 2) ? 'Eat leafy greens' : 'Looking good!',
        icon: Icons.opacity_rounded,
        color: totalCalories < (calorieGoal / 2) ? Colors.red : Colors.green,
      ),
    ];
  }

  List<SmartSuggestion> get smartSuggestions {
    final suggestions = <SmartSuggestion>[];

    if (totalProtein < proteinGoal) {
      suggestions.add(SmartSuggestion(
        title: 'Eat roasted chana (1 bowl)',
        subtitle: 'Add ~10g protein to reach your goal.',
        tag: '+10g Protein',
        icon: Icons.lightbulb_outline_rounded,
        bgColor: Colors.orange[50]!,
        iconColor: Colors.orange[600]!,
      ));
    }

    if (_sunlightMinutes < 15) {
      suggestions.add(SmartSuggestion(
        title: 'Go outside for 15 minutes',
        subtitle: 'Helps in Vitamin D absorption.',
        tag: 'Mark Done',
        icon: Icons.wb_sunny_outlined,
        bgColor: Colors.blue[50]!,
        iconColor: Colors.blue[600]!,
        isButton: true,
        onTap: () => addSunlight(15),
      ));
    }

    if (totalWater < waterGoal) {
      suggestions.add(SmartSuggestion(
        title: 'Drink 500ml water',
        subtitle: 'Stay hydrated for better focus',
        tag: 'Drink',
        icon: Icons.water_drop_outlined,
        bgColor: Colors.blue[50]!,
        iconColor: Colors.blue[400]!,
        isButton: true,
        onTap: () => addWater(0.5),
      ));
    }

    return suggestions;
  }

  NutritionProvider({required this.authProvider}) {
    _listenToLogs();
  }

  void _listenToLogs() {
    _logsSubscription?.cancel();
    if (authProvider.isAuthenticated) {
      _logsSubscription = _firebaseService
          .getDailyLogs(authProvider.user!.uid, DateTime.now())
          .listen((logs) {
        _todayLogs = logs;
        notifyListeners();
      });
    } else {
      _todayLogs = [];
      notifyListeners();
    }
  }

  Future<void> addWater(double amount) async {
    _totalWater += amount;
    notifyListeners();
  }

  void addSunlight(int minutes) {
    _sunlightMinutes += minutes;
    notifyListeners();
  }

  void resetWater() {
    _totalWater = 0;
    _sunlightMinutes = 0;
    notifyListeners();
  }

  Future<void> addManualEntry(String name, double calories, double protein) async {
    if (!authProvider.isAuthenticated) return;
    
    final entry = FoodEntry(
      id: _uuid.v4(),
      name: name,
      calories: calories,
      protein: protein,
      timestamp: DateTime.now(),
      isAiGenerated: false,
    );
    await _firebaseService.addFoodEntry(authProvider.user!.uid, entry);
  }

  Future<FoodEntry> analyzeAndPreview(Uint8List imageBytes) async {
    final data = await _aiService.analyzeFoodImage(imageBytes);
    return FoodEntry(
      id: _uuid.v4(),
      name: data['name'] ?? 'Unknown Food',
      calories: (data['calories'] ?? 0.0).toDouble(),
      protein: (data['protein'] ?? 0.0).toDouble(),
      timestamp: DateTime.now(),
      isAiGenerated: true,
    );
  }

  Future<void> confirmAiEntry(FoodEntry entry) async {
    if (!authProvider.isAuthenticated) return;
    await _firebaseService.addFoodEntry(authProvider.user!.uid, entry);
  }

  Future<void> deleteEntry(String id) async {
    if (!authProvider.isAuthenticated) return;
    await _firebaseService.deleteFoodEntry(authProvider.user!.uid, id);
  }

  void updateGoals(double calorie, double protein, {double? water}) {
    _calorieGoal = calorie;
    _proteinGoal = protein;
    if (water != null) _waterGoal = water;
    notifyListeners();
  }

  @override
  void dispose() {
    _logsSubscription?.cancel();
    super.dispose();
  }
}
