// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:medical_delivery_app/models/pending_accepted_order_model.dart';

// class PendingAcceptedOrderService {
//   static const String baseUrl = 'http://31.97.206.144:7021/api';

//   Future<PendingAcceptedOrderResponse> fetchPendingAcceptedOrders(
//       String riderId) async {
//     try {
//       final url = Uri.parse('$baseUrl/rider/pendingacceptedorders/$riderId');
//       print('Fetching pending accepted orders from: $url');

//       final response = await http.get(url);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         return PendingAcceptedOrderResponse.fromJson(jsonData);
//       } else {
//         throw Exception('Failed to load orders: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching pending accepted orders: $e');
//       throw Exception('Error fetching orders: $e');
//     }
//   }

// // Update the acceptOrderWithPharmacy method in your service
// Future<Map<String, dynamic>> acceptOrderWithPharmacy({
//   required String riderId,
//   required String orderId,
//   required String pharmacyId,
// }) async {
//   try {
//     final url = Uri.parse('$baseUrl/rider/accept-order-with-pharmacy');
//     print('Accepting order with pharmacy: $url');
    
//     final requestBody = {
//       'riderId': riderId,
//       'orderId': orderId,
//       'pharmacyId': pharmacyId,
//       'status': 'Accepted'
//     };
    
//     print('Request body: ${json.encode(requestBody)}');

//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(requestBody),
//     );

//     print('Accept order response status: ${response.statusCode}');
//     print('Accept order response body: ${response.body}');

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to accept order: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error accepting order: $e');
//     throw Exception('Error accepting order: $e');
//   }
// }
//   Future<Map<String, dynamic>> updateOrderStatus({
//     required String riderId,
//     required String orderId,
//     required String status,
//     String? pharmacyId,
//   }) async {
//     try {
//       final url = Uri.parse('$baseUrl/rider/update-order-status');
//       print('Updating order status: $url');

//       final Map<String, dynamic> body = {
//         'riderId': riderId,
//         'orderId': orderId,
//         'status': status,
//       };

//       if (pharmacyId != null) {
//         body['pharmacyId'] = pharmacyId;
//       }

//       print('Request body: ${json.encode(body)}');

//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );

//       print('Update order status response: ${response.statusCode}');
//       print('Update order status body: ${response.body}');

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to update order status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating order status: $e');
//       throw Exception('Error updating order status: $e');
//     }
//   }
// }













import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/models/pending_accepted_order_model.dart';

class PendingAcceptedOrderService {
  static const String baseUrl = 'http://31.97.206.144:7021/api';

  Future<PendingAcceptedOrderResponse> fetchPendingAcceptedOrders(
      String riderId) async {
    try {
      final url = Uri.parse('$baseUrl/rider/pendingacceptedorders/$riderId');
      print('Fetching pending accepted orders from: $url');

      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PendingAcceptedOrderResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pending accepted orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<Map<String, dynamic>> acceptOrderWithPharmacy({
    required String riderId,
    required String orderId,
    required String pharmacyId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/rider/updateorderstatus/$orderId');
      print('Accepting order with pharmacy: $url');
      


      final response = await http.put(
        Uri.parse('$baseUrl/rider/update-status/$riderId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'newStatus': "Accepted",
           "orderId":orderId,
           "pharmacyId":pharmacyId
        }),
      );

      print('Accept order response status: ${response.statusCode}');
      print('Accept order response body: ${response.body}');

      if (response.statusCode == 200) {
                final jsonData = json.decode(response.body);

        return {
          "success":true,
          "message":jsonData['message']
        };
      } else {
        throw Exception('Failed to accept order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error accepting order: $e');
      throw Exception('Error accepting order: $e');
    }
  }
}