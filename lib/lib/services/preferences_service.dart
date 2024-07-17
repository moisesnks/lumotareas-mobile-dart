//servicio para manejar las preferencias compartidas de la aplicación.
library;

import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar las preferencias compartidas de la aplicación.
class PreferencesService {
  static const String redirectToLoginKey = 'redirectToLogin';

  /// Obtiene el valor de la preferencia `redirectToLogin`.
  ///
  /// Devuelve `true` si se debe redirigir al usuario al inicio de sesión, `false` en caso contrario.
  static Future<bool> getRedirectToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(redirectToLoginKey) ?? false;
  }

  /// Establece el valor de la preferencia `redirectToLogin`.
  ///
  /// [value] es un valor booleano que indica si se debe redirigir al usuario al inicio de sesión.
  static Future<void> setRedirectToLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(redirectToLoginKey, value);
  }
}
