import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String redirectToLoginKey = 'redirectToLogin';

  static Future<bool> getRedirectToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(redirectToLoginKey) ?? false;
  }

  static Future<void> setRedirectToLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(redirectToLoginKey, value);
  }
}
