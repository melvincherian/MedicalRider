import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/wallet_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class WalletService {
  static const Duration _timeout = Duration(seconds: 30);

  /// Fetches wallet data for the current rider
  static Future<WalletModel?> getWalletData() async {
    try {
      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id == null) {
        throw Exception('Rider data not found. Please login again.');
      }

      final String riderId = riderData.id!;
      final String url = ApiConstant.getwallet(riderId);

      // Get auth token if available
      final String? token = await SharedPreferenceService.getToken();

      // Prepare headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add authorization header if token exists
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('Fetching wallet data from: $url');

      // Make HTTP request
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(_timeout);

      print('Wallet API Response Status: ${response.statusCode}');
      print('Wallet API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return WalletModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Wallet data not found for this rider.');
      } else {
        throw Exception('Failed to load wallet data. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on http.ClientException {
      throw Exception('Network error occurred. Please try again.');
    } on FormatException {
      throw Exception('Invalid response format received.');
    } catch (e) {
      print('Error in getWalletData: $e');
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('An unexpected error occurred: ${e.toString()}');
      }
    }
  }

  /// Refreshes wallet data (same as getWalletData but can be extended for different behavior)
  static Future<WalletModel?> refreshWalletData() async {
    return await getWalletData();
  }

  /// Validates if rider is logged in and has valid data
  static Future<bool> isValidRider() async {
    try {
      final riderData = await SharedPreferenceService.getRiderData();
      final isLoggedIn = await SharedPreferenceService.getLoginStatus();
      
      return isLoggedIn && 
             riderData != null && 
             riderData.id != null && 
             riderData.id!.isNotEmpty;
    } catch (e) {
      print('Error checking rider validity: $e');
      return false;
    }
  }

  /// Gets rider ID from shared preferences
  static Future<String?> getCurrentRiderId() async {
    try {
      final riderData = await SharedPreferenceService.getRiderData();
      return riderData?.id;
    } catch (e) {
      print('Error getting rider ID: $e');
      return null;
    }
  }

  /// Mock data for testing (remove in production)
  static WalletModel getMockWalletData() {
    return WalletModel(
      wallet: '₹1250.00',
      totalEarningsMessage: 'Total Earnings from 10 Apr - 16 Apr: ₹1250.00',
    );
  }
}