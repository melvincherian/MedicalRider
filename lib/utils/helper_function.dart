import 'package:medical_delivery_app/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferenceService {
  static const String _riderKey = 'rider_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _tokenKey = 'auth_token';

  // Save rider data
  static Future<bool> saveRiderData(RiderModel rider) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final riderJson = json.encode(rider.toJson());
      return await prefs.setString(_riderKey, riderJson);
    } catch (e) {
      return false;
    }
  }



    static Future<void> saveRiderStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rider_status', status);
  }


   static Future<String?> getRiderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rider_status');
  }

  // Get rider data
  static Future<RiderModel?> getRiderData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final riderJson = prefs.getString(_riderKey);
      if (riderJson != null) {
        final riderMap = json.decode(riderJson);
        return RiderModel.fromJson(riderMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Set login status
  static Future<bool> setLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_isLoggedInKey, isLoggedIn);
    } catch (e) {
      return false;
    }
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Save auth token (if needed)
  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      return false;
    }
  }

  // Get auth token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  // Clear all data (logout)
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_riderKey);
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_tokenKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}