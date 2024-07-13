import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String redirectToLoginKey = 'redirectToLogin';
  static const String currentOrganizationKey = 'currentOrganization';
  static const String miembrosKey = 'miembros'; // Clave para los miembros

  static Future<void> setMiembros(List<Map<String, dynamic>> value) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> miembrosStrings =
        value.map((e) => jsonEncode(e)).toList(); // Codifica cada mapa a JSON
    await prefs.setStringList(miembrosKey, miembrosStrings);
  }

  static Future<List<Map<String, dynamic>>> getMiembros() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? miembrosStrings = prefs.getStringList(miembrosKey);
    if (miembrosStrings != null) {
      return miembrosStrings
          .map((miembro) => jsonDecode(miembro) as Map<String, dynamic>)
          .toList(); // Decodifica cada cadena JSON a mapa
    } else {
      return []; // Devuelve una lista vacía si no hay miembros guardados
    }
  }

  static Future<bool> getRedirectToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(redirectToLoginKey) ?? false;
  }

  static Future<void> setRedirectToLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(redirectToLoginKey, value);
  }

  // Preferencia para la organización actual
  static Future<String?> getCurrentOrganization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentOrganizationKey);
  }

  static Future<void> setCurrentOrganization(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentOrganizationKey, value);
  }
}
