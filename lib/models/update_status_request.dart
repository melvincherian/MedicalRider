class UpdateStatusRequest {
  final String orderId;
  final String newStatus;
  final String pharmacyId;

  UpdateStatusRequest({
    required this.orderId,
    required this.newStatus,
    required this.pharmacyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'newStatus': newStatus,
      'pharmacyId': pharmacyId,
    };
  }
}