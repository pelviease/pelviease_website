// AuthProvider class
import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/firebase_services/auth_service.dart';
import 'package:pelviease_website/backend/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    checkCurrentUser();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Check if a user is already logged in
  Future<void> checkCurrentUser() async {
    if (_user != null) return;
    try {
      _setLoading(true);
      _clearError();
      _user = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();
      _user = await _authService.login(email, password);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Signup method
  Future<void> signup(
    String name,
    String email,
    String password,
    bool isDoctor,
  ) async {
    try {
      _setLoading(true);
      _clearError();
      _user = await _authService.signup(name, email, password, isDoctor);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      _setLoading(true);
      _clearError();
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
