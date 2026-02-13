// bank_details_model.dart
class BankDetailsModel {
  final String? id;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String upiId;
  final String? addedAt;

  BankDetailsModel({
    this.id,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.upiId,
    this.addedAt,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['_id'],
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      upiId: json['upiId'] ?? '',
      addedAt: json['addedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'upiId': upiId,
    };
  }
}

class BankDetailsResponse {
  final String message;
  final List<BankDetailsModel> accountDetails;

  BankDetailsResponse({
    required this.message,
    required this.accountDetails,
  });

  factory BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BankDetailsResponse(
      message: json['message'] ?? '',
      accountDetails: (json['accountDetails'] as List<dynamic>?)
              ?.map((item) => BankDetailsModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}