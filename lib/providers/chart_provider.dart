// // // ignore_for_file: unnecessary_null_comparison

// // import 'package:flutter/material.dart';
// // import 'package:medical_delivery_app/models/chart_model.dart';
// // import 'package:medical_delivery_app/services/chart_service.dart';
// // import 'package:medical_delivery_app/utils/helper_function.dart';

// // class ChartProvider extends ChangeNotifier {
// //   ChartResponse? _chartData;
// //   bool _isLoading = false;
// //   String _error = '';
// //   String _currentFilter = 'thisWeek';

// //   // Getters
// //   ChartResponse? get chartData => _chartData;
// //   bool get isLoading => _isLoading;
// //   String get error => _error;
// //   String get currentFilter => _currentFilter;
  
// //   double get totalEarnings => _chartData?.totalEarnings ?? 0.0;
// //   double get walletBalance => _chartData?.walletBalance ?? 0.0;
// //   List<ChartData> get chartDataPoints => _chartData?.chartData ?? [];

// //   // Set loading state
// //   void _setLoading(bool loading) {
// //     _isLoading = loading;
// //     notifyListeners();
// //   }

// //   // Set error message
// //   void _setError(String error) {
// //     _error = error;
// //     notifyListeners();
// //   }

// //   // Clear error
// //   void clearError() {
// //     _error = '';
// //     notifyListeners();
// //   }

// //   // Fetch chart data
// //   Future<void> fetchChartData({String filter = 'thisWeek'}) async {
// //     try {
// //       _setLoading(true);
// //       _setError('');

// //       // Get rider data from shared preferences
// //       final riderData = await SharedPreferenceService.getRiderData();
// //       if (riderData == null || riderData.id == null) {
// //         _setError('Rider data not found. Please login again.');
// //         return;
// //       }

// //       final response = await ChartService.getChartData(
// //         riderData.id,
// //         filter: filter,
// //       );

// //       if (response != null) {
// //         _chartData = response;
// //         _currentFilter = filter;
// //         _setError('');
// //       } else {
// //         _setError('Failed to fetch chart data. Please try again.');
// //       }
// //     } catch (e) {
// //       _setError('An error occurred: ${e.toString()}');
// //     } finally {
// //       _setLoading(false);
// //     }
// //   }

// //   // Fetch data for specific time periods
// //   Future<void> fetchTodayChart() async {
// //     await fetchChartData(filter: 'today');
// //   }

// //   Future<void> fetchYesterdayChart() async {
// //     await fetchChartData(filter: 'yesterday');
// //   }

// //   Future<void> fetchThisWeekChart() async {
// //     await fetchChartData(filter: 'thisWeek');
// //   }

// //   Future<void> fetchThisMonthChart() async {
// //     await fetchChartData(filter: 'thisMonth');
// //   }

// //   // Refresh current data
// //   Future<void> refreshData() async {
// //     await fetchChartData(filter: _currentFilter);
// //   }

// //   // Reset provider state
// //   void reset() {
// //     _chartData = null;
// //     _isLoading = false;
// //     _error = '';
// //     _currentFilter = 'thisWeek';
// //     notifyListeners();
// //   }

// //   // Check if data is available
// //   bool get hasData => _chartData != null;
// //   bool get hasChartData => _chartData?.chartData.isNotEmpty ?? false;

// //   // Get formatted earnings
// //   String get formattedTotalEarnings {
// //     return '\$${totalEarnings.toStringAsFixed(2)}';
// //   }

// //   String get formattedWalletBalance {
// //     return '\$${walletBalance.toStringAsFixed(2)}';
// //   }
// // }















// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/chart_model.dart';
// import 'package:medical_delivery_app/services/chart_service.dart';
// import 'package:medical_delivery_app/models/login_model.dart';
// import 'package:medical_delivery_app/utils/helper_function.dart';

// class ChartProvider extends ChangeNotifier {
//   ChartResponse? _chartData;
//   bool _isLoading = false;
//   String _error = '';
//   String _currentFilter = 'thisWeek';

//   // Getters
//   ChartResponse? get chartData => _chartData;
//   bool get isLoading => _isLoading;
//   String get error => _error;
//   String get currentFilter => _currentFilter;
  
//   double get totalEarnings => _chartData?.totalEarnings ?? 0.0;
//   double get walletBalance => _chartData?.walletBalance ?? 0.0;
//   List<ChartData> get chartDataPoints => _chartData?.chartData ?? [];

//   // Set loading state
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   // Set error message
//   void _setError(String error) {
//     _error = error;
//     notifyListeners();
//   }

//   // Clear error
//   void clearError() {
//     _error = '';
//     notifyListeners();
//   }

//   // Fetch chart data
//   Future<void> fetchChartData({String filter = 'thisWeek'}) async {
//     try {
//       _setLoading(true);
//       _setError('');

//       // Get rider data from shared preferences
//       final riderData = await SharedPreferenceService.getRiderData();
//       if (riderData == null || riderData.id == null) {
//         _setError('Rider data not found. Please login again.');
//         return;
//       }

//       final response = await ChartService.getChartData(
//         riderData.id,
//         filter: filter,
//       );

//       if (response != null) {
//         _chartData = response;
//         _currentFilter = filter;
//         _setError('');
//       } else {
//         _setError('Failed to fetch chart data. Please try again.');
//       }
//     } catch (e) {
//       _setError('An error occurred: ${e.toString()}');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Fetch chart data for dashboard filters
//   Future<void> fetchChartDataForDashboard(String dashboardFilter) async {
//     String chartFilter = _convertDashboardFilterToChartFilter(dashboardFilter);
//     await fetchChartData(filter: chartFilter);
//   }

//   // Convert dashboard filter format to chart API filter format
//   String _convertDashboardFilterToChartFilter(String dashboardFilter) {
//     switch (dashboardFilter.toLowerCase()) {
//       case 'today':
//         return 'today';
//       case 'thisweek':
//         return 'thisWeek';
//       case 'thismonth':
//         return 'thisMonth';
//       case '6months':
//         return 'sixMonths'; // You might need to add this to your API
//       default:
//         return 'thisWeek';
//     }
//   }

//   // Fetch data for specific time periods (dashboard compatible)
//   Future<void> fetchTodayChart() async {
//     await fetchChartData(filter: 'today');
//   }

//   Future<void> fetchThisWeekChart() async {
//     await fetchChartData(filter: 'thisWeek');
//   }

//   Future<void> fetchThisMonthChart() async {
//     await fetchChartData(filter: 'thisMonth');
//   }

//   Future<void> fetchSixMonthsChart() async {
//     await fetchChartData(filter: 'sixMonths');
//   }

//   // Refresh current data
//   Future<void> refreshData() async {
//     await fetchChartData(filter: _currentFilter);
//   }

//   // Reset provider state
//   void reset() {
//     _chartData = null;
//     _isLoading = false;
//     _error = '';
//     _currentFilter = 'thisWeek';
//     notifyListeners();
//   }

//   // Check if data is available
//   bool get hasData => _chartData != null;
//   bool get hasChartData => _chartData?.chartData.isNotEmpty ?? false;

//   // Get formatted earnings
//   String get formattedTotalEarnings {
//     return '\$${totalEarnings.toStringAsFixed(2)}';
//   }

//   String get formattedWalletBalance {
//     return '\$${walletBalance.toStringAsFixed(2)}';
//   }
// }














import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/chart_model.dart';
import 'package:medical_delivery_app/services/chart_service.dart';
import 'package:medical_delivery_app/models/login_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class ChartProvider extends ChangeNotifier {
  ChartResponse? _chartData;
  bool _isLoading = false;
  String _error = '';
  String _currentFilter = 'thisWeek';

  // Getters
  ChartResponse? get chartData => _chartData;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get currentFilter => _currentFilter;
  
  double get totalEarnings => _chartData?.totalEarnings ?? 0.0;
  double get walletBalance => _chartData?.walletBalance ?? 0.0;
  List<ChartData> get chartDataPoints => _chartData?.chartData ?? [];

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Fetch chart data
  Future<void> fetchChartData({String filter = 'thisWeek'}) async {
    try {
      _setLoading(true);
      _setError('');

      // Get rider data from shared preferences
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null || riderData.id == null) {
        _setError('Rider data not found. Please login again.');
        return;
      }

      final response = await ChartService.getChartData(
        riderData.id,
        filter: filter,
      );

      if (response != null) {
        _chartData = response;
        _currentFilter = filter;
        _setError('');
      } else {
        _setError('Failed to fetch chart data. Please try again.');
      }
    } catch (e) {
      _setError('An error occurred: ${e.toString()}');
      print('ChartProvider Error: $e'); // For debugging
    } finally {
      _setLoading(false);
    }
  }

  // For testing with mock data (remove in production)
  void setMockData() {
    _chartData = ChartResponse.fromJson({
      "rider": "manoj1",
      "filter": "today",
      "totalEarnings": 2500,
      "walletBalance": 2600,
      "chartData": [
        {"day": "15 Sep", "earnings": 2500}
      ]
    });
    _currentFilter = 'today';
    notifyListeners();
  }

  // Fetch chart data for dashboard filters
  Future<void> fetchChartDataForDashboard(String dashboardFilter) async {
    String chartFilter = _convertDashboardFilterToChartFilter(dashboardFilter);
    await fetchChartData(filter: chartFilter);
  }

  // Convert dashboard filter format to chart API filter format
  String _convertDashboardFilterToChartFilter(String dashboardFilter) {
    switch (dashboardFilter.toLowerCase()) {
      case 'today':
        return 'today';
      case 'thisweek':
        return 'thisWeek';
      case 'thismonth':
        return 'thisMonth';
      case '6months':
        return 'sixMonths';
      default:
        return 'thisWeek';
    }
  }

  // Fetch data for specific time periods
  Future<void> fetchTodayChart() async {
    await fetchChartData(filter: 'today');
  }

  Future<void> fetchYesterdayChart() async {
    await fetchChartData(filter: 'yesterday');
  }

  Future<void> fetchThisWeekChart() async {
    await fetchChartData(filter: 'thisWeek');
  }

  Future<void> fetchThisMonthChart() async {
    await fetchChartData(filter: 'thisMonth');
  }

  Future<void> fetchSixMonthsChart() async {
    await fetchChartData(filter: 'sixMonths');
  }

  // Refresh current data
  Future<void> refreshData() async {
    await fetchChartData(filter: _currentFilter);
  }

  // Reset provider state
  void reset() {
    _chartData = null;
    _isLoading = false;
    _error = '';
    _currentFilter = 'thisWeek';
    notifyListeners();
  }

  // Check if data is available
  bool get hasData => _chartData != null;
  bool get hasChartData => _chartData?.chartData.isNotEmpty ?? false;

  // Get formatted earnings
  String get formattedTotalEarnings {
    return '₹${totalEarnings.toStringAsFixed(0)}';
  }

  String get formattedWalletBalance {
    return '₹${walletBalance.toStringAsFixed(0)}';
  }

  // Get earnings for a specific day/period
  double getEarningsForPeriod(String period) {
    final data = chartDataPoints.firstWhere(
      (item) => item.day == period || item.label == period,
      orElse: () => ChartData(),
    );
    return data.chartValue;
  }
}