import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language preferences
  static String? getLanguage() {
    return _prefs?.getString(AppConstants.keyLanguage);
  }

  static Future<bool> setLanguage(String languageCode) async {
    return await _prefs?.setString(AppConstants.keyLanguage, languageCode) ??
        false;
  }

  // User authentication
  static String? getUserRole() {
    return _prefs?.getString(AppConstants.keyUserRole);
  }

  static Future<bool> setUserRole(String role) async {
    return await _prefs?.setString(AppConstants.keyUserRole, role) ?? false;
  }

  static String? getUserId() {
    return _prefs?.getString(AppConstants.keyUserId);
  }

  static Future<bool> setUserId(String userId) async {
    return await _prefs?.setString(AppConstants.keyUserId, userId) ?? false;
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  static Future<bool> setLoggedIn(bool isLoggedIn) async {
    return await _prefs?.setBool(AppConstants.keyIsLoggedIn, isLoggedIn) ??
        false;
  }

  // Clear all data
  static Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }

  // Clear only authentication data
  static Future<bool> clearAuthData() async {
    await _prefs?.remove(AppConstants.keyUserRole);
    await _prefs?.remove(AppConstants.keyUserId);
    await _prefs?.remove(AppConstants.keyIsLoggedIn);
    return true;
  }
}
