// providers/withdraw_wallet_provider.dart

import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/withdraw_model.dart';
import 'package:medical_delivery_app/services/withdraw_wallet_service.dart';

class WithdrawWalletProvider extends ChangeNotifier {
  // Loading states
  bool _isWithdrawing = false;
  bool _isLoadingHistory = false;

  // Data
  WithdrawResponse? _lastWithdrawResponse;
  List<WithdrawHistory> _withdrawHistory = [];
  
  // Error handling
  String? _errorMessage;
  String? _successMessage;

  // Getters
  bool get isWithdrawing => _isWithdrawing;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get hasError => _errorMessage != null;
  bool get hasSuccess => _successMessage != null;
  
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  WithdrawResponse? get lastWithdrawResponse => _lastWithdrawResponse;
  List<WithdrawHistory> get withdrawHistory => _withdrawHistory;

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  // Submit withdrawal request
  Future<bool> submitWithdrawal({
    required double amount,
    required String bankId,
  }) async {
    try {
      _isWithdrawing = true;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();

      // Validate amount
      if (amount <= 0) {
        throw Exception('Please enter a valid amount');
      }

      // if (amount < 100) {
      //   throw Exception('Minimum withdrawal amount is ₹100');
      // }

      // Validate bank ID
      if (bankId.isEmpty) {
        throw Exception('Please select a bank account');
      }

      // Call API
      final response = await WithdrawWalletService.withdrawAmount(
        amount: amount,
        bankId: bankId,
      );

      _lastWithdrawResponse = response;
      _successMessage = response.message;
      
      // Refresh withdrawal history after successful withdrawal
      // await loadWithdrawHistory();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isWithdrawing = false;
      notifyListeners();
    }
  }

  // Load withdrawal history
  // Future<void> loadWithdrawHistory() async {
  //   try {
  //     _isLoadingHistory = true;
  //     _errorMessage = null;
  //     notifyListeners();

  //     final history = await WithdrawWalletService.getWithdrawHistory();
  //     _withdrawHistory = history;
  //   } catch (e) {
  //     _errorMessage = e.toString().replaceFirst('Exception: ', '');
  //     _withdrawHistory = [];
  //   } finally {
  //     _isLoadingHistory = false;
  //     notifyListeners();
  //   }
  // }

  // Retry loading withdrawal history
  // Future<void> retryLoadHistory() async {
  //   await loadWithdrawHistory();
  // }

  // Check specific withdrawal status
  Future<Map<String, dynamic>?> checkWithdrawalStatus(String requestId) async {
    try {
      _errorMessage = null;
      notifyListeners();

      if (requestId.isEmpty) {
        throw Exception('Invalid request ID');
      }

      final status = await WithdrawWalletService.checkWithdrawStatus(requestId);
      return status;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  // Get withdrawal history by status
  List<WithdrawHistory> getHistoryByStatus(String status) {
    return _withdrawHistory
        .where((item) => item.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get pending withdrawals
  List<WithdrawHistory> get pendingWithdrawals {
    return getHistoryByStatus('requested');
  }

  // Get completed withdrawals
  List<WithdrawHistory> get completedWithdrawals {
    return getHistoryByStatus('completed');
  }

  // Get rejected withdrawals
  List<WithdrawHistory> get rejectedWithdrawals {
    return getHistoryByStatus('rejected');
  }

  // Calculate total pending amount
  double get totalPendingAmount {
    return pendingWithdrawals.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
  }

  // Calculate total completed amount
  double get totalCompletedAmount {
    return completedWithdrawals.fold<double>(
      0.0,
      (sum, item) => sum + item.amount,
    );
  }

  // Reset provider state
  void reset() {
    _isWithdrawing = false;
    _isLoadingHistory = false;
    _lastWithdrawResponse = null;
    _withdrawHistory = [];
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
  }
}