import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/dashboard_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class DashboardService {
  
  /// Fetches dashboard data for the given rider ID
  static Future<DashboardResponse?> getDashboardData(String riderId) async {
    try {
      final url = ApiConstant.getDashboardUrl(riderId);
      
      // Get auth token if available
      final token = await SharedPreferenceService.getToken();
      
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      
      // Add authorization header if token exists
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DashboardResponse.fromJson(jsonData);
      } else {
        print('Dashboard API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Dashboard Service Error: $e');
      return null;
    }
  }

  /// Fetches dashboard data for the currently logged-in rider
  static Future<DashboardResponse?> getCurrentRiderDashboard() async {
    try {
      final rider = await SharedPreferenceService.getRiderData();
      if (rider != null && rider.id.isNotEmpty) {
        return await getDashboardData(rider.id);
      } else {
        print('No rider data found in shared preferences');
        return null;
      }
    } catch (e) {
      print('Get Current Rider Dashboard Error: $e');
      return null;
    }
  }
}