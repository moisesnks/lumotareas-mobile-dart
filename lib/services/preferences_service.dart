import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String redirectToLoginKey = 'redirectToLogin';
  static const String currentOrganizationKey = 'currentOrganization';

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
