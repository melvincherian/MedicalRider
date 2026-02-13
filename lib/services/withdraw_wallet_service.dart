// services/withdraw_wallet_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/withdraw_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class WithdrawWalletService {
  static const Duration _timeoutDuration = Duration(seconds: 30);

  // Submit withdrawal request
  static Future<WithdrawResponse> withdrawAmount({
    required double amount,
    required String bankId,
  }) async {
    try {
      // Get rider data from shared preferences
      final rider = await SharedPreferenceService.getRiderData();
      if (rider == null) {
        throw Exception('Rider data not found. Please login again.');
      }

      final riderId = rider.id;
      final url = ApiConstant.withdrawwallet(riderId);
      
      final withdrawRequest = WithdrawRequest(
        amount: amount,
        bankId: bankId,
      );

      print('Withdraw API URL: $url');
      print('Withdraw payload: ${json.encode(withdrawRequest.toJson())}');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(withdrawRequest.toJson()),
          )
          .timeout(_timeoutDuration);

      print('Withdraw API Response Status: ${response.statusCode}');
      print('Withdraw API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return WithdrawResponse.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to process withdrawal');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Network error occurred. Please try again.');
    } on FormatException {
      throw Exception('Invalid response format received.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please try again.');
      }
      throw Exception('Withdrawal failed: ${e.toString()}');
    }
  }

  // Get withdrawal history (if API is available)
  // static Future<List<WithdrawHistory>> getWithdrawHistory() async {
  //   try {
  //     final rider = await SharedPreferenceService.getRiderData();
  //     if (rider == null) {
  //       throw Exception('Rider data not found. Please login again.');
  //     }

  //     final riderId = rider.id;
  //     // Assuming there's a withdraw history endpoint
  //     final url = '${ApiConstant.baseUrl}api/rider/withdraw-history/$riderId';
      
  //     print('Withdraw History API URL: $url');

  //     final response = await http
  //         .get(
  //           Uri.parse(url),
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Accept': 'application/json',
  //           },
  //         )
  //         .timeout(_timeoutDuration);

  //     print('Withdraw History API Response Status: ${response.statusCode}');
  //     print('Withdraw History API Response Body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       final List<dynamic> historyList = responseData['data'] ?? [];
        
  //       return historyList
  //           .map((item) => WithdrawHistory.fromJson(item))
  //           .toList();
  //     } else {
  //       final errorData = json.decode(response.body);
  //       throw Exception(errorData['message'] ?? 'Failed to load withdrawal history');
  //     }
  //   } on SocketException {
  //     throw Exception('No internet connection. Please check your network.');
  //   } on HttpException {
  //     throw Exception('Network error occurred. Please try again.');
  //   } on FormatException {
  //     throw Exception('Invalid response format received.');
  //   } catch (e) {
  //     if (e.toString().contains('TimeoutException')) {
  //       throw Exception('Request timeout. Please try again.');
  //     }
  //     throw Exception('Failed to load withdrawal history: ${e.toString()}');
  //   }
  // }

  // Check withdrawal status (if API is available)
  static Future<Map<String, dynamic>> checkWithdrawStatus(String requestId) async {
    try {
      final rider = await SharedPreferenceService.getRiderData();
      if (rider == null) {
        throw Exception('Rider data not found. Please login again.');
      }

      final riderId = rider.id;
      final url = '${ApiConstant.baseUrl}api/rider/withdraw-status/$riderId/$requestId';
      
      print('Withdraw Status API URL: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeoutDuration);

      print('Withdraw Status API Response Status: ${response.statusCode}');
      print('Withdraw Status API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to check withdrawal status');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Network error occurred. Please try again.');
    } on FormatException {
      throw Exception('Invalid response format received.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please try again.');
      }
      throw Exception('Failed to check withdrawal status: ${e.toString()}');
    }
  }
}