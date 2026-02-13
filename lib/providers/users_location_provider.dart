

import 'package:flutter/foundation.dart';
import 'package:medical_delivery_app/services/location_fetch_service.dart';
import 'package:medical_delivery_app/services/location_service.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class LocationProvider extends ChangeNotifier {
  String _address = 'Fetching location...';
  List<double>? _coordinates;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Getters
  String get address => _address;
  List<double>? get coordinates => _coordinates;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasLocation => _coordinates != null && _coordinates!.length >= 2;

  // Initialize location (get current location) - Updated method signature
  Future<void> initLocation([String? userId]) async {
    try {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();

      // Get coordinates first
      final coords = await LocationFetchService.getCurrentCoordinates();
      if (coords == null) {
        throw Exception('Please on your location');
      }
      _coordinates = coords;

      // Get address
      final fullAddress = await LocationFetchService.getCurrentAddress();
      if (fullAddress == null) {
        throw Exception('Failed to get address');
      }

      // Check if address contains error messages
      if (fullAddress.contains('Location services are disabled') ||
          fullAddress.contains('Location permission denied') ||
          fullAddress.contains('permanently denied') ||
          fullAddress.contains('Address not found')) {
        throw Exception(fullAddress);
      }

      _address = _formatAddress(fullAddress);
      
      // Call addLocation API with user's coordinates using updated LocationService
      // The new LocationService.addLocation() only needs latitude and longitude
      final isSuccess = await LocationService().addLocation(
        _coordinates![0].toString(), // latitude
        _coordinates![1].toString()  // longitude
      );
      
      if (!isSuccess) {
        if (kDebugMode) {
          print('Warning: Failed to save location to server');
        }
        // Note: We don't throw an error here as the location was still fetched successfully
        // The API call failure shouldn't prevent the user from using the app
      }

      _isLoading = false;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      _address = 'Location not available';
      _coordinates = null;
      notifyListeners();
    }
  }

  // Update location manually (from search) - Updated method signature
  Future<void> updateLocation(String newAddress, List<double> newCoordinates, [String? userId]) async {
    _address = _formatAddress(newAddress);
    _coordinates = newCoordinates;
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    
    // Optionally update location on server when manually updating
    try {
      final isSuccess = await LocationService().addLocation(
        _coordinates![0].toString(), // latitude
        _coordinates![1].toString()  // longitude
      );
      
      if (!isSuccess && kDebugMode) {
        print('Warning: Failed to save updated location to server');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Error saving updated location: $e');
      }
    }
    
    notifyListeners();
  }

  // Format address to show only first 2 parts
  String _formatAddress(String fullAddress) {
    if (fullAddress.isEmpty) return 'Unknown location';
    
    final parts = fullAddress.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'Unknown location';
    
    return parts.length > 1 ? '${parts[0]}, ${parts[1]}' : parts[0];  
  }

  // Refresh current location - Updated to not require userId
  Future<void> refreshLocation() async {
    try {
      var rider = await SharedPreferenceService.getRiderData();
      print('🚴 Rider: $rider');
      print('🆔 Rider ID: ${rider?.id}');
      
      if (rider?.id != null) {
        // No need to pass userId since LocationService gets it from SharedPreferences
        await initLocation();
      } else {
        print('❌ Rider ID is null');
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'User not found. Please login again.';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to refresh location: ${e.toString()}';
      notifyListeners();
    }
  }

  // Alternative method if you want to ensure user is logged in before fetching location
  Future<void> initLocationWithLoginCheck() async {
    try {
      // Check if user is logged in first
      bool isLoggedIn = await SharedPreferenceService.getLoginStatus();
      if (!isLoggedIn) {
        throw Exception('User is not logged in');
      }

      await initLocation();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString();
      _address = 'Location not available';
      _coordinates = null;
      notifyListeners();
    }
  }

  // Method to update location only if user is logged in
  Future<void> updateLocationIfLoggedIn(String newAddress, List<double> newCoordinates) async {
    try {
      bool isLoggedIn = await SharedPreferenceService.getLoginStatus();
      if (!isLoggedIn) {
        if (kDebugMode) {
          print('Warning: User not logged in, location not saved to server');
        }
        // Still update local location
        _address = _formatAddress(newAddress);
        _coordinates = newCoordinates;
        _isLoading = false;
        _hasError = false;
        _errorMessage = '';
        notifyListeners();
        return;
      }

      await updateLocation(newAddress, newCoordinates);
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateLocationIfLoggedIn: $e');
      }
      // Still update local location even if server update fails
      _address = _formatAddress(newAddress);
      _coordinates = newCoordinates;
      _isLoading = false;
      _hasError = false;
      _errorMessage = '';
      notifyListeners();
    }
  }

  // Reset location state
  void resetLocation() {
    _address = 'Fetching location...';
    _coordinates = null;
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  // Debug method to check current state
  void debugLocationState() {
    if (kDebugMode) {
      print('🔍 LocationProvider State:');
      print('   Address: $_address');
      print('   Coordinates: $_coordinates');
      print('   Is Loading: $_isLoading');
      print('   Has Error: $_hasError');
      print('   Error Message: $_errorMessage');
      print('   Has Location: $hasLocation');
    }
  }
}