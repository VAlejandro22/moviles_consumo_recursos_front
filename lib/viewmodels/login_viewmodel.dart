import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Usuario y contraseña son obligatorios';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.login(username, password);

      if (!success) {
        _errorMessage = 'Credenciales incorrectas';
      }

      _isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _errorMessage = 'Error de conexión: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    return await _authService.isLoggedIn();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
