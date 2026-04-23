import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_tracker/features/nutrition/services/nutrition_service.dart';
import 'package:nutrition_tracker/features/profile/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NutritionService _nutritionService = NutritionService();

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      final user = userCredential.user;
      if (user != null) {
        // 1. Update Firebase Auth displayName
        await user.updateDisplayName(name);
        await user.reload();

        // 2. Save User Profile to Firestore
        final profile = UserProfile(
          uid: user.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );
        await _nutritionService.saveUserProfile(profile);
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update display name
  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) throw 'No authenticated user found.';
    
    // 1. Update Firebase Auth
    await user.updateDisplayName(name);
    await user.reload();

    // 2. Update Firestore
    final profile = await _nutritionService.getUserProfile(user.uid);
    if (profile != null) {
      await _nutritionService.saveUserProfile(profile.copyWith(name: name));
    }
  }

  // Handle exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
