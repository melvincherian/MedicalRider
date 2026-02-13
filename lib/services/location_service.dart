

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/login_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class LocationService {
  
  /// Add location using stored user data from SharedPreferences
  Future<bool> addLocation(String latitude, String longitude) async {
    try {
      // Get rider data from SharedPreferences
      RiderModel? rider = await SharedPreferenceService.getRiderData();
      
      if (rider == null) {
        print('❌ No rider data found in SharedPreferences');
        return false;
      }

      // Extract user ID from rider model
      String userId = rider.id?.toString() ?? '';
      
      if (userId.isEmpty) {
        print('❌ User ID is empty or null');
        return false;
      }

      return await _addLocationWithUserId(userId, latitude, longitude);
      
    } catch (e) {
      print('🚨 Error getting rider data: $e');
      return false;
    }
  }

  /// Add location with explicit user ID (alternative method)
  Future<bool> addLocationWithUserId(String userId, String latitude, String longitude) async {
    if (userId.isEmpty) {
      print('❌ User ID cannot be empty');
      return false;
    }
    
    return await _addLocationWithUserId(userId, latitude, longitude);
  }

  /// Private method to handle the actual API call
  Future<bool> _addLocationWithUserId(String userId, String latitude, String longitude) async {
    try {
      print('📍 Adding location for user: $userId');
      print('➡ Latitude: $latitude, Longitude: $longitude');

      // Get the complete URL
      String url = ApiConstant.getuserlocation(userId);
      print('🔗 Complete URL: $url');
      
      // Get auth token if available
      String? token = await SharedPreferenceService.getToken();
      
      // Prepare headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      // Add authorization header if token exists
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // Prepare request body
      Map<String, dynamic> requestBody = {
        'latitude': latitude,
        'longitude': longitude,
      };

      print('📤 Request Headers: $headers');
      print('📤 Request Body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('🛰 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Location updated successfully');
        return true;
      } else if (response.statusCode == 404) {
        print('❌ API endpoint not found. Check the URL or contact backend team.');
        print('❌ Attempted URL: $url');
        return false;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized. Token might be expired or invalid.');
        return false;
      } else if (response.statusCode == 403) {
        print('❌ Forbidden. User might not have permission to update location.');
        return false;
      } else {
        print('❌ Failed to add location. Status: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('🚨 Error adding location: $e');
      return false;
    }
  }

  /// Alternative method using PUT request (if your API expects PUT instead of POST)
  Future<bool> updateLocationPut(String latitude, String longitude) async {
    try {
      // Get rider data from SharedPreferences
      RiderModel? rider = await SharedPreferenceService.getRiderData();
      
      if (rider == null) {
        print('❌ No rider data found in SharedPreferences');
        return false;
      }

      String userId = rider.id?.toString() ?? '';
      
      if (userId.isEmpty) {
        print('❌ User ID is empty or null');
        return false;
      }

      print('📍 Updating location for user: $userId');
      print('➡ Latitude: $latitude, Longitude: $longitude');

      String url = ApiConstant.getuserlocation(userId);
      print('🔗 Complete URL: $url');
      
      String? token = await SharedPreferenceService.getToken();
      
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      print('🛰 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Location updated successfully');
        return true;
      } else {
        print('❌ Failed to update location. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('🚨 Error updating location: $e');
      return false;
    }
  }

  /// Check if user is logged in before updating location
  Future<bool> addLocationIfLoggedIn(String latitude, String longitude) async {
    try {
      // Check if user is logged in
      bool isLoggedIn = await SharedPreferenceService.getLoginStatus();
      
      if (!isLoggedIn) {
        print('❌ User is not logged in. Cannot update location.');
        return false;
      }

      return await addLocation(latitude, longitude);
      
    } catch (e) {
      print('🚨 Error checking login status: $e');
      return false;
    }
  }

  /// Get current user info for debugging
  Future<void> debugUserInfo() async {
    try {
      RiderModel? rider = await SharedPreferenceService.getRiderData();
      bool isLoggedIn = await SharedPreferenceService.getLoginStatus();
      String? token = await SharedPreferenceService.getToken();

      print('🔍 Debug User Info:');
      print('   Is Logged In: $isLoggedIn');
      print('   Has Rider Data: ${rider != null}');
      print('   User ID: ${rider?.id ?? "null"}');
      print('   Has Token: ${token != null && token.isNotEmpty}');
      
      if (rider != null) {
        String userId = rider.id?.toString() ?? '';
        String url = ApiConstant.getuserlocation(userId);
        print('   Generated URL: $url');
      }
    } catch (e) {
      print('🚨 Error in debug: $e');
    }
  }
}