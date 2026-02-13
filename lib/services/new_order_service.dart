
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/new_order_model.dart';

// class NewOrderService {
//   static const String baseUrl = 'http://31.97.206.144:7021/api';

//   Future<List<NewOrder>> fetchNewOrders(String riderId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/rider/neworders/$riderId'),
//       );
//       print('RiderId: $riderId');

//       print('Fetch New Orders Response Status: ${response.statusCode}');
//       print('Fetch New Orders Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         final orderResponse = NewOrderResponse.fromJson(jsonData);
//         return orderResponse.newOrders;
//       } else {
//         throw Exception('Failed to load new orders: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching new orders: $e');
//       throw Exception('Error fetching new orders: $e');
//     }
//   }

//   Future<bool> updateOrderStatus(String orderId, String status) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/rider/updateorderstatus/$orderId'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'status': status,
//         }),
//       );

//       print('Update Order Status Response Status: ${response.statusCode}');
//       print('Update Order Status Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         return jsonData['success'] ?? false;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print('Error updating order status: $e');
//       return false;
//     }
//   }
// }














import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/new_order_model.dart';

class NewOrderService {
  static const String baseUrl = 'http://31.97.206.144:7021/api';

  Future<List<NewOrder>> fetchNewOrders(String riderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rider/neworders/$riderId'),
      );
      print('RiderId: $riderId');

      print('Fetch New Orders Response Status: ${response.statusCode}');
      print('Fetch New Orders Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final orderResponse = NewOrderResponse.fromJson(jsonData);
        return orderResponse.newOrders;
      } else {
        throw Exception('Failed to load new orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching new orders: $e');
      throw Exception('Error fetching new orders: $e');
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/rider/updateorderstatus/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': status,
        }),
      );

      print('Update Order Status Response Status: ${response.statusCode}');
      print('Update Order Status Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  /// New API method for updating order status with pharmacy selection
  Future<bool> updateOrderStatusWithPharmacy({
    required String riderId,
    required String orderId,
    required String status,
    String? pharmacyId,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/rider/update-status/$riderId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'orderId': orderId,
          'newStatus': status,
          if (pharmacyId != null) 'pharmacyId': pharmacyId,
        }),
      );

      print('Update Order Status with Pharmacy Response Status: ${response.statusCode}');
      print('Update Order Status with Pharmacy Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating order status with pharmacy: $e');
      return false;
    }
  }
}