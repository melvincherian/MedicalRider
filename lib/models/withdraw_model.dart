// models/withdraw_model.dart

class WithdrawRequest {
  final double amount;
  final String bankId;

  WithdrawRequest({
    required this.amount,
    required this.bankId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'bankId': bankId,
    };
  }
}

class WithdrawResponse {
  final String message;
  final String requestId;
  final String status;

  WithdrawResponse({
    required this.message,
    required this.requestId,
    required this.status,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(
      message: json['message'] ?? '',
      requestId: json['requestId'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'requestId': requestId,
      'status': status,
    };
  }
}

class WithdrawHistory {
  final String id;
  final double amount;
  final String status;
  final String requestId;
  final DateTime createdAt;
  final String? bankName;
  final String? accountNumber;

  WithdrawHistory({
    required this.id,
    required this.amount,
    required this.status,
    required this.requestId,
    required this.createdAt,
    this.bankName,
    this.accountNumber,
  });

  factory WithdrawHistory.fromJson(Map<String, dynamic> json) {
    return WithdrawHistory(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      requestId: json['requestId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'requestId': requestId,
      'createdAt': createdAt.toIso8601String(),
      'bankName': bankName,
      'accountNumber': accountNumber,
    };
  }
}