
class NewOrderResponse {
  final bool success;
  final String message;
  final List<NewOrder> newOrders;

  NewOrderResponse({
    required this.success,
    required this.message,
    required this.newOrders,
  });

  factory NewOrderResponse.fromJson(Map<String, dynamic> json) {
    return NewOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      newOrders: (json['newOrders'] as List? ?? [])
          .map((e) => NewOrder.fromJson(e))
          .toList(),
    );
  }
}

class NewOrder {
  final String id;
  final String orderId;
  final String status;

  /// 🔥 Rider related
  final String assignedRider;
  final String assignedRiderStatus;

  /// 🔥 Money
  final double totalAmount;
  final double estimatedEarning;
  final String paymentMethod;

  /// 🔥 Core Data
  final DeliveryAddress deliveryAddress;
  final User user;
  final List<OrderItem> orderItems;

  /// 🔥 Tracking
  final List<StatusTimeline> statusTimeline;
  final List<PharmacyPickup> pharmacyPickups;

  /// 🔥 Optional extras
  final String notes;
  final String paymentStatus;
  final DateTime? createdAt;

  NewOrder({
    required this.id,
    required this.orderId,
    required this.status,
    required this.assignedRider,
    required this.assignedRiderStatus,
    required this.totalAmount,
    required this.estimatedEarning,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.user,
    required this.orderItems,
    required this.statusTimeline,
    required this.pharmacyPickups,
    required this.notes,
    required this.paymentStatus,
    this.createdAt,
  });

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      status: json['status'] ?? '',

      assignedRider: json['assignedRider'] ?? '',
      assignedRiderStatus: json['assignedRiderStatus'] ?? '',

      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      estimatedEarning: (json['estimatedEarning'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',

      deliveryAddress:
          DeliveryAddress.fromJson(json['deliveryAddress'] ?? {}),

      user: User.fromJson(json['userId'] ?? {}),

      orderItems: (json['orderItems'] as List? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),

      statusTimeline: (json['statusTimeline'] as List? ?? [])
          .map((e) => StatusTimeline.fromJson(e))
          .toList(),

      pharmacyPickups: (json['pharmacyPickups'] as List? ?? [])
          .map((e) => PharmacyPickup.fromJson(e))
          .toList(),

      notes: json['notes'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}

class DeliveryAddress {
  final String house;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String country;

  DeliveryAddress({
    required this.house,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      house: json['house'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String mobile;
  final String profileImage;

  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String description;
  final List<String> images;
  final bool isPicked;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
    required this.images,
    required this.isPicked,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      isPicked: json['isPicked'] ?? false,
    );
  }
}

class StatusTimeline {
  final String status;
  final String message;
  final DateTime? timestamp;

  StatusTimeline({
    required this.status,
    required this.message,
    this.timestamp,
  });

  factory StatusTimeline.fromJson(Map<String, dynamic> json) {
    return StatusTimeline(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }
}

class PharmacyPickup {
  final String pharmacyId;
  final String pharmacyName;
  final String pharmacyAddress;
  final String pharmacyPhone;
  final double latitude;
  final double longitude;
  final String pharmacyImage;
  final String responseStatus;
  final bool isPickupCompleted;
  final int totalItems;
  final List<PickupMedicine> medicines;

  PharmacyPickup({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.pharmacyAddress,
    required this.pharmacyPhone,
    required this.latitude,
    required this.longitude,
    required this.pharmacyImage,
    required this.responseStatus,
    required this.isPickupCompleted,
    required this.totalItems,
    required this.medicines,
  });

  factory PharmacyPickup.fromJson(Map<String, dynamic> json) {
    return PharmacyPickup(
      pharmacyId: json['pharmacyId'] ?? '',
      pharmacyName: json['pharmacyName'] ?? '',
      pharmacyAddress: json['pharmacyAddress'] ?? '',
      pharmacyPhone: json['pharmacyPhone'] ?? '',
      latitude: (json['pharmacyLatitude'] ?? 0).toDouble(),
      longitude: (json['pharmacyLongitude'] ?? 0).toDouble(),
      pharmacyImage: json['pharmacyImage'] ?? '',
      responseStatus: json['responseStatus'] ?? '',
      isPickupCompleted: json['isPickupCompleted'] ?? false,
      totalItems: json['totalItems'] ?? 0,
      medicines: (json['medicines'] as List? ?? [])
          .map((e) => PickupMedicine.fromJson(e))
          .toList(),
    );
  }
}

class PickupMedicine {
  final String medicineId;
  final String name;
  final double mrp;
  final int quantity;
  final List<String> images;
  final String description;
  final bool isPicked;

  PickupMedicine({
    required this.medicineId,
    required this.name,
    required this.mrp,
    required this.quantity,
    required this.images,
    required this.description,
    required this.isPicked,
  });

  factory PickupMedicine.fromJson(Map<String, dynamic> json) {
    return PickupMedicine(
      medicineId: json['medicineId'] ?? '',
      name: json['name'] ?? '',
      mrp: (json['mrp'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      isPicked: json['isPicked'] ?? false,
    );
  }
}
