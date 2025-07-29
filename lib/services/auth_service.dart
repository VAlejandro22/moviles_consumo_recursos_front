import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUsername = 'username';

  // Credenciales válidas para el login (simulado)
  static const Map<String, String> _validCredentials = {
    'admin': 'admin123',
    'user': 'user123',
    'demo': 'demo123',
  };

  Future<bool> login(String username, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Verificar credenciales
    if (_validCredentials.containsKey(username) &&
        _validCredentials[username] == password) {

      // Guardar estado de login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, username);

      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUsername);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}
