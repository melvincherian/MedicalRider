

// services/status_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/models/details_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';
import '../constants/api_constant.dart';

class StatusService {
  
  /// Get orders by status for a specific rider
  Future<OrderResponse?> getOrdersByStatus({
    required String riderId,
    required String status,
  }) async {
    try {
      final token = await SharedPreferenceService.getToken();
      
      final url = Uri.parse(
        '${ApiConstant.baseUrl}api/rider/orders/$riderId?assignedRiderStatus=$status'
      );
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      print('Fetching orders: $url');
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderResponse.fromJson(jsonData);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getOrdersByStatus: $e');
      return null;
    }
  }

  /// Get all orders without status filter
  Future<OrderResponse?> getAllOrders(String riderId) async {
    try {
      final token = await SharedPreferenceService.getToken();
      
      final url = Uri.parse('${ApiConstant.baseUrl}api/rider/orders/$riderId');
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      print('Fetching all orders: $url');
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OrderResponse.fromJson(jsonData);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getAllOrders: $e');
      return null;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus({
    required String riderId,
    required String orderId,
    required String newStatus,
  }) async {
    try {
      final token = await SharedPreferenceService.getToken();
      
      final url = Uri.parse(ApiConstant.updateOrderstatus(riderId));
      
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      
      final body = json.encode({
        'orderId': orderId,
        'status': newStatus,
      });
      
      print('Updating order status: $orderId -> $newStatus');
      
      final response = await http.put(url, headers: headers, body: body);
      
      if (response.statusCode == 200) {
        print('Order status updated successfully');
        return true;
      } else {
        print('Update Status Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in updateOrderStatus: $e');
      return false;
    }
  }
}