import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/wallet_model.dart';
import 'package:medical_delivery_app/services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  WalletModel? _walletData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;

  // Getters
  WalletModel? get walletData => _walletData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  bool get hasData => _walletData != null;
  bool get hasError => _errorMessage != null;

  // Computed values for easy access
  String get walletBalance => _walletData?.wallet ?? '₹0.00';
  String get totalEarnings => _walletData?.totalEarningsAmount ?? '₹0.00';
  String get earningsDateRange => _walletData?.earningsDateRange ?? '';
  double get walletAmount => _walletData?.walletAmount ?? 0.0;

  /// Fetches wallet data from the API
  Future<void> fetchWalletData({bool showLoading = true}) async {
    try {
      if (showLoading) {
        _setLoading(true);
      }
      _clearError();

      // Check if rider is valid before making API call
      final isValid = await WalletService.isValidRider();
      if (!isValid) {
        throw Exception('Invalid rider session. Please login again.');
      }

      final walletData = await WalletService.getWalletData();
      
      if (walletData != null) {
        _walletData = walletData;
        _lastUpdated = DateTime.now();
        print('Wallet data loaded successfully: ${_walletData.toString()}');
      } else {
        throw Exception('No wallet data received from server.');
      }

    } catch (e) {
      _setError(e.toString());
      print('Error in fetchWalletData: $e');
    } finally {
      if (showLoading) {
        _setLoading(false);
      }
    }
  }

  /// Refreshes wallet data (pulls latest from server)
  Future<void> refreshWalletData() async {
    await fetchWalletData(showLoading: false);
  }

  /// Clears all wallet data (useful for logout)
  void clearWalletData() {
    _walletData = null;
    _errorMessage = null;
    _lastUpdated = null;
    notifyListeners();
  }

  /// Retry loading wallet data after error
  Future<void> retryLoadWalletData() async {
    await fetchWalletData();
  }

  /// Check if data needs refresh (older than 5 minutes)
  bool shouldRefreshData() {
    if (_lastUpdated == null) return true;
    final difference = DateTime.now().difference(_lastUpdated!);
    return difference.inMinutes > 5;
  }

  /// Auto-refresh if data is stale
  Future<void> autoRefreshIfNeeded() async {
    if (shouldRefreshData()) {
      await refreshWalletData();
    }
  }

  /// Load wallet data with cache check
  Future<void> loadWalletData() async {
    if (_walletData == null || shouldRefreshData()) {
      await fetchWalletData();
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Get customer tips amount (assuming it's a percentage or fixed amount from wallet)
  String get customerTips {
    // This is a placeholder calculation - adjust based on your business logic
    if (_walletData != null) {
      double tipsAmount = walletAmount * 0.1; // 10% of wallet as tips example
      return '₹${tipsAmount.toStringAsFixed(2)}';
    }
    return '₹0.00';
  }

  /// Check if wallet has sufficient balance for withdrawal
  bool canWithdraw({double minimumAmount = 100.0}) {
    return walletAmount >= minimumAmount;
  }

  /// Get formatted last updated time
  String get lastUpdatedFormatted {
    if (_lastUpdated == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
  }
}