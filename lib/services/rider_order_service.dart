
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/rider_order_model.dart';
import '../models/update_status_request.dart';

class RiderOrderService {
  static const String baseUrl =
      'http://31.97.206.144:7021/api';

  /// ================= GET ACCEPTED ORDER =================

  Future<AcceptedOrder> getAcceptedOrder(
    String orderId,
    String riderId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rider/acceptedorders/$riderId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Get Order Status: ${response.statusCode}');
      print('Get Order Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        final riderOrderResponse =
            RiderOrderResponse.fromJson(jsonResponse);

        return riderOrderResponse.acceptedOrder;
      } else {
        throw Exception(
          'Failed to load order: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting order: $e');
      throw Exception('Failed to load order: $e');
    }
  }

  /// ================= UPDATE STATUS =================

Future<Map<String, dynamic>> updateOrderStatus({
  required String riderId,
  required UpdateStatusRequest request,
}) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/rider/update-status/$riderId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    print('Update Status Code: ${response.statusCode}');
    print('Update Status Body: ${response.body}');

    final Map<String, dynamic> body =
        json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': body['message'] ?? 'Server error',
      };
    } else {
      return {
        'success': false,
        'message': body['message'] ?? 'Server error',
      };
    }
  } catch (e) {
    print('Error updating status: $e');
    return {
      'success': false,
      'message': 'Network error. Please try again.',
    };
  }
}


  /// ================= UPLOAD PICKUP IMAGE =================

  Future<Map<String, dynamic>> uploadPickupImage({
    required String orderId,
    required String pharmacyId,
    required String imagePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseUrl/orders/$orderId/upload-pickup-proof'),
      );

      request.fields['pharmacyId'] = pharmacyId;

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ),
      );

      var response = await request.send();
      var responseData =
          await response.stream.bytesToString();

      print('Upload Status: ${response.statusCode}');
      print('Upload Body: $responseData');

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception(
          'Failed to upload image: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }
}
