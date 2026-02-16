import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/models/notification_model.dart';
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class NotificationService {
  static const Duration timeoutDuration = Duration(seconds: 30);

  /// Fetch notifications for the logged-in rider
  static Future<NotificationResponse?> getNotifications() async {
    try {
      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id.isEmpty) {
        throw Exception('Rider data not found. Please login again.');
      }

      // Construct the API URL
      final url = ApiConstant.notification(riderData.id);
      
      // Get auth token if available
      final token = await SharedPreferenceService.getToken();
      
      // Prepare headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('Fetching notifications from: $url');

      // Make the API call
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(timeoutDuration);

      print('Notification API Response Status: ${response.statusCode}');
      print('Notification API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return NotificationResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Notifications not found.');
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to fetch notifications';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error in getNotifications: $e');
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please check your internet connection.');
      } else if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        rethrow;
      }
    }
  }

  /// Delete notifications
/// Delete notifications
static Future<bool> deleteNotifications(List<String> notificationIds) async {
  try {
    // Get rider data from shared preferences
    final riderData = await SharedPreferenceService.getRiderData();
    if (riderData == null || riderData.id.isEmpty) {
      throw Exception('Rider data not found. Please login again.');
    }

    // Construct the API URL for deleting notifications
    final url = '${ApiConstant.baseUrl}api/rider/deletenotifications/${riderData.id}';
    
    // Get auth token if available
    final token = await SharedPreferenceService.getToken();
    
    // Prepare headers
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Prepare request body
    final body = json.encode({
      'notificationIds': notificationIds,
    });

    print('Deleting notifications from: $url');
    print('Delete payload: $body');

    // Make the API call
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
      body: body,
    ).timeout(timeoutDuration);

    print('Delete API Response Status: ${response.statusCode}');
    print('Delete API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      // Check if the response contains a message indicating success
      // Based on your response: {"message":"Notifications deleted successfully","deletedCount":1,...}
      if (responseData.containsKey('message') && 
          responseData['message'].toString().toLowerCase().contains('success')) {
        return true;
      }
      
      // Also consider it success if we have remainingNotifications array
      if (responseData.containsKey('remainingNotifications')) {
        return true;
      }
      
      // If we have deletedCount > 0, consider it success
      if (responseData.containsKey('deletedCount') && responseData['deletedCount'] > 0) {
        return true;
      }
      
      return true; // Default to success for 200 status code
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access. Please login again.');
    } else if (response.statusCode == 404) {
      throw Exception('Notifications not found.');
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Failed to delete notifications';
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Error in deleteNotifications: $e');
    if (e.toString().contains('TimeoutException')) {
      throw Exception('Request timeout. Please check your internet connection.');
    } else if (e.toString().contains('SocketException')) {
      throw Exception('No internet connection. Please check your network.');
    } else {
      rethrow;
    }
  }
}

  /// Mark a notification as read (if API supports it)
  static Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id.isEmpty) {
        throw Exception('Rider data not found. Please login again.');
      }

      final token = await SharedPreferenceService.getToken();
      
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // Construct URL for marking notification as read
      // Note: This endpoint might not exist in your API, adjust as needed
      final url = '${ApiConstant.baseUrl}api/rider/notifications/${riderData.id}/$notificationId/read';

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode({'read': true}),
      ).timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      print('Error in markNotificationAsRead: $e');
      return false;
    }
  }

  /// Get unread notification count
  static Future<int> getUnreadCount() async {
    try {
      final notificationResponse = await getNotifications();
      if (notificationResponse != null) {
        return notificationResponse.notifications
            .where((notification) => !notification.read)
            .length;
      }
      return 0;
    } catch (e) {
      print('Error in getUnreadCount: $e');
      return 0;
    }
  }

  /// Refresh notifications (same as getNotifications but with different naming for clarity)
  static Future<NotificationResponse?> refreshNotifications() async {
    return await getNotifications();
  }
}