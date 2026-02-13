// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/dashboard_model.dart';
// import 'package:medical_delivery_app/services/dashboard_service.dart';

// class DashboardProvider extends ChangeNotifier {
//   DashboardResponse? _dashboardData;
//   bool _isLoading = false;
//   String? _errorMessage;

//   // Getters
//   DashboardResponse? get dashboardData => _dashboardData;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   // Order stats getters for easy access
//   int get todayOrders => _dashboardData?.orders.todayOrders ?? 0;
//   int get pendingOrders => _dashboardData?.orders.pending ?? 0;
//   int get cancelledOrders => _dashboardData?.orders.cancelled ?? 0;
//   int get completedOrders => _dashboardData?.orders.completed ?? 0;

//   // Earnings getters
//   double get totalEarnings => _dashboardData?.earnings.totalEarnings ?? 0.0;
//   Map<String, double> get earningsPerDay => _dashboardData?.earnings.earningsPerDay ?? {};
//   String get filterUsed => _dashboardData?.filterUsed ?? '';

//   /// Fetch dashboard data for current rider
//   Future<void> fetchDashboardData() async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await DashboardService.getCurrentRiderDashboard();
      
//       if (response != null) {
//         _dashboardData = response;
//         _clearError();
//       } else {
//         _setError('Failed to fetch dashboard data');
//       }
//     } catch (e) {
//       _setError('Error fetching dashboard data: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Fetch dashboard data for specific rider
//   Future<void> fetchDashboardDataForRider(String riderId) async {
//     _setLoading(true);
//     _clearError();

//     try {
//       final response = await DashboardService.getDashboardData(riderId);
      
//       if (response != null) {
//         _dashboardData = response;
//         _clearError();
//       } else {
//         _setError('Failed to fetch dashboard data for rider');
//       }
//     } catch (e) {
//       _setError('Error fetching dashboard data: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   /// Refresh dashboard data
//   Future<void> refreshDashboard() async {
//     await fetchDashboardData();
//   }

//   /// Clear dashboard data
//   void clearDashboard() {
//     _dashboardData = null;
//     _clearError();
//     notifyListeners();
//   }
  

//   /// Get earnings for a specific day
//   double getEarningsForDay(String day) {
//     return _dashboardData?.earnings.earningsPerDay[day] ?? 0.0;
//   }

//   /// Get total orders count
//   int get totalOrders {
//     if (_dashboardData == null) return 0;
//     return _dashboardData!.orders.pending + 
//            _dashboardData!.orders.completed + 
//            _dashboardData!.orders.cancelled;
//   }

//   /// Check if data is available
//   bool get hasData => _dashboardData != null;

//   // Private helper methods
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _errorMessage = error;
//     notifyListeners();
//   }

//   void _clearError() {
//     _errorMessage = null;
//   }
// }
















import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/dashboard_model.dart';
import 'package:medical_delivery_app/services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardResponse? _dashboardData;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentFilter = 'thisweek'; // Default filter

  // Getters
  DashboardResponse? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Order stats getters for easy access
  int get todayOrders => _dashboardData?.orders.todayOrders ?? 0;
  int get pendingOrders => _dashboardData?.orders.pending ?? 0;
  int get cancelledOrders => _dashboardData?.orders.cancelled ?? 0;
  int get completedOrders => _dashboardData?.orders.completed ?? 0;

  // Earnings getters
  double get totalEarnings => _dashboardData?.earnings.totalEarnings ?? 0.0;
  Map<String, double> get earningsPerDay => _dashboardData?.earnings.earningsPerDay ?? {};
  String get filterUsed => _dashboardData?.filterUsed ?? _currentFilter;

  /// Update filter and fetch new dashboard data
  Future<void> updateFilter(String filter) async {
    if (_currentFilter == filter) return; // No need to update if same filter
    
    _currentFilter = filter;
    await fetchDashboardDataWithFilter(filter);
  }

  /// Fetch dashboard data with specific filter
  Future<void> fetchDashboardDataWithFilter(String filter) async {
    _setLoading(true);
    _clearError();

    try {
      // If your DashboardService supports filter parameters, use this:
      // final response = await DashboardService.getCurrentRiderDashboardWithFilter(filter);
      
      // For now, we'll fetch regular data and update the filter
      final response = await DashboardService.getCurrentRiderDashboard();
      
      if (response != null) {
        _dashboardData = response;
        // Update the filter used in the response
        _dashboardData = DashboardResponse(
          orders: response.orders,
          earnings: response.earnings,
          filterUsed: filter,
          message: response.message
        );
        _clearError();
      } else {
        _setError('Failed to fetch dashboard data');
      }
    } catch (e) {
      _setError('Error fetching dashboard data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch dashboard data for current rider
  Future<void> fetchDashboardData() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await DashboardService.getCurrentRiderDashboard();
      
      if (response != null) {
        _dashboardData = response;
        _clearError();
      } else {
        _setError('Failed to fetch dashboard data');
      }
    } catch (e) {
      _setError('Error fetching dashboard data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch dashboard data for specific rider
  Future<void> fetchDashboardDataForRider(String riderId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await DashboardService.getDashboardData(riderId);
      
      if (response != null) {
        _dashboardData = response;
        _clearError();
      } else {
        _setError('Failed to fetch dashboard data for rider');
      }
    } catch (e) {
      _setError('Error fetching dashboard data: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await fetchDashboardDataWithFilter(_currentFilter);
  }

  /// Clear dashboard data
  void clearDashboard() {
    _dashboardData = null;
    _currentFilter = 'thisweek'; // Reset to default
    _clearError();
    notifyListeners();
  }
  
  /// Get current filter
  String get currentFilter => _currentFilter;

  /// Get earnings for a specific day
  double getEarningsForDay(String day) {
    return _dashboardData?.earnings.earningsPerDay[day] ?? 0.0;
  }

  /// Get total orders count
  int get totalOrders {
    if (_dashboardData == null) return 0;
    return _dashboardData!.orders.pending + 
           _dashboardData!.orders.completed + 
           _dashboardData!.orders.cancelled;
  }

  /// Check if data is available
  bool get hasData => _dashboardData != null;

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}