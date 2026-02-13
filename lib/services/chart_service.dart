// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:medical_delivery_app/constants/api_constant.dart';
// import 'package:medical_delivery_app/models/chart_model.dart';
// import 'package:medical_delivery_app/utils/helper_function.dart';

// class ChartService {
//   // Get chart data with filter
//   static Future<ChartResponse?> getChartData(String riderId, {String filter = 'thisWeek'}) async {
//     try {
//       final url = ApiConstant.getchartapi(riderId, filter: filter);
      
//       // Get token from shared preferences if needed
//       final token = await SharedPreferenceService.getToken();
      
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         return ChartResponse.fromJson(jsonData);
//       } else {
//         print('Failed to fetch chart data: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching chart data: $e');
//       return null;
//     }
//   }

//   // Get chart data for different time periods
//   static Future<ChartResponse?> getTodayChart(String riderId) async {
//     return await getChartData(riderId, filter: 'today');
//   }

//   static Future<ChartResponse?> getYesterdayChart(String riderId) async {
//     return await getChartData(riderId, filter: 'yesterday');
//   }

//   static Future<ChartResponse?> getThisWeekChart(String riderId) async {
//     return await getChartData(riderId, filter: 'thisWeek');
//   }

//    static Future<ChartResponse?> getlastweekChart(String riderId) async {
//     return await getChartData(riderId, filter: 'lastWeek ');
//   }

//   static Future<ChartResponse?> getThisMonthChart(String riderId) async {
//     return await getChartData(riderId, filter: 'thisMonth');
//   }

//   static Future<ChartResponse?> getCustomChart(String riderId, String customFilter) async {
//     return await getChartData(riderId, filter: customFilter);
//   }
// }

















import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_delivery_app/constants/api_constant.dart';
import 'package:medical_delivery_app/models/chart_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';

class ChartService {
  // Get chart data with filter
  static Future<ChartResponse?> getChartData(String riderId, {String filter = 'thisWeek'}) async {
    try {
      final url = ApiConstant.getchartapi(riderId, filter: filter);
      
      // Get token from shared preferences if needed
      final token = await SharedPreferenceService.getToken();
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );


      print('chart response status codeee${response.statusCode}');
            print('chart response bodyyyyy${response.body}');


      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChartResponse.fromJson(jsonData);
      } else {
        print('Failed to fetch chart data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching chart data: $e');
      return null;
    }
  }

  // Get chart data for different time periods
  static Future<ChartResponse?> getTodayChart(String riderId) async {
    return await getChartData(riderId, filter: 'today');
  }

  static Future<ChartResponse?> getYesterdayChart(String riderId) async {
    return await getChartData(riderId, filter: 'yesterday');
  }

  static Future<ChartResponse?> getThisWeekChart(String riderId) async {
    return await getChartData(riderId, filter: 'thisWeek');
  }

  static Future<ChartResponse?> getSixMonthsChart(String riderId) async {
    return await getChartData(riderId, filter: 'sixMonths');
  }

  static Future<ChartResponse?> getCustomChart(String riderId, String customFilter) async {
    return await getChartData(riderId, filter: customFilter);
  }

  // Dashboard-specific methods
  static Future<ChartResponse?> getChartForDashboardFilter(String riderId, String dashboardFilter) async {
    String apiFilter = _convertDashboardFilterToApiFilter(dashboardFilter);
    return await getChartData(riderId, filter: apiFilter);
  }

  static String _convertDashboardFilterToApiFilter(String dashboardFilter) {
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
}