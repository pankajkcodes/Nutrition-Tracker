import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String? profilePicUrl;
  final DateTime createdAt;
  final double calorieGoal;
  final double proteinGoal;
  final double waterGoal;
  final List<String> starredMealIds;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePicUrl,
    required this.createdAt,
    this.calorieGoal = 2000.0,
    this.proteinGoal = 60.0,
    this.waterGoal = 3.0,
    this.starredMealIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'createdAt': createdAt.toIso8601String(),
      'calorieGoal': calorieGoal,
      'proteinGoal': proteinGoal,
      'waterGoal': waterGoal,
      'starredMealIds': starredMealIds,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePicUrl: map['profilePicUrl'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      calorieGoal: (map['calorieGoal'] ?? 2000.0).toDouble(),
      proteinGoal: (map['proteinGoal'] ?? 60.0).toDouble(),
      waterGoal: (map['waterGoal'] ?? 3.0).toDouble(),
      starredMealIds: List<String>.from(map['starredMealIds'] ?? []),
    );
  }

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile.fromMap(data);
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? profilePicUrl,
    double? calorieGoal,
    double? proteinGoal,
    double? waterGoal,
    List<String>? starredMealIds,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      waterGoal: waterGoal ?? this.waterGoal,
      starredMealIds: starredMealIds ?? this.starredMealIds,
    );
  }
}
