import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:medical_delivery_app/constants/api_constant.dart';

import 'package:medical_delivery_app/utils/helper_function.dart';

class UserLocationService {
  
  /// Check and request location permissions
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable location services.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }
    
    return true;
  }

  /// Get current location
  static Future<Position> getCurrentLocation() async {
    try {
      await handleLocationPermission();
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  /// Update location on server
  static Future<Map<String, dynamic>> updateLocationOnServer(
    double latitude, 
    double longitude
  ) async {
    try {
      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id == null) {
        throw Exception('Rider data not found. Please login again.');
      }

      final url = ApiConstant.getuserlocation(riderData.id!);
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update location: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating location: $e');
    }
  }

  /// Get current location and update on server
  static Future<Map<String, dynamic>> getCurrentLocationAndUpdate() async {
    try {
      final position = await getCurrentLocation();
      return await updateLocationOnServer(
        position.latitude, 
        position.longitude
      );
    } catch (e) {
      throw Exception('Failed to get and update location: $e');
    }
  }

  /// Start location tracking (continuous updates)
  static Stream<Position> getPositionStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );
    
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Calculate distance between two points
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}