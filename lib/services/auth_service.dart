import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String nameKey = 'user_name';
  static const String emailKey = 'user_email';
  static const String passwordKey = 'user_password';
  static const String loggedInKey = 'is_logged_in';

  static Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(nameKey, name);
    await prefs.setString(emailKey, email);
    await prefs.setString(passwordKey, password);
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(emailKey);
    final savedPassword = prefs.getString(passwordKey);

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool(loggedInKey, true);
      return true;
    }

    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loggedInKey) ?? false;
  }

  static Future<bool> hasAccount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(emailKey) && prefs.containsKey(passwordKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }
}