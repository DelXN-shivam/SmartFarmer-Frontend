import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'dart:convert';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print('SharedPrefs init error: $e');
      // Retry once
      await Future.delayed(Duration(milliseconds: 100));
      _prefs = await SharedPreferences.getInstance();
    }
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

  static Future<void> saveFarmerData(Map<String, dynamic> data) async {
    await _prefs?.setString('user_data', json.encode(data));
  }

  // Save user data based on role
  static Future<void> saveUserData(Map<String, dynamic> userData, String role) async {
    try {
      await _prefs?.setString('user_data', json.encode(userData));
      await _prefs?.setString('user_role', role);
      await _prefs?.setString('user_id', userData['_id'] ?? userData['id'] ?? '');
      await _prefs?.setBool('is_logged_in', true);
      
      // Also save using AppConstants keys for consistency
      await setUserRole(role);
      await setUserId(userData['_id'] ?? userData['id'] ?? '');
      await setLoggedIn(true);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Get user data
  static Map<String, dynamic>? getUserData() {
    try {
      final userDataString = _prefs?.getString('user_data');
      if (userDataString != null && userDataString.isNotEmpty) {
        return json.decode(userDataString) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  // Get user token
  static String? getToken() {
    return _prefs?.getString('token');
  }

  // Save user token
  static Future<void> saveToken(String token) async {
    await _prefs?.setString('token', token);
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
    await _prefs?.remove('user_data');
    await _prefs?.remove('user_role');
    await _prefs?.remove('user_id');
    await _prefs?.remove('is_logged_in');
    await _prefs?.remove('token');
    return true;
  }

  // Get SharedPreferences instance
  static Future<SharedPreferences> getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  // JSON decode helper with error handling
  static Map<String, dynamic>? decodeJson(String jsonString) {
    try {
      if (jsonString.isEmpty) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('JSON decode error: $e');
      return null;
    }
  }
}
