import 'package:flutter/material.dart';
import 'package:nutrition_tracker/features/nutrition/models/food_entry.dart';
import 'package:nutrition_tracker/features/nutrition/services/nutrition_service.dart';
import 'package:nutrition_tracker/features/nutrition/services/ai_service.dart';
import 'package:nutrition_tracker/features/auth/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import 'dart:async';

class NutritionProvider extends ChangeNotifier {
  final NutritionService _nutritionService = NutritionService();
  final AiService _aiService = AiService();
  final _uuid = const Uuid();
  final AuthProvider authProvider;

  List<FoodEntry> _todayLogs = [];
  DateTime _selectedDate = DateTime.now();
  double _calorieGoal = 2000.0;
  double _proteinGoal = 60.0;
  double _waterGoal = 3.0; // Liters
  double _totalWater = 0.0;
  StreamSubscription? _logsSubscription;
  StreamSubscription? _waterSubscription;
  StreamSubscription? _yearlyLogsSubscription;
  StreamSubscription? _yearlyWaterSubscription;

  Map<DateTime, int> _yearlyProgress = {};
  List<FoodEntry> _lastYearlyLogs = [];
  Map<String, double> _lastYearlyWater = {};
  int _heatmapYear = DateTime.now().year;

  List<FoodEntry> get todayLogs => _todayLogs;
  DateTime get selectedDate => _selectedDate;
  double get calorieGoal => _calorieGoal;
  double get proteinGoal => _proteinGoal;
  double get waterGoal => _waterGoal;
  double get totalWater => _totalWater;
  Map<DateTime, int> get yearlyProgress => _yearlyProgress;
  List<FoodEntry> get yearlyLogs => _lastYearlyLogs;
  int get heatmapYear => _heatmapYear;

  double get totalCalories => _todayLogs.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => _todayLogs.fold(0, (sum, item) => sum + item.protein);

  int get healthScore {
    double calProgress = (totalCalories / calorieGoal).clamp(0.0, 1.0);
    double proProgress = (totalProtein / proteinGoal).clamp(0.0, 1.0);
    double waterProgress = (totalWater / waterGoal).clamp(0.0, 1.0);
    
    // Weighted score: 40% Cal, 40% Pro, 20% Water
    return ((calProgress * 40) + (proProgress * 40) + (waterProgress * 20)).toInt();
  }

  /// Dynamic water status text based on current intake
  String get waterStatusText {
    final ratio = totalWater / waterGoal;
    if (ratio >= 1.0) return 'Completed';
    if (ratio >= 0.7) return 'Almost Done';
    if (ratio >= 0.4) return 'On Track';
    return 'Low';
  }

  Color get waterStatusColor {
    final ratio = totalWater / waterGoal;
    if (ratio >= 1.0) return Colors.green;
    if (ratio >= 0.7) return Colors.orange;
    if (ratio >= 0.4) return Colors.blue;
    return Colors.red;
  }

  /// Number of glasses (250ml each)
  int get waterGlasses => (totalWater * 4).round(); // 1L = 4 glasses
  int get waterGlassGoal => (waterGoal * 4).round();


  NutritionProvider({required this.authProvider}) {
    _listenToLogs();
    _listenToWater();
    _listenToYearlyData();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _listenToLogs();
    _listenToWater();
    notifyListeners();
  }

  void _listenToLogs() {
    _logsSubscription?.cancel();
    if (authProvider.isAuthenticated) {
      _logsSubscription = _nutritionService
          .getDailyLogs(authProvider.user!.uid, _selectedDate)
          .listen((logs) {
        _todayLogs = logs;
        notifyListeners();
      });
    } else {
      _todayLogs = [];
      notifyListeners();
    }
  }

  void _listenToWater() {
    _waterSubscription?.cancel();
    if (authProvider.isAuthenticated) {
      _waterSubscription = _nutritionService
          .getWaterIntake(authProvider.user!.uid, _selectedDate)
          .listen((water) {
        _totalWater = water;
        notifyListeners();
      });
    } else {
      _totalWater = 0.0;
      notifyListeners();
    }
  }

  void _listenToYearlyData() {
    _yearlyLogsSubscription?.cancel();
    _yearlyWaterSubscription?.cancel();

    if (authProvider.isAuthenticated) {
      final currentYear = _heatmapYear;
      
      _lastYearlyLogs = [];
      _lastYearlyWater = {};

      void update() {
        _updateYearlyProgress(_lastYearlyLogs, _lastYearlyWater);
      }

      _yearlyLogsSubscription = _nutritionService
          .getYearlyLogs(authProvider.user!.uid, currentYear)
          .listen((logs) {
        _lastYearlyLogs = logs;
        update();
      });

      _yearlyWaterSubscription = _nutritionService
          .getYearlyWaterIntake(authProvider.user!.uid, currentYear)
          .listen((waterMap) {
        _lastYearlyWater = waterMap;
        update();
      });
    }
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  void _updateYearlyProgress(List<FoodEntry> allLogs, Map<String, double> allWater) {
    Map<String, double> dailyCals = {};
    Map<String, double> dailyPros = {};

    for (var entry in allLogs) {
      final key = _dateKey(entry.timestamp);
      dailyCals[key] = (dailyCals[key] ?? 0) + entry.calories;
      dailyPros[key] = (dailyPros[key] ?? 0) + entry.protein;
    }

    _yearlyProgress = {};
    Set<String> allDates = {...dailyCals.keys, ...dailyPros.keys, ...allWater.keys};

    for (var dateKey in allDates) {
      final cals = dailyCals[dateKey] ?? 0.0;
      final pros = dailyPros[dateKey] ?? 0.0;
      final water = allWater[dateKey] ?? 0.0;

      double calProgress = (cals / _calorieGoal).clamp(0.0, 1.0);
      double proProgress = (pros / _proteinGoal).clamp(0.0, 1.0);
      double waterProgress = (water / _waterGoal).clamp(0.0, 1.0);

      // Same formula as healthScore
      int score = ((calProgress * 40) + (proProgress * 40) + (waterProgress * 20)).toInt();
      
      final dateParts = dateKey.split('-');
      final date = DateTime(
        int.parse(dateParts[0]), 
        int.parse(dateParts[1]), 
        int.parse(dateParts[2])
      );
      _yearlyProgress[date] = score;
    }
    notifyListeners();
  }

  /// Add water and persist to Firebase (date-wise)
  Future<void> addWater(double amountLiters) async {
    if (!authProvider.isAuthenticated) return;
    await _nutritionService.addWaterIntake(
      authProvider.user!.uid,
      amountLiters,
      _selectedDate,
    );
    // No need to update _totalWater manually — the stream listener handles it
  }



  Future<void> addManualEntry(String name, double calories, double protein) async {
    if (!authProvider.isAuthenticated) return;
    
    final entry = FoodEntry(
      id: _uuid.v4(),
      name: name,
      calories: calories,
      protein: protein,
      timestamp: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      ),
      isAiGenerated: false,
    );
    await _nutritionService.addFoodEntry(authProvider.user!.uid, entry);
  }

  Future<FoodEntry> analyzeAndPreview(Uint8List imageBytes) async {
    final data = await _aiService.analyzeFoodImage(imageBytes);
    return FoodEntry(
      id: _uuid.v4(),
      name: data['name'] ?? 'Unknown Food',
      calories: (data['calories'] ?? 0.0).toDouble(),
      protein: (data['protein'] ?? 0.0).toDouble(),
      timestamp: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      ),
      isAiGenerated: true,
    );
  }

  Future<void> confirmAiEntry(FoodEntry entry) async {
    if (!authProvider.isAuthenticated) return;
    await _nutritionService.addFoodEntry(authProvider.user!.uid, entry);
  }

  Future<void> deleteEntry(String id) async {
    if (!authProvider.isAuthenticated) return;
    await _nutritionService.deleteFoodEntry(authProvider.user!.uid, id);
  }

  void setHeatmapYear(int year) {
    _heatmapYear = year;
    _listenToYearlyData();
    notifyListeners();
  }

  void updateGoals(double calorie, double protein, {double? water}) {
    _calorieGoal = calorie;
    _proteinGoal = protein;
    if (water != null) _waterGoal = water;
    _updateYearlyProgress(_lastYearlyLogs, _lastYearlyWater);
    notifyListeners();
  }

  @override
  void dispose() {
    _logsSubscription?.cancel();
    _waterSubscription?.cancel();
    _yearlyLogsSubscription?.cancel();
    _yearlyWaterSubscription?.cancel();
    super.dispose();
  }
}
