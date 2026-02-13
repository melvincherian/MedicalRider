
double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String parseString(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

DateTime parseDate(dynamic value) {
  if (value == null) return DateTime.now();
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return DateTime.now();
  }
}

List<T> parseList<T>(dynamic value, T Function(dynamic) parser) {
  if (value is List) {
    return value.map((e) => parser(e)).toList();
  }
  return [];
}

Map<String, dynamic> parseMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return {};
}

// ==============================================================
//                        NEW ORDER RESPONSE
// ==============================================================

class NewOrderResponse {
  final bool success;
  final String message;
  final List<Order> newOrders;

  NewOrderResponse({
    required this.success,
    required this.message,
    required this.newOrders,
  });

  factory NewOrderResponse.fromJson(Map<String, dynamic> json) {
    return NewOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      newOrders: parseList(
        json['newOrders'],
        (e) => Order.fromJson(parseMap(e)),
      ),
    );
  }
}


// ==============================================================
//                        NEW ORDER ITEM
// ==============================================================

class NewOrderItem {
  final Order order;
  final String pickupDistance;
  final String dropDistance;
  final String pickupTime;
  final String dropTime;
  final String estimatedEarning;
  final BillingDetails billingDetails;

  NewOrderItem({
    required this.order,
    required this.pickupDistance,
    required this.dropDistance,
    required this.pickupTime,
    required this.dropTime,
    required this.estimatedEarning,
    required this.billingDetails,
  });

  factory NewOrderItem.fromJson(Map<String, dynamic> json) {
    return NewOrderItem(
      order: Order.fromJson(parseMap(json['order'])),
      pickupDistance: parseString(json['pickupDistance']),
      dropDistance: parseString(json['dropDistance']),
      pickupTime: parseString(json['pickupTime']),
      dropTime: parseString(json['dropTime']),
      estimatedEarning: parseString(json['estimatedEarning']),
      billingDetails: BillingDetails.fromJson(parseMap(json['billingDetails'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order.toJson(),
      'pickupDistance': pickupDistance,
      'dropDistance': dropDistance,
      'pickupTime': pickupTime,
      'dropTime': dropTime,
      'estimatedEarning': estimatedEarning,
      'billingDetails': billingDetails.toJson(),
    };
  }
}

// ==============================================================
//                              ORDER
// ==============================================================

// class Order {
//   final String id;
//   final String orderId;
//   final User userId;
//   final DeliveryAddress deliveryAddress;
//   final List<OrderItem> orderItems;
//   final List<StatusTimeline> statusTimeline;
//   final List<PharmacyResponse> pharmacyResponses;
//   final double totalAmount;
//   final String notes;
//   final String voiceNoteUrl;
//   final String paymentMethod;
//   final String status;
//   final String assignedRider;
//   final String assignedRiderStatus;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   Order({
//     required this.id,
//     required this.orderId,
//     required this.userId,
//     required this.deliveryAddress,
//     required this.orderItems,
//     required this.statusTimeline,
//     required this.pharmacyResponses,
//     required this.totalAmount,
//     required this.notes,
//     required this.voiceNoteUrl,
//     required this.paymentMethod,
//     required this.status,
//     required this.assignedRider,
//     required this.assignedRiderStatus,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: parseString(json['_id']),
//       orderId: parseString(json['orderId']),
//       userId: User.fromJson(parseMap(json['userId'])),
//       deliveryAddress: DeliveryAddress.fromJson(parseMap(json['deliveryAddress'])),

//       orderItems: parseList(
//         json['orderItems'],
//         (e) => OrderItem.fromJson(parseMap(e)),
//       ),

//       statusTimeline: parseList(
//         json['statusTimeline'],
//         (e) => StatusTimeline.fromJson(parseMap(e)),
//       ),

//       pharmacyResponses: parseList(
//         json['pharmacyResponses'],
//         (e) => PharmacyResponse.fromJson(parseMap(e)),
//       ),

//       totalAmount: parseDouble(json['totalAmount']),
//       notes: parseString(json['notes']),
//       voiceNoteUrl: parseString(json['voiceNoteUrl']),
//       paymentMethod: parseString(json['paymentMethod']),
//       status: parseString(json['status']),
//       assignedRider: parseString(json['assignedRider']),
//       assignedRiderStatus: parseString(json['assignedRiderStatus']),

//       createdAt: parseDate(json['createdAt']),
//       updatedAt: parseDate(json['updatedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'orderId': orderId,
//       'userId': userId.toJson(),
//       'deliveryAddress': deliveryAddress.toJson(),
//       'orderItems': orderItems.map((e) => e.toJson()).toList(),
//       'statusTimeline': statusTimeline.map((e) => e.toJson()).toList(),
//       'pharmacyResponses': pharmacyResponses.map((e) => e.toJson()).toList(),
//       'totalAmount': totalAmount,
//       'notes': notes,
//       'voiceNoteUrl': voiceNoteUrl,
//       'paymentMethod': paymentMethod,
//       'status': status,
//       'assignedRider': assignedRider,
//       'assignedRiderStatus': assignedRiderStatus,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }


class Order {
  final String id;
  final String orderId;
  final User userId;
  final DeliveryAddress deliveryAddress;
  final List<OrderItem> orderItems;

  final double totalAmount;
  final double deliveryCharge;
  final double platformFee;
  final double estimatedEarning;

  final String notes;
  final String voiceNoteUrl;
  final String paymentMethod;
  final String status;

  final String assignedRider;
  final String assignedRiderStatus;

  final String paymentStatus;

  final List<StatusTimeline> statusTimeline;
  final List<PharmacyPickup> pharmacyPickups;

  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.deliveryAddress,
    required this.orderItems,
    required this.totalAmount,
    required this.deliveryCharge,
    required this.platformFee,
    required this.estimatedEarning,
    required this.notes,
    required this.voiceNoteUrl,
    required this.paymentMethod,
    required this.status,
    required this.assignedRider,
    required this.assignedRiderStatus,
    required this.paymentStatus,
    required this.statusTimeline,
    required this.pharmacyPickups,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: parseString(json['_id']),
      orderId: parseString(json['orderId']),
      userId: User.fromJson(parseMap(json['userId'])),
      deliveryAddress:
          DeliveryAddress.fromJson(parseMap(json['deliveryAddress'])),

      orderItems: parseList(
        json['orderItems'],
        (e) => OrderItem.fromJson(parseMap(e)),
      ),

      totalAmount: parseDouble(json['totalAmount']),
      deliveryCharge: parseDouble(json['deliveryCharge']),
      platformFee: parseDouble(json['platformFee']),
      estimatedEarning: parseDouble(json['estimatedEarning']),

      notes: parseString(json['notes']),
      voiceNoteUrl: parseString(json['voiceNoteUrl']),
      paymentMethod: parseString(json['paymentMethod']),
      status: parseString(json['status']),

      assignedRider: parseString(json['assignedRider']),
      assignedRiderStatus: parseString(json['assignedRiderStatus']),
      paymentStatus: parseString(json['paymentStatus']),

      statusTimeline: parseList(
        json['statusTimeline'],
        (e) => StatusTimeline.fromJson(parseMap(e)),
      ),

      pharmacyPickups: parseList(
        json['pharmacyPickups'],
        (e) => PharmacyPickup.fromJson(parseMap(e)),
      ),

      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
  return {
    '_id': id,
    'orderId': orderId,
    'userId': userId.toJson(),
    'deliveryAddress': deliveryAddress.toJson(),
    'orderItems': orderItems.map((e) => e.toJson()).toList(),
    'totalAmount': totalAmount,
    'notes': notes,
    'voiceNoteUrl': voiceNoteUrl,
    'paymentMethod': paymentMethod,
    'status': status,
    'assignedRider': assignedRider,
    'assignedRiderStatus': assignedRiderStatus,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

}


class PharmacyPickup {
  final String pharmacyId;
  final String pharmacyName;
  final String pharmacyAddress;
  final String pharmacyPhone;
  final double pharmacyLatitude;
  final double pharmacyLongitude;
  final String pharmacyImage;
  final String responseStatus;
  final bool isPickupCompleted;

  PharmacyPickup({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.pharmacyAddress,
    required this.pharmacyPhone,
    required this.pharmacyLatitude,
    required this.pharmacyLongitude,
    required this.pharmacyImage,
    required this.responseStatus,
    required this.isPickupCompleted,
  });

  factory PharmacyPickup.fromJson(Map<String, dynamic> json) {
    return PharmacyPickup(
      pharmacyId: parseString(json['pharmacyId']),
      pharmacyName: parseString(json['pharmacyName']),
      pharmacyAddress: parseString(json['pharmacyAddress']),
      pharmacyPhone: parseString(json['pharmacyPhone']),
      pharmacyLatitude: parseDouble(json['pharmacyLatitude']),
      pharmacyLongitude: parseDouble(json['pharmacyLongitude']),
      pharmacyImage: parseString(json['pharmacyImage']),
      responseStatus: parseString(json['responseStatus']),
      isPickupCompleted: json['isPickupCompleted'] ?? false,
    );
  }
}


// ==============================================================
//                               USER
// ==============================================================

class User {
  final String id;
  final String name;
  final String mobile;
  final Location location;

  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      mobile: parseString(json['mobile']),
      location: Location.fromJson(parseMap(json['location'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobile': mobile,
      'location': location.toJson(),
    };
  }
}

// ==============================================================
//                             LOCATION
// ==============================================================

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: parseString(json['type']),
      coordinates: parseList(json['coordinates'], (e) => parseDouble(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

// ==============================================================
//                      BILLING DETAILS
// ==============================================================

class BillingDetails {
  final int totalItems;
  final String subTotal;
  final String platformFee;
  final String deliveryCharge;
  final String totalPaid;

  BillingDetails({
    required this.totalItems,
    required this.subTotal,
    required this.platformFee,
    required this.deliveryCharge,
    required this.totalPaid,
  });

  factory BillingDetails.fromJson(Map<String, dynamic> json) {
    return BillingDetails(
      totalItems: parseInt(json['totalItems']),
      subTotal: parseString(json['subTotal']),
      platformFee: parseString(json['platformFee']),
      deliveryCharge: parseString(json['deliveryCharge']),
      totalPaid: parseString(json['totalPaid']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'subTotal': subTotal,
      'platformFee': platformFee,
      'deliveryCharge': deliveryCharge,
      'totalPaid': totalPaid,
    };
  }
}

// ==============================================================
//                     DELIVERY ADDRESS
// ==============================================================

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
      house: parseString(json['house']),
      street: parseString(json['street']),
      city: parseString(json['city']),
      state: parseString(json['state']),
      pincode: parseString(json['pincode']),
      country: parseString(json['country']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'house': house,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
    };
  }

  String get fullAddress =>
      '$house, $street, $city, $state - $pincode, $country';
}

// ==============================================================
//                         ORDER ITEM
// ==============================================================

// class OrderItem {
//   final MedicineDetails medicineId;
//   final String name;
//   final double price;
//   final int quantity;
//   final List<String> images;
//   final String description;
//   final String id;

//   OrderItem({
//     required this.medicineId,
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.images,
//     required this.description,
//     required this.id,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       medicineId: MedicineDetails.fromJson(parseMap(json['medicineId'])),
//       name: parseString(json['name']),
//       price: parseDouble(json['price']),
//       quantity: parseInt(json['quantity']),
//       images: parseList(json['images'], (e) => parseString(e)),
//       description: parseString(json['description']),
//       id: parseString(json['_id']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'medicineId': medicineId.toJson(),
//       'name': name,
//       'price': price,
//       'quantity': quantity,
//       'images': images,
//       'description': description,
//       '_id': id,
//     };
//   }
// }


class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final List<String> images;
  final String description;
  final bool isPicked;
  final MedicineDetails medicineId;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.images,
    required this.description,
    required this.isPicked,
    required this.medicineId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      price: parseDouble(json['price']),
      quantity: parseInt(json['quantity']),
      images: parseList(json['images'], (e) => parseString(e)),
      description: parseString(json['description']),
      isPicked: json['isPicked'] ?? false,
      medicineId: MedicineDetails.fromJson(parseMap(json['medicineId'])),
    );
  }

  Map<String, dynamic> toJson() {
  return {
    '_id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'images': images,
    'description': description,
    'isPicked': isPicked,
    'medicineId': medicineId.toJson(),
  };
}

}


// ==============================================================
//                     MEDICINE DETAILS
// ==============================================================

// class MedicineDetails {
//   final String id;
//   final PharmacyDetails pharmacyId;
//   final String name;
//   final List<String> images;
//   final double mrp;
//   final String description;

//   MedicineDetails({
//     required this.id,
//     required this.pharmacyId,
//     required this.name,
//     required this.images,
//     required this.mrp,
//     required this.description,
//   });

//   factory MedicineDetails.fromJson(Map<String, dynamic> json) {
//     return MedicineDetails(
//       id: parseString(json['_id']),
//       pharmacyId: PharmacyDetails.fromJson(parseMap(json['pharmacyId'])),
//       name: parseString(json['name']),
//       images: parseList(json['images'], (e) => parseString(e)),
//       mrp: parseDouble(json['mrp']),
//       description: parseString(json['description']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'pharmacyId': pharmacyId.toJson(),
//       'name': name,
//       'images': images,
//       'mrp': mrp,
//       'description': description,
//     };
//   }
// }


class MedicineDetails {
  final String id;
  final String name;
  final double mrp;
  final String description;
  final List<String> images;
  final PharmacyDetails pharmacyId;

  MedicineDetails({
    required this.id,
    required this.name,
    required this.mrp,
    required this.description,
    required this.images,
    required this.pharmacyId,
  });

  factory MedicineDetails.fromJson(Map<String, dynamic> json) {
    return MedicineDetails(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      mrp: parseDouble(json['mrp']),
      description: parseString(json['description']),
      images: parseList(json['images'], (e) => parseString(e)),
      pharmacyId: PharmacyDetails.fromJson(parseMap(json['pharmacyId'])),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pharmacyId': pharmacyId.toJson(),
      'name': name,
      'images': images,
      'mrp': mrp,
      'description': description,
    };
  }
}


// ==============================================================
//                   PHARMACY DETAILS
// ==============================================================

class PharmacyDetails {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  PharmacyDetails({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory PharmacyDetails.fromJson(Map<String, dynamic> json) {
    return PharmacyDetails(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      address: parseString(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

// ==============================================================
//                     PHARMACY RESPONSE
// ==============================================================

class PharmacyResponse {
  final PharmacyDetails pharmacyId;
  final String status;
  final DateTime respondedAt;
  final String id;

  PharmacyResponse({
    required this.pharmacyId,
    required this.status,
    required this.respondedAt,
    required this.id,
  });

  factory PharmacyResponse.fromJson(Map<String, dynamic> json) {
    return PharmacyResponse(
      pharmacyId: PharmacyDetails.fromJson(parseMap(json['pharmacyId'])),
      status: parseString(json['status']),
      respondedAt: parseDate(json['respondedAt']),
      id: parseString(json['_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pharmacyId': pharmacyId.toJson(),
      'status': status,
      'respondedAt': respondedAt.toIso8601String(),
      '_id': id,
    };
  }
}

// ==============================================================
//                     STATUS TIMELINE
// ==============================================================

class StatusTimeline {
  final String status;
  final String message;
  final DateTime timestamp;
  final String id;

  StatusTimeline({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.id,
  });

  factory StatusTimeline.fromJson(Map<String, dynamic> json) {
    return StatusTimeline(
      status: parseString(json['status']),
      message: parseString(json['message']),
      timestamp: parseDate(json['timestamp']),
      id: parseString(json['_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      '_id': id,
    };
  }
}

// ==============================================================
//                 UPDATE ORDER REQUEST / RESPONSE
// ==============================================================

// class UpdateOrderRequest {
//   final String orderId;
//   final String newStatus;

//   UpdateOrderRequest({
//     required this.orderId,
//     required this.newStatus,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'orderId': orderId,
//       'newStatus': newStatus,
//     };
//   }
// }

// class UpdateOrderResponse {
//   final String message;

//   UpdateOrderResponse({required this.message});

//   factory UpdateOrderResponse.fromJson(Map<String, dynamic> json) {
//     return UpdateOrderResponse(
//       message: parseString(json['message']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//     };
//   }
// }













// ==============================================================
//                 UPDATE ORDER REQUEST / RESPONSE
// ==============================================================

class UpdateOrderRequest {
  final String orderId;
  final String newStatus;
  final String pharmacyId; // Added pharmacy ID field

  UpdateOrderRequest({
    required this.orderId,
    required this.newStatus,
    required this.pharmacyId, // Added to constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'newStatus': newStatus,
      'pharmacyId': pharmacyId, // Added to JSON serialization
    };
  }
}

class UpdateOrderResponse {
  final String message;

  UpdateOrderResponse({required this.message});

  factory UpdateOrderResponse.fromJson(Map<String, dynamic> json) {
    return UpdateOrderResponse(
      message: parseString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}