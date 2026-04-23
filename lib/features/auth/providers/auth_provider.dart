import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrition_tracker/features/auth/services/auth_service.dart';
import 'package:nutrition_tracker/features/nutrition/services/nutrition_service.dart';
import 'package:nutrition_tracker/features/profile/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final NutritionService _nutritionService = NutritionService();
  User? _user;
  UserProfile? _userProfile;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  User? get user => _user;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _userProfile = await _nutritionService.getUserProfile(user.uid);
      } else {
        _userProfile = null;
      }
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signUpWithEmailAndPassword(name, email, password);
      
      // Manually refresh to avoid race condition with the stream listener
      _user = _authService.currentUser;
      if (_user != null) {
        _userProfile = await _nutritionService.getUserProfile(_user!.uid);
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> updateProfileName(String name) async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.updateDisplayName(name);
      // Refresh user and profile
      _user = _authService.currentUser;
      if (_user != null) {
        _userProfile = await _nutritionService.getUserProfile(_user!.uid);
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
