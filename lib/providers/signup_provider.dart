
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/signup_model.dart';
import 'package:medical_delivery_app/services/signup_service.dart';

enum SignupState {
  initial,
  loading,
  success,
  error,
}

class SignupProvider extends ChangeNotifier {
  final SignupService _signupService = SignupService();
  
  SignupState _state = SignupState.initial;
  String? _errorMessage;
  SignupResponse? _signupResponse;
  bool _isLoading = false;

  // Getters
  SignupState get state => _state;
  String? get errorMessage => _errorMessage;
  SignupResponse? get signupResponse => _signupResponse;
  bool get isLoading => _isLoading;

  // Reset state
  void resetState() {
    _state = SignupState.initial;
    _errorMessage = null;
    _signupResponse = null;
    _isLoading = false;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    if (_state == SignupState.error) {
      _state = SignupState.initial;
    }
    notifyListeners();
  }

  // Signup method
  Future<bool> signupRider({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String drivingLicensePath,
    required String profileImage,
  }) async {
    try {
      _setLoading(true);
      _state = SignupState.loading;
      _errorMessage = null;
      notifyListeners();

      // Validate driving license file
      if (!_signupService.validateDrivingLicenseFile(drivingLicensePath)) {
        _setError('Invalid driving license file. Please select a valid image file (JPG, PNG) under 5MB.');
        return false;
      }

      final request = SignupRequest(
        name: name.trim(),
        email: email.trim().toLowerCase(),
        phone: phone.trim(),
        password: password,
        drivingLicensePath: drivingLicensePath,
        profileImage: profileImage
      );

      _signupResponse = await _signupService.signupRider(request);

      if (_signupResponse!.success) {
        _state = SignupState.success;
        _isLoading = false;
        _errorMessage = null; // Clear any previous errors
        notifyListeners();
        return true;
      } else {
        _setError(_signupResponse!.message ?? 'Signup failed');
        return false;
      }
    } catch (e) {
      print('Provider error: $e'); // Add debug print
      _setError('An unexpected error occurred. Please try again.');
      return false;
    }
  }

  // Validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email.trim());
  }

  // Validate phone format
  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phone.trim());
  }

  // Validate password strength
  bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // Validate name
  bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _state = SignupState.error;
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}