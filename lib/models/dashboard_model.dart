// Dashboard Response Models
class DashboardResponse {
  final String message;
  final String filterUsed;
  final OrderStats orders;
  final EarningsStats earnings;

  DashboardResponse({
    required this.message,
    required this.filterUsed,
    required this.orders,
    required this.earnings,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      message: json['message'] ?? '',
      filterUsed: json['filterUsed'] ?? '',
      orders: OrderStats.fromJson(json['orders'] ?? {}),
      earnings: EarningsStats.fromJson(json['earnings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'filterUsed': filterUsed,
      'orders': orders.toJson(),
      'earnings': earnings.toJson(),
    };
  }
}

class OrderStats {
  final int todayOrders;
  final int pending;
  final int cancelled;
  final int completed;

  OrderStats({
    required this.todayOrders,
    required this.pending,
    required this.cancelled,
    required this.completed,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) {
    return OrderStats(
      todayOrders: json['todayOrders'] ?? 0,
      pending: json['pending'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayOrders': todayOrders,
      'pending': pending,
      'cancelled': cancelled,
      'completed': completed,
    };
  }
}

class EarningsStats {
  final double totalEarnings;
  final Map<String, double> earningsPerDay;

  EarningsStats({
    required this.totalEarnings,
    required this.earningsPerDay,
  });

  factory EarningsStats.fromJson(Map<String, dynamic> json) {
    final earningsData = json['earningsPerDay'] as Map<String, dynamic>? ?? {};
    final earningsMap = <String, double>{};
    
    earningsData.forEach((key, value) {
      earningsMap[key] = (value ?? 0).toDouble();
    });

    return EarningsStats(
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      earningsPerDay: earningsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEarnings': totalEarnings,
      'earningsPerDay': earningsPerDay,
    };
  }
}