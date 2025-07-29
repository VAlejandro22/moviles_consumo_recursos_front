import 'package:flutter/material.dart';

class FakeLoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Credenciales válidas para las pruebas
  static const Map<String, String> _validCredentials = {
    'admin': 'admin123',
    'user': 'user123',
    'demo': 'demo123',
    'test': 'test123',
  };

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Usuario y contraseña son obligatorios';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (_validCredentials.containsKey(username) &&
          _validCredentials[username] == password) {
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Credenciales incorrectas';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> checkLoginStatus() async {
    // Simular verificación de estado
    await Future.delayed(const Duration(milliseconds: 500));
    return _isLoggedIn;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Métodos específicos para testing
  void setMockLoginState(bool loggedIn) {
    _isLoggedIn = loggedIn;
    notifyListeners();
  }

  void setMockError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void setMockLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Simular diferentes escenarios de error para las pruebas
  void simulateNetworkError() {
    _errorMessage = 'Error de conexión de red';
    _isLoading = false;
    notifyListeners();
  }

  void simulateServerError() {
    _errorMessage = 'Error interno del servidor';
    _isLoading = false;
    notifyListeners();
  }
}
