import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/models/login_model.dart';
import 'package:medical_delivery_app/constants/api_constant.dart';

class ProfileService {
  static Future<RiderModel?> getProfile(String riderId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstant.profileapi(riderId)),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RiderModel.fromJson(jsonData['rider']);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // Update profile image
  static Future<bool> updateProfileImage(String riderId, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiConstant.updateprofile(riderId)),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'profileImage',
          imageFile.path,
        ),
      );

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      final response = await request.send();


      print('response status codeeeeeeeeeeeeeeeeeeeeeee ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update profile image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile image: $e');
    }
  }

  // Update profile data (assuming there's an endpoint for updating profile details)
  static Future<bool> updateProfile(String riderId, Map<String, dynamic> profileData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConstant.updateprofile(riderId)),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}