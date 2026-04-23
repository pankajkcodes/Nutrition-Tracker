import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_entry.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _getUserLogCollection(String userId) => 
      _firestore.collection('users').doc(userId).collection('logs');

  Future<void> addFoodEntry(String userId, FoodEntry entry) async {
    await _getUserLogCollection(userId).doc(entry.id).set(entry.toMap());
  }

  Stream<List<FoodEntry>> getDailyLogs(String userId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _getUserLogCollection(userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('timestamp', isLessThan: endOfDay.toIso8601String())
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FoodEntry.fromFirestore(doc)).toList();
    });
  }

  Future<void> deleteFoodEntry(String userId, String id) async {
    await _getUserLogCollection(userId).doc(id).delete();
  }
}
