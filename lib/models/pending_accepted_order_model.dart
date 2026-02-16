class PendingAcceptedOrderResponse {
  final bool success;
  final String message;
  final List<NewOrder> newOrders;

  PendingAcceptedOrderResponse({
    required this.success,
    required this.message,
    required this.newOrders,
  });

  factory PendingAcceptedOrderResponse.fromJson(Map<String, dynamic> json) {
    return PendingAcceptedOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      newOrders: (json['newOrders'] as List?)
              ?.map((item) => NewOrder.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class NewOrder {
  final String id;
  final String orderId;
  final List<PharmacyResponse> pharmacyResponses;

  NewOrder({
    required this.id,
    required this.orderId,
    required this.pharmacyResponses,
  });

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      pharmacyResponses: (json['pharmacyResponses'] as List?)
              ?.map((item) => PharmacyResponse.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class PharmacyResponse {
  final String pharmacyId;
  final String status;
  final DateTime? respondedAt;
  final String id;
  final PharmacyDetails? pharmacyDetails;

  PharmacyResponse({
    required this.pharmacyId,
    required this.status,
    this.respondedAt,
    required this.id,
    this.pharmacyDetails,
  });

  factory PharmacyResponse.fromJson(Map<String, dynamic> json) {
    return PharmacyResponse(
      pharmacyId: json['pharmacyId'] ?? '',
      status: json['status'] ?? '',
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'])
          : null,
      id: json['_id'] ?? '',
      pharmacyDetails: json['pharmacyDetails'] != null
          ? PharmacyDetails.fromJson(json['pharmacyDetails'])
          : null,
    );
  }
}

class PharmacyDetails {
  final String pharmacyId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String image;

  PharmacyDetails({
    required this.pharmacyId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.image,
  });

  factory PharmacyDetails.fromJson(Map<String, dynamic> json) {
    return PharmacyDetails(
      pharmacyId: json['pharmacyId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
    );
  }
}