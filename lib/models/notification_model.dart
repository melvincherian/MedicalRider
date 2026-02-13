class NotificationModel {
  final String id;
  final OrderModel order;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.order,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      order: OrderModel.fromJson(json['order'] ?? {}),
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'order': order.toJson(),
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class OrderModel {
  final String id;
  final UserModel user;
  final DeliveryAddressModel deliveryAddress;
  final List<OrderItemModel> orderItems;
  final double subTotal;
  final double platformFee;
  final double deliveryCharge;
  final double totalAmount;
  final String notes;
  final String voiceNoteUrl;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final List<StatusTimelineModel> statusTimeline;

  OrderModel({
    required this.id,
    required this.user,
    required this.deliveryAddress,
    required this.orderItems,
    required this.subTotal,
    required this.platformFee,
    required this.deliveryCharge,
    required this.totalAmount,
    required this.notes,
    required this.voiceNoteUrl,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.statusTimeline,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      deliveryAddress: DeliveryAddressModel.fromJson(json['deliveryAddress'] ?? {}),
      orderItems: (json['orderItems'] as List<dynamic>? ?? [])
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      platformFee: (json['platformFee'] ?? 0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      voiceNoteUrl: json['voiceNoteUrl'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      status: json['status'] ?? '',
      statusTimeline: (json['statusTimeline'] as List<dynamic>? ?? [])
          .map((timeline) => StatusTimelineModel.fromJson(timeline))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'deliveryAddress': deliveryAddress.toJson(),
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'subTotal': subTotal,
      'platformFee': platformFee,
      'deliveryCharge': deliveryCharge,
      'totalAmount': totalAmount,
      'notes': notes,
      'voiceNoteUrl': voiceNoteUrl,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'statusTimeline': statusTimeline.map((timeline) => timeline.toJson()).toList(),
    };
  }
}

class UserModel {
  final String id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class DeliveryAddressModel {
  final String id;
  final String house;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String country;

  DeliveryAddressModel({
    required this.id,
    required this.house,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      id: json['_id'] ?? '',
      house: json['house'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'house': house,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
    };
  }

  String get fullAddress {
    return '$house, $street, $city, $state - $pincode, $country';
  }
}

class OrderItemModel {
  final String id;
  final String medicineId;
  final int quantity;
  final String name;
  final double price;
  final List<String> images;
  final String description;
  final String pharmacy;

  OrderItemModel({
    required this.id,
    required this.medicineId,
    required this.quantity,
    required this.name,
    required this.price,
    required this.images,
    required this.description,
    required this.pharmacy,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['_id'] ?? '',
      medicineId: json['medicineId'] ?? '',
      quantity: json['quantity'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      pharmacy: json['pharmacy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'medicineId': medicineId,
      'quantity': quantity,
      'name': name,
      'price': price,
      'images': images,
      'description': description,
      'pharmacy': pharmacy,
    };
  }
}

class StatusTimelineModel {
  final String id;
  final String status;
  final String message;
  final DateTime timestamp;

  StatusTimelineModel({
    required this.id,
    required this.status,
    required this.message,
    required this.timestamp,
  });

  factory StatusTimelineModel.fromJson(Map<String, dynamic> json) {
    return StatusTimelineModel(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'status': status,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class NotificationResponse {
  final String message;
  final List<NotificationModel> notifications;

  NotificationResponse({
    required this.message,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      message: json['message'] ?? '',
      notifications: (json['notifications'] as List<dynamic>? ?? [])
          .map((notification) => NotificationModel.fromJson(notification))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'notifications': notifications.map((notification) => notification.toJson()).toList(),
    };
  }
}