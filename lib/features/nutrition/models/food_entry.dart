import 'package:cloud_firestore/cloud_firestore.dart';

class FoodEntry {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final DateTime timestamp;
  final String? imageUrl;
  final bool isAiGenerated;

  FoodEntry({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.timestamp,
    this.imageUrl,
    this.isAiGenerated = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'isAiGenerated': isAiGenerated,
    };
  }

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    return FoodEntry(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      calories: (map['calories'] ?? 0.0).toDouble(),
      protein: (map['protein'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      imageUrl: map['imageUrl'],
      isAiGenerated: map['isAiGenerated'] ?? false,
    );
  }

  factory FoodEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodEntry.fromMap(data);
  }
}

class DailyStats {
  final double totalCalories;
  final double totalProtein;
  final double calorieGoal;
  final double proteinGoal;

  DailyStats({
    required this.totalCalories,
    required this.totalProtein,
    required this.calorieGoal,
    required this.proteinGoal,
  });

  double get calorieProgress => (totalCalories / calorieGoal).clamp(0.0, 1.0);
  double get proteinProgress => (totalProtein / proteinGoal).clamp(0.0, 1.0);
}
