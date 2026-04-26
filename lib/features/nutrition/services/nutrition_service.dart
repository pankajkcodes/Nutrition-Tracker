import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrition_tracker/features/nutrition/models/food_entry.dart';
import 'package:nutrition_tracker/features/nutrition/models/food_library_item.dart';
import 'package:nutrition_tracker/features/profile/models/user_profile.dart';

class NutritionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _getUserLogCollection(String userId) => 
      _firestore.collection('users').doc(userId).collection('logs');

  Future<void> saveUserProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(
          profile.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserProfile.fromFirestore(doc);
    }
    return null;
  }

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

  // --- Water Tracking ---

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  DocumentReference _getDailyTrackingDoc(String userId, DateTime date) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_tracking')
          .doc(_dateKey(date));

  Future<void> addWaterIntake(String userId, double amountLiters, DateTime date) async {
    final docRef = _getDailyTrackingDoc(userId, date);
    await docRef.set({
      'waterIntake': FieldValue.increment(amountLiters),
      'date': _dateKey(date),
    }, SetOptions(merge: true));
  }

  Stream<double> getWaterIntake(String userId, DateTime date) {
    return _getDailyTrackingDoc(userId, date).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        return (data?['waterIntake'] ?? 0.0).toDouble();
      }
      return 0.0;
    });
  }
  Stream<List<FoodEntry>> getYearlyLogs(String userId, int year) {
    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(year + 1, 1, 1);

    return _getUserLogCollection(userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfYear.toIso8601String())
        .where('timestamp', isLessThan: endOfYear.toIso8601String())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FoodEntry.fromFirestore(doc)).toList();
    });
  }

  Stream<Map<String, double>> getYearlyWaterIntake(String userId, int year) {
    final startOfYear = '${year}-01-01';
    final endOfYear = '${year + 1}-01-01';

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_tracking')
        .where('date', isGreaterThanOrEqualTo: startOfYear)
        .where('date', isLessThan: endOfYear)
        .snapshots()
        .map((snapshot) {
      Map<String, double> data = {};
      for (var doc in snapshot.docs) {
        final map = doc.data();
        data[map['date']] = (map['waterIntake'] ?? 0.0).toDouble();
      }
      return data;
    });
  }

  // --- Food Library ---

  Stream<List<FoodLibraryItem>> getFoodLibrary() {
    // Firestore's snapshots() has built-in caching support. 
    // It will return data from cache first if available and then update from server.
    return _firestore.collection('food_library').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => FoodLibraryItem.fromFirestore(doc)).toList();
    });
  }

  Future<void> seedFoodLibrary(List<FoodLibraryItem> items) async {
    final collection = _firestore.collection('food_library');
    final batch = _firestore.batch();
    
    // Fetch existing docs to clean up old random IDs from the first seed
    final existingDocs = await collection.get();
    final validIds = items.map((e) => e.id).toSet();

    for (var doc in existingDocs.docs) {
      if (!validIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    // Use SetOptions(merge: true) so it updates existing items and adds new ones
    for (var item in items) {
      final docRef = collection.doc(item.id); 
      batch.set(docRef, item.toMap(), SetOptions(merge: true));
    }
    
    await batch.commit();
  }

  Future<void> resetDailyData(String userId, DateTime date) async {
    final batch = _firestore.batch();

    // 1. Delete food logs for the date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final logsSnapshot = await _getUserLogCollection(userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('timestamp', isLessThan: endOfDay.toIso8601String())
        .get();

    for (var doc in logsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 2. Delete water tracking for the date
    final waterDocRef = _getDailyTrackingDoc(userId, date);
    batch.delete(waterDocRef);

    await batch.commit();
  }
}
