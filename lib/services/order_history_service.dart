// order_history_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/history_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';



class OrderHistoryService {
  static const Duration _timeout = Duration(seconds: 30);

  // Get previous orders
  static Future<List<OrderModel>> getPreviousOrders() async {
    try {
      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id.isEmpty) {
        throw Exception('Rider not found. Please login again.');
      }

      final url = ApiConstant.previousorder(riderData.id);
      print('Previous Orders API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);

      print('Previous Orders Response Status: ${response.statusCode}');
      print('Previous Orders Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final orderHistoryResponse = OrderHistoryResponse.fromPreviousOrdersJson(jsonResponse);
        return orderHistoryResponse.previousOrders;
      } else if (response.statusCode == 404) {
        // No previous orders found
        return [];
      } else {
        throw Exception('Failed to load previous orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching previous orders: $e');
      throw Exception('Failed to fetch previous orders: $e');
    }
  }

  // Get active orders
  static Future<List<OrderModel>> getActiveOrders() async {
    try {
      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id.isEmpty) {
        throw Exception('Rider not found. Please login again.');
      }

      final url = ApiConstant.activeorder(riderData.id);
      print('Active Orders API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);

      print('Active Orders Response Status: ${response.statusCode}');
      print('Active Orders Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final orderHistoryResponse = OrderHistoryResponse.fromActiveOrdersJson(jsonResponse);
        return orderHistoryResponse.activeOrders;
      } else if (response.statusCode == 404) {
        // No active orders found
        return [];
      } else {
        throw Exception('Failed to load active orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching active orders: $e');
      throw Exception('Failed to fetch active orders: $e');
    }
  }

  // Get both previous and active orders
  static Future<Map<String, List<OrderModel>>> getAllOrders() async {
    try {
      final results = await Future.wait([
        getPreviousOrders(),
        getActiveOrders(),
      ]);

      return {
        'previous': results[0],
        'active': results[1],
      };
    } catch (e) {
      print('Error fetching all orders: $e');
      throw Exception('Failed to fetch orders: $e');
    }
  }
}