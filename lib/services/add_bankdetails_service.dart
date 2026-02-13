// add_bank_details_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/bank_details_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class AddBankDetailsService {
  
  Future<BankDetailsResponse?> addBankDetails({
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String bankName,
    required String upiId,
  }) async {
    try {
      // Get rider data from SharedPreferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null) {
        throw Exception('Rider data not found. Please login again.');
      }

      // Prepare the payload
      final payload = {
        'accountHolderName': accountHolderName,
        'accountNumber': accountNumber,
        'ifscCode': ifscCode,
        'bankName': bankName,
        'upiId': upiId,
      };

      // Make API call
      final url = ApiConstant.addbankaccount(riderData.id);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

     
     print('response status codeeeeeeeeeeeeeeeeeeeeeeeeee ${response.statusCode}');
          print('response bodyyyyyyyyyyyyyyyyyyy ${response.body}');



      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return BankDetailsResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to add bank details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in AddBankDetailsService.addBankDetails: $e');
      rethrow;
    }
  }

  Future<List<BankDetailsModel>?> getBankDetails() async {
    try {
      // Get rider data from SharedPreferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null) {
        throw Exception('Rider data not found. Please login again.');
      }

      // Make API call to get bank details (you may need to create this endpoint)
      final url = ApiConstant.getbankdetails(riderData.id);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final bankResponse = BankDetailsResponse.fromJson(responseData);
        return bankResponse.accountDetails;
      } else {
        throw Exception('Failed to get bank details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in AddBankDetailsService.getBankDetails: $e');
      return null;
    }
  }
}