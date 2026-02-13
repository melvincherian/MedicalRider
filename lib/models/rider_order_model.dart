
// class RiderOrderResponse {
//   final AcceptedOrder acceptedOrder;

//   RiderOrderResponse({required this.acceptedOrder});

//   factory RiderOrderResponse.fromJson(Map<String, dynamic> json) {
//     return RiderOrderResponse(
//       acceptedOrder: AcceptedOrder.fromJson(json['acceptedOrder'] ?? {}),
//     );
//   }
// }

// class AcceptedOrder {
//   final String id;
//   final UserInfo userId;
//   final DeliveryAddress deliveryAddress;
//   final List<OrderItem> orderItems;

//   final String status;
//   final String? assignedRider;
//   final String? assignedRiderStatus;

//   final double totalAmount;
//   final String paymentMethod;
//   final String paymentStatus;

//   final List<StatusTimeline> statusTimeline;

//   final String formattedPickupDistance;
//   final String formattedDropDistance;
//   final String pickupTime;
//   final String dropTime;

//   final DateTime createdAt;
//   final DateTime updatedAt;

//   AcceptedOrder({
//     required this.id,
//     required this.userId,
//     required this.deliveryAddress,
//     required this.orderItems,
//     required this.status,
//     this.assignedRider,
//     this.assignedRiderStatus,
//     required this.totalAmount,
//     required this.paymentMethod,
//     required this.paymentStatus,
//     required this.statusTimeline,
//     required this.formattedPickupDistance,
//     required this.formattedDropDistance,
//     required this.pickupTime,
//     required this.dropTime,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory AcceptedOrder.fromJson(Map<String, dynamic> json) {
//     return AcceptedOrder(
//       id: json['_id'] ?? '',

//       userId: UserInfo.fromJson(json['userId'] ?? {}),

//       deliveryAddress:
//           DeliveryAddress.fromJson(json['deliveryAddress'] ?? {}),

//       orderItems: (json['orderItems'] as List? ?? [])
//           .map((e) => OrderItem.fromJson(e))
//           .toList(),

//       status: json['status'] ?? '',
//       assignedRider: json['assignedRider'],
//       assignedRiderStatus: json['assignedRiderStatus'],

//       totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
//       paymentMethod: json['paymentMethod'] ?? '',
//       paymentStatus: json['paymentStatus'] ?? '',

//       statusTimeline: (json['statusTimeline'] as List? ?? [])
//           .map((e) => StatusTimeline.fromJson(e))
//           .toList(),

//       formattedPickupDistance:
//           json['formattedPickupDistance']?.toString() ?? '',
//       formattedDropDistance:
//           json['formattedDropDistance']?.toString() ?? '',
//       pickupTime: json['pickupTime'] ?? '',
//       dropTime: json['dropTime'] ?? '',

//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
//           DateTime.now(),
//       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ??
//           DateTime.now(),
//     );
//   }
// }

// class UserInfo {
//   final String id;
//   final String name;
//   final String mobile;
//   final Location location;

//   UserInfo({
//     required this.id,
//     required this.name,
//     required this.mobile,
//     required this.location,
//   });

//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       mobile: json['mobile'] ?? '',
//       location: Location.fromJson(json['location'] ?? {}),
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

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       type: json['type'] ?? 'Point',
//       coordinates: (json['coordinates'] as List? ?? [])
//           .map((e) => (e as num).toDouble())
//           .toList(),
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

//   String get fullAddress =>
//       '$house, $street, $city, $state - $pincode';

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

// class OrderItem {
//   final MedicineInfo? medicineId;
//   final String name;
//   final double price;
//   final int quantity;
//   final List<String> images;
//   final String description;
//   final String id;

//   OrderItem({
//     this.medicineId,
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.images,
//     required this.description,
//     required this.id,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       medicineId: json['medicineId'] != null
//           ? MedicineInfo.fromJson(json['medicineId'])
//           : null,
//       name: json['name'] ?? '',
//       price: (json['price'] as num?)?.toDouble() ?? 0,
//       quantity: json['quantity'] ?? 1,
//       images: (json['images'] as List? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//       description: json['description'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
// }

// class MedicineInfo {
//   final String id;
//   final PharmacyInfo pharmacyId;
//   final String name;
//   final List<String> images;
//   final double mrp;
//   final String description;

//   MedicineInfo({
//     required this.id,
//     required this.pharmacyId,
//     required this.name,
//     required this.images,
//     required this.mrp,
//     required this.description,
//   });

//   factory MedicineInfo.fromJson(Map<String, dynamic> json) {
//     return MedicineInfo(
//       id: json['_id'] ?? '',
//       pharmacyId:
//           PharmacyInfo.fromJson(json['pharmacyId'] ?? {}),
//       name: json['name'] ?? '',
//       images: (json['images'] as List? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//       mrp: (json['mrp'] as num?)?.toDouble() ?? 0,
//       description: json['description'] ?? '',
//     );
//   }
// }

// class PharmacyInfo {
//   final String id;
//   final String name;
//   final double latitude;
//   final double longitude;
//   final String vendorPhone;
//   final String address;

//   PharmacyInfo({
//     required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     required this.vendorPhone,
//     required this.address,
//   });

//   factory PharmacyInfo.fromJson(Map<String, dynamic> json) {
//     return PharmacyInfo(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
//       longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
//       vendorPhone: json['vendorPhone'] ?? '',
//       address: json['address'] ?? '',
//     );
//   }
// }

// class StatusTimeline {
//   final String status;
//   final String message;
//   final DateTime timestamp;
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
//       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ??
//           DateTime.now(),
//       id: json['_id'] ?? '',
//     );
//   }
// }





















class RiderOrderResponse {
  final AcceptedOrder acceptedOrder;

  RiderOrderResponse({required this.acceptedOrder});

  factory RiderOrderResponse.fromJson(Map<String, dynamic> json) {
    return RiderOrderResponse(
      acceptedOrder: AcceptedOrder.fromJson(json['acceptedOrder'] ?? {}),
    );
  }
}

class AcceptedOrder {
  final String id;
  final UserInfo userId;
  final DeliveryAddress deliveryAddress;
  final List<OrderItem> orderItems;

  final String status;
  final String? assignedRider;
  final String? assignedRiderStatus;

  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;

  final List<StatusTimeline> statusTimeline;
  final List<PharmacyResponse> pharmacyResponses; // Added this field

  final String formattedPickupDistance;
  final String formattedDropDistance;
  final String pickupTime;
  final String dropTime;

  final DateTime createdAt;
  final DateTime updatedAt;

  AcceptedOrder({
    required this.id,
    required this.userId,
    required this.deliveryAddress,
    required this.orderItems,
    required this.status,
    this.assignedRider,
    this.assignedRiderStatus,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.statusTimeline,
    required this.pharmacyResponses, // Added this parameter
    required this.formattedPickupDistance,
    required this.formattedDropDistance,
    required this.pickupTime,
    required this.dropTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AcceptedOrder.fromJson(Map<String, dynamic> json) {
    return AcceptedOrder(
      id: json['_id'] ?? '',
      userId: UserInfo.fromJson(json['userId'] ?? {}),
      deliveryAddress: DeliveryAddress.fromJson(json['deliveryAddress'] ?? {}),
      orderItems: (json['orderItems'] as List? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
      assignedRider: json['assignedRider'],
      assignedRiderStatus: json['assignedRiderStatus'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      statusTimeline: (json['statusTimeline'] as List? ?? [])
          .map((e) => StatusTimeline.fromJson(e))
          .toList(),
      pharmacyResponses: (json['pharmacyResponses'] as List? ?? [])
          .map((e) => PharmacyResponse.fromJson(e))
          .toList(),
      formattedPickupDistance: json['formattedPickupDistance']?.toString() ?? '',
      formattedDropDistance: json['formattedDropDistance']?.toString() ?? '',
      pickupTime: json['pickupTime'] ?? '',
      dropTime: json['dropTime'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class PharmacyResponse {
  final String pharmacyId;
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
      pharmacyId: json['pharmacyId'] ?? '',
      status: json['status'] ?? '',
      respondedAt: DateTime.tryParse(json['respondedAt'] ?? '') ?? DateTime.now(),
      id: json['_id'] ?? '',
    );
  }
}

class UserInfo {
  final String id;
  final String name;
  final String mobile;
  final Location location;

  UserInfo({
    required this.id,
    required this.name,
    required this.mobile,
    required this.location,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
    );
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
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
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

  String get fullAddress => '$house, $street, $city, $state - $pincode';

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

class OrderItem {
  final MedicineInfo? medicineId;
  final String name;
  final double price;
  final int quantity;
  final List<String> images;
  final String description;
  final String id;

  OrderItem({
    this.medicineId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.images,
    required this.description,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      medicineId: json['medicineId'] != null
          ? MedicineInfo.fromJson(json['medicineId'])
          : null,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: json['quantity'] ?? 1,
      images: (json['images'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      description: json['description'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

class MedicineInfo {
  final String id;
  final PharmacyInfo pharmacyId;
  final String name;
  final List<String> images;
  final double mrp;
  final String description;

  MedicineInfo({
    required this.id,
    required this.pharmacyId,
    required this.name,
    required this.images,
    required this.mrp,
    required this.description,
  });

  factory MedicineInfo.fromJson(Map<String, dynamic> json) {
    return MedicineInfo(
      id: json['_id'] ?? '',
      pharmacyId: PharmacyInfo.fromJson(json['pharmacyId'] ?? {}),
      name: json['name'] ?? '',
      images: (json['images'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0,
      description: json['description'] ?? '',
    );
  }
}

class PharmacyInfo {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String vendorPhone;
  final String address;

  PharmacyInfo({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.vendorPhone,
    required this.address,
  });

  factory PharmacyInfo.fromJson(Map<String, dynamic> json) {
    return PharmacyInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      vendorPhone: json['vendorPhone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

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
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      id: json['_id'] ?? '',
    );
  }
}

// Updated PendingPharmacy model with status field
class PendingPharmacy {
  final String pharmacyId;
  final String pharmacyName;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String status; // Added status field from pharmacyResponses

  PendingPharmacy({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  // Helper to create PendingPharmacy from order data
  static List<PendingPharmacy> fromOrder(AcceptedOrder order) {
    final List<PendingPharmacy> pharmacies = [];
    
    // Group order items by pharmacy
    final Map<String, PharmacyInfo> pharmacyMap = {};
    for (var item in order.orderItems) {
      if (item.medicineId != null) {
        final pharmacyId = item.medicineId!.pharmacyId.id;
        pharmacyMap[pharmacyId] = item.medicineId!.pharmacyId;
      }
    }
    
    // Match with pharmacyResponses to get status
    for (var response in order.pharmacyResponses) {
      final pharmacyInfo = pharmacyMap[response.pharmacyId];
      if (pharmacyInfo != null) {
        pharmacies.add(PendingPharmacy(
          pharmacyId: response.pharmacyId,
          pharmacyName: pharmacyInfo.name,
          address: pharmacyInfo.address,
          phone: pharmacyInfo.vendorPhone,
          latitude: pharmacyInfo.latitude,
          longitude: pharmacyInfo.longitude,
          status: response.status,
        ));
      }
    }
    
    return pharmacies;
  }
}