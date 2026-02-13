// add_bank_details_provider.dart
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/bank_details_model.dart';
import 'package:medical_delivery_app/services/add_bankdetails_service.dart';

class AddBankDetailsProvider extends ChangeNotifier {
  final AddBankDetailsService _service = AddBankDetailsService();
  
  bool _isLoading = false;
  String? _errorMessage;
  BankDetailsResponse? _bankDetailsResponse;
  List<BankDetailsModel> _bankDetailsList = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BankDetailsResponse? get bankDetailsResponse => _bankDetailsResponse;
  List<BankDetailsModel> get bankDetailsList => _bankDetailsList;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Add bank details
  Future<bool> addBankDetails({
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String bankName,
    required String upiId,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _service.addBankDetails(
        accountHolderName: accountHolderName,
        accountNumber: accountNumber,
        ifscCode: ifscCode,
        bankName: bankName,
        upiId: upiId,
      );

      if (response != null) {
        _bankDetailsResponse = response;
        _bankDetailsList = response.accountDetails;
        _setLoading(false);
        return true;
      } else {
        _setError('Failed to add bank details');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Get bank details
  Future<void> getBankDetails() async {
    try {
      _setLoading(true);
      _setError(null);

      final bankDetails = await _service.getBankDetails();
      if (bankDetails != null) {
        _bankDetailsList = bankDetails;
      }
      
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Validate form fields
  String? validateAccountHolderName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter account holder name';
    }
    if (value.trim().length < 3) {
      return 'Account holder name must be at least 3 characters';
    }
    return null;
  }

  String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter account number';
    }
    if (value.trim().length < 9 || value.trim().length > 18) {
      return 'Account number must be between 9-18 digits';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'Account number must contain only numbers';
    }
    return null;
  }

  String? validateIFSCCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter IFSC code';
    }
    // IFSC code format: 4 letters followed by 7 digits
    if (!RegExp(r'^[A-Z]{4}[0-9]{7}$').hasMatch(value.trim().toUpperCase())) {
      return 'Enter valid IFSC code (e.g., HDFC0001234)';
    }
    return null;
  }

  String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter bank name';
    }
    if (value.trim().length < 3) {
      return 'Bank name must be at least 3 characters';
    }
    return null;
  }

  String? validateUPIId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter UPI ID';
    }
    // Basic UPI ID validation
    if (!RegExp(r'^[\w.-]+@[a-zA-Z]+$').hasMatch(value.trim())) {
      return 'Enter valid UPI ID (e.g., user@upi)';
    }
    return null;
  }
}