// // models/order_models.dart
// class OrderResponse {
//   final String message;
//   final List<OrderModel> orders;

//   OrderResponse({
//     required this.message,
//     required this.orders,
//   });

//   factory OrderResponse.fromJson(Map<String, dynamic> json) {
//     return OrderResponse(
//       message: json['message'] ?? '',
//       orders: (json['orders'] as List<dynamic>?)
//               ?.map((item) => OrderModel.fromJson(item))
//               .toList() ??
//           [],
//     );
//   }
// }

// class OrderModel {
//   final DeliveryAddress deliveryAddress;
//   final String id;
//   final UserInfo userId;
//   final List<OrderItem> orderItems;
//   final List<StatusTimeline> statusTimeline;
//   final double totalAmount;
//   final String notes;
//   final String voiceNoteUrl;
//   final String paymentMethod;
//   final String status;
//   final String assignedRider;
//   final String assignedRiderStatus;
//   final String? transactionId;
//   final String paymentStatus;
//   final String? razorpayOrder;
//   final String createdAt;
//   final String updatedAt;

//   OrderModel({
//     required this.deliveryAddress,
//     required this.id,
//     required this.userId,
//     required this.orderItems,
//     required this.statusTimeline,
//     required this.totalAmount,
//     required this.notes,
//     required this.voiceNoteUrl,
//     required this.paymentMethod,
//     required this.status,
//     required this.assignedRider,
//     required this.assignedRiderStatus,
//     this.transactionId,
//     required this.paymentStatus,
//     this.razorpayOrder,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress']),
//       id: json['_id'] ?? '',
//       userId: UserInfo.fromJson(json['userId']),
//       orderItems: (json['orderItems'] as List<dynamic>?)
//               ?.map((item) => OrderItem.fromJson(item))
//               .toList() ??
//           [],
//       statusTimeline: (json['statusTimeline'] as List<dynamic>?)
//               ?.map((item) => StatusTimeline.fromJson(item))
//               .toList() ??
//           [],
//       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
//       notes: json['notes'] ?? '',
//       voiceNoteUrl: json['voiceNoteUrl'] ?? '',
//       paymentMethod: json['paymentMethod'] ?? '',
//       status: json['status'] ?? '',
//       assignedRider: json['assignedRider'] ?? '',
//       assignedRiderStatus: json['assignedRiderStatus'] ?? '',
//       transactionId: json['transactionId'],
//       paymentStatus: json['paymentStatus'] ?? '',
//       razorpayOrder: json['razorpayOrder'],
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//     );
//   }
// }

// class DeliveryAddress {
//   final String house;
//   final String street;
//   final String city;
//   final String state;
//   final String pincode;
//   final String country;

//   DeliveryAddress({
//     required this.house,
//     required this.street,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.country,
//   });

//   factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
//     return DeliveryAddress(
//       house: json['house'] ?? '',
//       street: json['street'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       pincode: json['pincode'] ?? '',
//       country: json['country'] ?? '',
//     );
//   }
// }

// class UserInfo {
//   final Location location;
//   final String id;
//   final String name;
//   final String mobile;

//   UserInfo({
//     required this.location,
//     required this.id,
//     required this.name,
//     required this.mobile,
//   });

//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       location: Location.fromJson(json['location']),
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       mobile: json['mobile'] ?? '',
//     );
//   }
// }

// class Location {
//   final String type;
//   final List<double> coordinates;

//   Location({
//     required this.type,
//     required this.coordinates,
//   });

//   // factory Location.fromJson(Map<String, dynamic> json) {
//   //   return Location(
//   //     type: json['type'] ?? '',
//   //     coordinates: (json['coordinates'] as List<dynamic>?)
//   //             ?.map((coord) => coord.toDouble())
//   //             .toList() ??
//   //         [],
//   //   );
//   // }

//   factory Location.fromJson(Map<String, dynamic> json) {
//   return Location(
//     type: json['type'] ?? '',
//     coordinates: (json['coordinates'] as List?)
//             ?.map((coord) => (coord as num).toDouble())
//             .toList() ??
//         [],
//   );
// }

// }

// class OrderItem {
//   final MedicineInfo medicineId;
//   final String name;
//   final int quantity;
//   final String id;

//   OrderItem({
//     required this.medicineId,
//     required this.name,
//     required this.quantity,
//     required this.id,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       medicineId: MedicineInfo.fromJson(json['medicineId']),
//       name: json['name'] ?? '',
//       quantity: json['quantity'] ?? 0,
//       id: json['_id'] ?? '',
//     );
//   }
// }

// class MedicineInfo {
//   final String id;
//   final PharmacyInfo pharmacyId;
//   final String name;
//   final List<String> images;
//   final String description;
//   final double mrp;

//   MedicineInfo({
//     required this.id,
//     required this.pharmacyId,
//     required this.name,
//     required this.images,
//     required this.description,
//     required this.mrp,
//   });

//   factory MedicineInfo.fromJson(Map<String, dynamic> json) {
//     return MedicineInfo(
//       id: json['_id'] ?? '',
//       pharmacyId: PharmacyInfo.fromJson(json['pharmacyId']),
//       name: json['name'] ?? '',
//       images: (json['images'] as List<dynamic>?)
//               ?.map((image) => image.toString())
//               .toList() ??
//           [],
//       description: json['description'] ?? '',
//       mrp: (json['mrp'] ?? 0).toDouble(),
//     );
//   }
// }

// class PharmacyInfo {
//   final String id;
//   final String name;
//   final double latitude;
//   final double longitude;

//   PharmacyInfo({
//     required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//   });

//   factory PharmacyInfo.fromJson(Map<String, dynamic> json) {
//     return PharmacyInfo(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       latitude: (json['latitude'] ?? 0).toDouble(),
//       longitude: (json['longitude'] ?? 0).toDouble(),
//     );
//   }
// }

// class StatusTimeline {
//   final String status;
//   final String message;
//   final String timestamp;
//   final String id;

//   StatusTimeline({
//     required this.status,
//     required this.message,
//     required this.timestamp,
//     required this.id,
//   });

//   factory StatusTimeline.fromJson(Map<String, dynamic> json) {
//     return StatusTimeline(
//       status: json['status'] ?? '',
//       message: json['message'] ?? '',
//       timestamp: json['timestamp'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
// }


















// models/order_models.dart
class OrderResponse {
  final String message;
  final List<OrderModel> orders;

  OrderResponse({
    required this.message,
    required this.orders,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    try {
      return OrderResponse(
        message: json['message'] ?? '',
        orders: (json['orders'] as List<dynamic>?)
                ?.map((item) {
                  try {
                    return OrderModel.fromJson(item as Map<String, dynamic>);
                  } catch (e) {
                    print('Error parsing order item: $e');
                    return null;
                  }
                })
                .where((item) => item != null)
                .cast<OrderModel>()
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing OrderResponse: $e');
      return OrderResponse(message: '', orders: []);
    }
  }
}


class DeliveryProof {
  final String riderId;
  final String imageUrl;
  final String uploadedAt;
  final String id;

  DeliveryProof({
    required this.riderId,
    required this.imageUrl,
    required this.uploadedAt,
    required this.id,
  });

  factory DeliveryProof.fromJson(Map<String, dynamic> json) {
    return DeliveryProof(
      riderId: json['riderId']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      uploadedAt: json['uploadedAt']?.toString() ?? '',
      id: json['_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riderId': riderId,
      'imageUrl': imageUrl,
      'uploadedAt': uploadedAt,
      '_id': id,
    };
  }
}


class OrderModel {
  final DeliveryAddress? deliveryAddress;
  final String id;
  final UserInfo? userId;
  final List<OrderItem> orderItems;
  final List<StatusTimeline> statusTimeline;
  final List<DeliveryProof> deliveryProof; // 👈 Added here
  final double totalAmount;
  final String notes;
  final String voiceNoteUrl;
  final String paymentMethod;
  final String status;
  final String assignedRider;
  final String assignedRiderStatus;
  final String? transactionId;
  final String paymentStatus;
  final String? razorpayOrder;
  final String createdAt;
  final String updatedAt;

  OrderModel({
    this.deliveryAddress,
    required this.id,
    this.userId,
    required this.orderItems,
    required this.statusTimeline,
    required this.deliveryProof, // 👈 Added in constructor
    required this.totalAmount,
    required this.notes,
    required this.voiceNoteUrl,
    required this.paymentMethod,
    required this.status,
    required this.assignedRider,
    required this.assignedRiderStatus,
    this.transactionId,
    required this.paymentStatus,
    this.razorpayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        deliveryAddress: json['deliveryAddress'] != null
            ? DeliveryAddress.fromJson(json['deliveryAddress'] as Map<String, dynamic>)
            : null,
        id: json['_id']?.toString() ?? '',
        userId: json['userId'] != null
            ? UserInfo.fromJson(json['userId'] as Map<String, dynamic>)
            : null,
        orderItems: (json['orderItems'] as List<dynamic>?)
                ?.map((item) {
                  try {
                    return OrderItem.fromJson(item as Map<String, dynamic>);
                  } catch (e) {
                    print('Error parsing order item: $e');
                    return null;
                  }
                })
                .where((item) => item != null)
                .cast<OrderItem>()
                .toList() ??
            [],
        statusTimeline: (json['statusTimeline'] as List<dynamic>?)
                ?.map((item) {
                  try {
                    return StatusTimeline.fromJson(item as Map<String, dynamic>);
                  } catch (e) {
                    print('Error parsing status timeline: $e');
                    return null;
                  }
                })
                .where((item) => item != null)
                .cast<StatusTimeline>()
                .toList() ??
            [],
        deliveryProof: (json['deliveryProof'] as List<dynamic>?) // 👈 Parse deliveryProof
                ?.map((item) {
                  try {
                    return DeliveryProof.fromJson(item as Map<String, dynamic>);
                  } catch (e) {
                    print('Error parsing delivery proof: $e');
                    return null;
                  }
                })
                .where((item) => item != null)
                .cast<DeliveryProof>()
                .toList() ??
            [],
        totalAmount: _parseDouble(json['totalAmount']),
        notes: json['notes']?.toString() ?? '',
        voiceNoteUrl: json['voiceNoteUrl']?.toString() ?? '',
        paymentMethod: json['paymentMethod']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        assignedRider: json['assignedRider']?.toString() ?? '',
        assignedRiderStatus: json['assignedRiderStatus']?.toString() ?? '',
        transactionId: json['transactionId']?.toString(),
        paymentStatus: json['paymentStatus']?.toString() ?? '',
        razorpayOrder: json['razorpayOrder']?.toString(),
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing OrderModel: $e');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}



// class OrderModel {
//   final DeliveryAddress? deliveryAddress;
//   final String id;
//   final UserInfo? userId;
//   final List<OrderItem> orderItems;
//   final List<StatusTimeline> statusTimeline;
//   final double totalAmount;
//   final String notes;
//   final String voiceNoteUrl;
//   final String paymentMethod;
//   final String status;
//   final String assignedRider;
//   final String assignedRiderStatus;
//   final String? transactionId;
//   final String paymentStatus;
//   final String? razorpayOrder;
//   final String createdAt;
//   final String updatedAt;

//   OrderModel({
//     this.deliveryAddress,
//     required this.id,
//     this.userId,
//     required this.orderItems,
//     required this.statusTimeline,
//     required this.totalAmount,
//     required this.notes,
//     required this.voiceNoteUrl,
//     required this.paymentMethod,
//     required this.status,
//     required this.assignedRider,
//     required this.assignedRiderStatus,
//     this.transactionId,
//     required this.paymentStatus,
//     this.razorpayOrder,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     try {
//       return OrderModel(
//         deliveryAddress: json['deliveryAddress'] != null 
//             ? DeliveryAddress.fromJson(json['deliveryAddress'] as Map<String, dynamic>) 
//             : null,
//         id: json['_id']?.toString() ?? '',
//         userId: json['userId'] != null 
//             ? UserInfo.fromJson(json['userId'] as Map<String, dynamic>) 
//             : null,
//         orderItems: (json['orderItems'] as List<dynamic>?)
//                 ?.map((item) {
//                   try {
//                     return OrderItem.fromJson(item as Map<String, dynamic>);
//                   } catch (e) {
//                     print('Error parsing order item: $e');
//                     return null;
//                   }
//                 })
//                 .where((item) => item != null)
//                 .cast<OrderItem>()
//                 .toList() ??
//             [],
//         statusTimeline: (json['statusTimeline'] as List<dynamic>?)
//                 ?.map((item) {
//                   try {
//                     return StatusTimeline.fromJson(item as Map<String, dynamic>);
//                   } catch (e) {
//                     print('Error parsing status timeline: $e');
//                     return null;
//                   }
//                 })
//                 .where((item) => item != null)
//                 .cast<StatusTimeline>()
//                 .toList() ??
//             [],
//         totalAmount: _parseDouble(json['totalAmount']),
//         notes: json['notes']?.toString() ?? '',
//         voiceNoteUrl: json['voiceNoteUrl']?.toString() ?? '',
//         paymentMethod: json['paymentMethod']?.toString() ?? '',
//         status: json['status']?.toString() ?? '',
//         assignedRider: json['assignedRider']?.toString() ?? '',
//         assignedRiderStatus: json['assignedRiderStatus']?.toString() ?? '',
//         transactionId: json['transactionId']?.toString(),
//         paymentStatus: json['paymentStatus']?.toString() ?? '',
//         razorpayOrder: json['razorpayOrder']?.toString(),
//         createdAt: json['createdAt']?.toString() ?? '',
//         updatedAt: json['updatedAt']?.toString() ?? '',
//       );
//     } catch (e) {
//       print('Error parsing OrderModel: $e');
//       rethrow;
//     }
//   }

//   static double _parseDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }
// }

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
    try {
      return DeliveryAddress(
        house: json['house']?.toString() ?? '',
        street: json['street']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        state: json['state']?.toString() ?? '',
        pincode: json['pincode']?.toString() ?? '',
        country: json['country']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing DeliveryAddress: $e');
      rethrow;
    }
  }
}

class UserInfo {
  final Location? location;
  final String id;
  final String name;
  final String mobile;

  UserInfo({
    this.location,
    required this.id,
    required this.name,
    required this.mobile,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    try {
      return UserInfo(
        location: json['location'] != null && json['location'] is Map<String, dynamic>
            ? Location.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing UserInfo: $e');
      rethrow;
    }
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    try {
      return Location(
        type: json['type']?.toString() ?? '',
        coordinates: (json['coordinates'] as List?)
                ?.map((coord) {
                  if (coord is num) return coord.toDouble();
                  if (coord is String) return double.tryParse(coord) ?? 0.0;
                  return 0.0;
                })
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing Location: $e');
      return Location(type: '', coordinates: []);
    }
  }
}

class OrderItem {
  final MedicineInfo? medicineId;
  final String name;
  final int quantity;
  final String id;

  OrderItem({
    this.medicineId,
    required this.name,
    required this.quantity,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    try {
      return OrderItem(
        medicineId: json['medicineId'] != null && json['medicineId'] is Map<String, dynamic>
            ? MedicineInfo.fromJson(json['medicineId'] as Map<String, dynamic>)
            : null,
        name: json['name']?.toString() ?? '',
        quantity: _parseInt(json['quantity']),
        id: json['_id']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing OrderItem: $e');
      rethrow;
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class MedicineInfo {
  final String id;
  final PharmacyInfo? pharmacyId;
  final String name;
  final List<String> images;
  final String description;
  final double mrp;

  MedicineInfo({
    required this.id,
    this.pharmacyId,
    required this.name,
    required this.images,
    required this.description,
    required this.mrp,
  });

  factory MedicineInfo.fromJson(Map<String, dynamic> json) {
    try {
      return MedicineInfo(
        id: json['_id']?.toString() ?? '',
        pharmacyId: json['pharmacyId'] != null && json['pharmacyId'] is Map<String, dynamic>
            ? PharmacyInfo.fromJson(json['pharmacyId'] as Map<String, dynamic>)
            : null,
        name: json['name']?.toString() ?? '',
        images: (json['images'] as List<dynamic>?)
                ?.map((image) => image?.toString() ?? '')
                .where((image) => image.isNotEmpty)
                .toList() ??
            [],
        description: json['description']?.toString() ?? '',
        mrp: _parseDouble(json['mrp']),
      );
    } catch (e) {
      print('Error parsing MedicineInfo: $e');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class PharmacyInfo {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  PharmacyInfo({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory PharmacyInfo.fromJson(Map<String, dynamic> json) {
    try {
      return PharmacyInfo(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        latitude: _parseDouble(json['latitude']),
        longitude: _parseDouble(json['longitude']),
      );
    } catch (e) {
      print('Error parsing PharmacyInfo: $e');
      rethrow;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class StatusTimeline {
  final String status;
  final String message;
  final String timestamp;
  final String id;

  StatusTimeline({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.id,
  });

  factory StatusTimeline.fromJson(Map<String, dynamic> json) {
    try {
      return StatusTimeline(
        status: json['status']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        timestamp: json['timestamp']?.toString() ?? '',
        id: json['_id']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing StatusTimeline: $e');
      rethrow;
    }
  }
}