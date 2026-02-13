
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:medical_delivery_app/models/signup_model.dart';

class SignupService {
  static const String baseUrl = 'http://31.97.206.144:7021/';
  static const String signupEndpoint = 'api/rider/signup';

  static String get signupUrl => '$baseUrl$signupEndpoint';

  Future<SignupResponse> signupRider(SignupRequest request) async {
    try {
      var uri = Uri.parse(signupUrl);
      var requestMultipart = http.MultipartRequest('POST', uri);

      // Add text fields
      requestMultipart.fields.addAll(request.toMap());

      // Add driving license file
      if (File(request.drivingLicensePath).existsSync()) {
        var file = await http.MultipartFile.fromPath(
          'drivingLicense',
          request.drivingLicensePath,
          contentType: MediaType('image', 'jpeg'),
        );
        requestMultipart.files.add(file);
      } else {
        return SignupResponse.error('Driving license file not found');
      }




       if (File(request.profileImage).existsSync()) {
        var file = await http.MultipartFile.fromPath(
          'profileImage',
          request.drivingLicensePath,
          contentType: MediaType('image', 'jpeg'),
        );
        requestMultipart.files.add(file);
      } else {
        return SignupResponse.error('Driving license file not found');
      }

      // Set headers
      requestMultipart.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      });

      // Send request
      var streamedResponse = await requestMultipart.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check for successful status codes (200 OR 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          var jsonResponse = json.decode(response.body);



          
          // Check if the response contains the expected success indicators
          if (jsonResponse['message'] != null && 
              (jsonResponse['message'].toString().toLowerCase().contains('success') ||
               jsonResponse['rider'] != null)) {
            return SignupResponse.fromJson(jsonResponse);
          } else {
            return SignupResponse.error(
              jsonResponse['message'] ?? 'Unknown error occurred'
            );
          }
        } catch (e) {
          print('JSON parsing error: $e');
          return SignupResponse.error('Invalid response format');
        }
      } else if (response.statusCode == 400) {
        var jsonResponse = json.decode(response.body);
        return SignupResponse.error(
          jsonResponse['message'] ?? 'Bad Request',
          error: jsonResponse['error'] ?? 'Validation failed',
        );
      } else if (response.statusCode == 409) {
        var jsonResponse = json.decode(response.body);
        return SignupResponse.error(
          jsonResponse['message'] ?? 'User already exists',
          error: 'Email or phone already registered',
        );
      } else {
        return SignupResponse.error(
          'Server error: ${response.statusCode}. Please try again.',
        );
      }
    } catch (e) {
      print('Signup error: $e');
      if (e is SocketException) {
        return SignupResponse.error(
          'No internet connection. Please check your network.',
        );
      } else if (e is FormatException) {
        return SignupResponse.error(
          'Invalid response from server. Please try again.',
        );
      } else {
        return SignupResponse.error(
          'Something went wrong. Please try again.',
        );
      }
    }
  }

  // Method to validate file before upload
  bool validateDrivingLicenseFile(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return false;
      }

      // Check file size (max 5MB)
      final fileSizeInBytes = file.lengthSync();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 5) {
        return false;
      }

      // Check file extension
      final allowedExtensions = ['.jpg', '.jpeg', '.png'];
      final fileExtension = filePath.toLowerCase().substring(filePath.lastIndexOf('.'));
      if (!allowedExtensions.contains(fileExtension)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}