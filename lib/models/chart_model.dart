// // class ChartResponse {
// //   final String rider;
// //   final String filter;
// //   final double totalEarnings;
// //   final double walletBalance;
// //   final List<ChartData> chartData;

// //   ChartResponse({
// //     required this.rider,
// //     required this.filter,
// //     required this.totalEarnings,
// //     required this.walletBalance,
// //     required this.chartData,
// //   });

// //   factory ChartResponse.fromJson(Map<String, dynamic> json) {
// //     return ChartResponse(
// //       rider: json['rider'] ?? '',
// //       filter: json['filter'] ?? '',
// //       totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
// //       walletBalance: (json['walletBalance'] ?? 0).toDouble(),
// //       chartData: (json['chartData'] as List<dynamic>?)
// //           ?.map((item) => ChartData.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'rider': rider,
// //       'filter': filter,
// //       'totalEarnings': totalEarnings,
// //       'walletBalance': walletBalance,
// //       'chartData': chartData.map((item) => item.toJson()).toList(),
// //     };
// //   }
// // }

// // class ChartData {
// //   final String? label;
// //   final double? value;
// //   final String? date;
// //   final String? time;

// //   ChartData({
// //     this.label,
// //     this.value,
// //     this.date,
// //     this.time,
// //   });

// //   factory ChartData.fromJson(Map<String, dynamic> json) {
// //     return ChartData(
// //       label: json['label'],
// //       value: (json['value'] ?? 0).toDouble(),
// //       date: json['date'],
// //       time: json['time'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'label': label,
// //       'value': value,
// //       'date': date,
// //       'time': time,
// //     };
// //   }
// // }













// // chart_model.dart
// class ChartResponse {
//   final String? rider;
//   final String? filter;
//   final double? totalEarnings;
//   final double? walletBalance;
//   final List<ChartData> chartData;

//   ChartResponse({
//     this.rider,
//     this.filter,
//     this.totalEarnings,
//     this.walletBalance,
//     required this.chartData,
//   });

//   factory ChartResponse.fromJson(Map<String, dynamic> json) {
//     return ChartResponse(
//       rider: json['rider'],
//       filter: json['filter'],
//       totalEarnings: (json['totalEarnings'] as num?)?.toDouble(),
//       walletBalance: (json['walletBalance'] as num?)?.toDouble(),
//       chartData: (json['chartData'] as List<dynamic>?)
//           ?.map((item) => ChartData.fromJson(item as Map<String, dynamic>))
//           .toList() ?? [],
//     );
//   }
// }

// class ChartData {
//   final String? day;
//   final String? date;
//   final String? time;
//   final String? label;
//   final double? earnings;
//   final double? value;

//   ChartData({
//     this.day,
//     this.date,
//     this.time,
//     this.label,
//     this.earnings,
//     this.value,
//   });

//   factory ChartData.fromJson(Map<String, dynamic> json) {
//     return ChartData(
//       day: json['day'],
//       date: json['date'],
//       time: json['time'],
//       label: json['label'],
//       earnings: (json['earnings'] as num?)?.toDouble(),
//       value: (json['value'] as num?)?.toDouble(),
//     );
//   }

//   // Get the actual value for the chart (earnings or value)
//   double get chartValue => earnings ?? value ?? 0.0;
// }















// chart_model.dart
class ChartResponse {
  final String? rider;
  final String? filter;
  final double? totalEarnings;
  final double? walletBalance;
  final List<ChartData> chartData;

  ChartResponse({
    this.rider,
    this.filter,
    this.totalEarnings,
    this.walletBalance,
    required this.chartData,
  });

  factory ChartResponse.fromJson(Map<String, dynamic> json) {
    return ChartResponse(
      rider: json['rider']?.toString(),
      filter: json['filter']?.toString(),
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      chartData: (json['chartData'] as List<dynamic>?)
          ?.map((item) => ChartData.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rider': rider,
      'filter': filter,
      'totalEarnings': totalEarnings,
      'walletBalance': walletBalance,
      'chartData': chartData.map((item) => item.toJson()).toList(),
    };
  }
}

class ChartData {
  final String? day;
  final String? label;
  final String? date;
  final String? time;
  final double? earnings;
  final double? value; // Keep this for backward compatibility

  ChartData({
    this.day,
    this.label,
    this.date,
    this.time,
    this.earnings,
    this.value,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      day: json['day']?.toString(),
      label: json['label']?.toString(),
      date: json['date']?.toString(),
      time: json['time']?.toString(),
      earnings: (json['earnings'] ?? json['value'] ?? 0).toDouble(),
      value: (json['value'] ?? json['earnings'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'label': label,
      'date': date,
      'time': time,
      'earnings': earnings,
      'value': value,
    };
  }

  // Helper getter to get the chart value (prioritize earnings, fallback to value)
  double get chartValue => earnings ?? value ?? 0.0;
}