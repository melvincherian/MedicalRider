import 'package:flutter/material.dart';
import 'package:medical_delivery_app/services/forgot_password_service.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final ForgotPasswordService _service = ForgotPasswordService();
  
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;
  
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get isSuccess => _isSuccess;
  
  void clearMessage() {
    _message = '';
    _isSuccess = false;
    notifyListeners();
  }
  
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _message = '';
    _isSuccess = false;
    notifyListeners();
    
    try {
      final result = await _service.resetPassword(
        email: email,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      
      _isSuccess = result['success'] ?? false;
      _message = result['message'] ?? '';
      
    } catch (e) {
      _isSuccess = false;
      _message = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}