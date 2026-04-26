import 'package:cloud_firestore/cloud_firestore.dart';

class FoodLibraryItem {
  final String id;
  final String name;
  final String dailyUse;
  final double protein;
  final double calories;
  final String benefits;
  final bool isVeg;
  final String imageUrl;
  final String category;

  FoodLibraryItem({
    required this.id,
    required this.name,
    required this.dailyUse,
    required this.protein,
    required this.calories,
    required this.benefits,
    required this.isVeg,
    required this.imageUrl,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dailyUse': dailyUse,
      'protein': protein,
      'calories': calories,
      'benefits': benefits,
      'isVeg': isVeg,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory FoodLibraryItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodLibraryItem(
      id: doc.id,
      name: data['name'] ?? '',
      dailyUse: data['dailyUse'] ?? '',
      protein: (data['protein'] ?? 0.0).toDouble(),
      calories: (data['calories'] ?? 0.0).toDouble(),
      benefits: data['benefits'] ?? '',
      isVeg: data['isVeg'] ?? true,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'others',
    );
  }
}
