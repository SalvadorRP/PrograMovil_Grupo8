import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalService {
  static const String _passwordPrefix = 'password_';

  Future<void> guardarPassword({
    required String codigo,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_passwordPrefix$codigo', password);
  }

  Future<String?> obtenerPassword(String codigo) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_passwordPrefix$codigo');
  }

  Future<bool> tienePassword(String codigo) async {
    final password = await obtenerPassword(codigo);
    return password != null && password.isNotEmpty;
  }

  Future<bool> validarPassword({
    required String codigo,
    required String password,
  }) async {
    final passwordGuardada = await obtenerPassword(codigo);

    if (passwordGuardada == null) {
      return false;
    }

    return passwordGuardada == password;
  }
}