// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:medical_delivery_app/constants/api_constant.dart';
// import 'package:medical_delivery_app/models/login_model.dart';

// class LoginService {
//   static Future<LoginResponse?> login(String phone, String password) async {
//     try {
//       final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.loginEndpoint}');
      
//       final payload = {
//         'phone': phone,
//         'password': password,
//       };

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(payload),
//       );

//       print('response statussssssssssssssssssssss ${response.statusCode}');
//       print('response bodyyyyyyyyyyyyyyyyyyyyy ${response.body}');


//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         return LoginResponse.fromJson(responseData);
//       } else {
//         throw Exception('Login failed with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Login error: $e');
//     }
//   }
// }











import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/login_model.dart';

class LoginService {
  static Future<LoginResponse?> login(
    BuildContext context,
    String phone,
    String password,
  ) async {
    try {
      final url =
          Uri.parse('${ApiConstant.baseUrl}${ApiConstant.loginEndpoint}');

      final payload = {
        'phone': phone,
        'password': password,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      print('response status: ${response.statusCode}');
      print('response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        final responseData = json.decode(response.body);

        // Extract message safely
        final message = responseData['message'] ?? 'Login failed';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }
}
