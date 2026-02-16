// // // order_history_models.dart

// // class OrderHistoryResponse {
// //   final List<OrderModel> previousOrders;
// //   final List<OrderModel> activeOrders;

// //   OrderHistoryResponse({
// //     this.previousOrders = const [],
// //     this.activeOrders = const [],
// //   });

// //   factory OrderHistoryResponse.fromPreviousOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       previousOrders: (json['previousOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromActiveOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       activeOrders: (json['activeOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }
// // }

// // class OrderModel {
// //   final String id;
// //   final UserModel userId;
// //   final DeliveryAddressModel deliveryAddress;
// //   final List<OrderItemModel> orderItems;
// //   final List<StatusTimelineModel> statusTimeline;
// //   final double totalAmount;
// //   final String notes;
// //   final String voiceNoteUrl;
// //   final String paymentMethod;
// //   final String status;
// //   final String assignedRider;
// //   final String assignedRiderStatus;
// //   final DateTime createdAt;
// //   final DateTime updatedAt;

// //   OrderModel({
// //     required this.id,
// //     required this.userId,
// //     required this.deliveryAddress,
// //     required this.orderItems,
// //     required this.statusTimeline,
// //     required this.totalAmount,
// //     required this.notes,
// //     required this.voiceNoteUrl,
// //     required this.paymentMethod,
// //     required this.status,
// //     required this.assignedRider,
// //     required this.assignedRiderStatus,
// //     required this.createdAt,
// //     required this.updatedAt,
// //   });

// //   factory OrderModel.fromJson(Map<String, dynamic> json) {
// //     return OrderModel(
// //       id: json['_id'] ?? '',
// //       userId: UserModel.fromJson(json['userId'] ?? {}),
// //       deliveryAddress: DeliveryAddressModel.fromJson(json['deliveryAddress'] ?? {}),
// //       orderItems: (json['orderItems'] as List?)
// //           ?.map((item) => OrderItemModel.fromJson(item))
// //           .toList() ?? [],
// //       statusTimeline: (json['statusTimeline'] as List?)
// //           ?.map((item) => StatusTimelineModel.fromJson(item))
// //           .toList() ?? [],
// //       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
// //       notes: json['notes'] ?? '',
// //       voiceNoteUrl: json['voiceNoteUrl'] ?? '',
// //       paymentMethod: json['paymentMethod'] ?? '',
// //       status: json['status'] ?? '',
// //       assignedRider: json['assignedRider'] ?? '',
// //       assignedRiderStatus: json['assignedRiderStatus'] ?? '',
// //       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
// //       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'userId': userId.toJson(),
// //       'deliveryAddress': deliveryAddress.toJson(),
// //       'orderItems': orderItems.map((item) => item.toJson()).toList(),
// //       'statusTimeline': statusTimeline.map((item) => item.toJson()).toList(),
// //       'totalAmount': totalAmount,
// //       'notes': notes,
// //       'voiceNoteUrl': voiceNoteUrl,
// //       'paymentMethod': paymentMethod,
// //       'status': status,
// //       'assignedRider': assignedRider,
// //       'assignedRiderStatus': assignedRiderStatus,
// //       'createdAt': createdAt.toIso8601String(),
// //       'updatedAt': updatedAt.toIso8601String(),
// //     };
// //   }
// // }

// // class UserModel {
// //   final String id;
// //   final String name;
// //   final String mobile;
// //   final LocationModel location;

// //   UserModel({
// //     required this.id,
// //     required this.name,
// //     required this.mobile,
// //     required this.location,
// //   });

// //   factory UserModel.fromJson(Map<String, dynamic> json) {
// //     return UserModel(
// //       id: json['_id'] ?? '',
// //       name: json['name'] ?? '',
// //       mobile: json['mobile'] ?? '',
// //       location: LocationModel.fromJson(json['location'] ?? {}),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'name': name,
// //       'mobile': mobile,
// //       'location': location.toJson(),
// //     };
// //   }
// // }

// // class LocationModel {
// //   final String type;
// //   final List<double> coordinates;

// //   LocationModel({
// //     required this.type,
// //     required this.coordinates,
// //   });

// //   // factory LocationModel.fromJson(Map<String, dynamic> json) {
// //   //   return LocationModel(
// //   //     type: json['type'] ?? 'Point',
// //   //     coordinates: (json['coordinates'] as List?)
// //   //         ?.map((coord) => coord.toDouble())
// //   //         .toList() ?? [],
// //   //   );
// //   // }

// //   factory LocationModel.fromJson(Map<String, dynamic> json) {
// //   return LocationModel(
// //     type: json['type'] ?? 'Point',
// //     coordinates: (json['coordinates'] as List?)
// //             ?.map((coord) => double.tryParse(coord.toString()) ?? 0.0)
// //             .toList() 
// //         ?? [],
// //   );
// // }


// //   Map<String, dynamic> toJson() {
// //     return {
// //       'type': type,
// //       'coordinates': coordinates,
// //     };
// //   }
// // }

// // class DeliveryAddressModel {
// //   final String house;
// //   final String street;
// //   final String city;
// //   final String state;
// //   final String pincode;
// //   final String country;

// //   DeliveryAddressModel({
// //     required this.house,
// //     required this.street,
// //     required this.city,
// //     required this.state,
// //     required this.pincode,
// //     required this.country,
// //   });

// //   factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
// //     return DeliveryAddressModel(
// //       house: json['house'] ?? '',
// //       street: json['street'] ?? '',
// //       city: json['city'] ?? '',
// //       state: json['state'] ?? '',
// //       pincode: json['pincode'] ?? '',
// //       country: json['country'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'house': house,
// //       'street': street,
// //       'city': city,
// //       'state': state,
// //       'pincode': pincode,
// //       'country': country,
// //     };
// //   }

// //   String get fullAddress => '$house, $street, $city, $state $pincode';
// // }

// // class OrderItemModel {
// //   final String? medicineId;
// //   final String name;
// //   final int quantity;
// //   final String id;

// //   OrderItemModel({
// //     this.medicineId,
// //     required this.name,
// //     required this.quantity,
// //     required this.id,
// //   });

// //   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
// //     return OrderItemModel(
// //       medicineId: json['medicineId'],
// //       name: json['name'] ?? '',
// //       quantity: json['quantity'] ?? 0,
// //       id: json['_id'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'medicineId': medicineId,
// //       'name': name,
// //       'quantity': quantity,
// //       '_id': id,
// //     };
// //   }
// // }

// // class StatusTimelineModel {
// //   final String status;
// //   final String message;
// //   final DateTime timestamp;
// //   final String id;

// //   StatusTimelineModel({
// //     required this.status,
// //     required this.message,
// //     required this.timestamp,
// //     required this.id,
// //   });

// //   factory StatusTimelineModel.fromJson(Map<String, dynamic> json) {
// //     return StatusTimelineModel(
// //       status: json['status'] ?? '',
// //       message: json['message'] ?? '',
// //       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
// //       id: json['_id'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'status': status,
// //       'message': message,
// //       'timestamp': timestamp.toIso8601String(),
// //       '_id': id,
// //     };
// //   }
// // }
















// // order_history_models.dart

// // class OrderHistoryResponse {
// //   final List<OrderModel> previousOrders;
// //   final List<OrderModel> activeOrders;
// //   final List<NewOrderModel> newOrders;

// //   OrderHistoryResponse({
// //     this.previousOrders = const [],
// //     this.activeOrders = const [],
// //     this.newOrders = const [],
// //   });

// //   factory OrderHistoryResponse.fromPreviousOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       previousOrders: (json['previousOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromActiveOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       activeOrders: (json['activeOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromNewOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       newOrders: (json['newOrders'] as List?)
// //           ?.map((item) => NewOrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }
// // }

// // class NewOrderModel {
// //   final OrderModel order;
// //   final String pickupDistance;
// //   final String dropDistance;
// //   final String pickupTime;
// //   final String dropTime;
// //   final String estimatedEarning;
// //   final BillingDetailsModel billingDetails;

// //   NewOrderModel({
// //     required this.order,
// //     required this.pickupDistance,
// //     required this.dropDistance,
// //     required this.pickupTime,
// //     required this.dropTime,
// //     required this.estimatedEarning,
// //     required this.billingDetails,
// //   });

// //   factory NewOrderModel.fromJson(Map<String, dynamic> json) {
// //     return NewOrderModel(
// //       order: OrderModel.fromJson(json['order'] ?? {}),
// //       pickupDistance: json['pickupDistance'] ?? '',
// //       dropDistance: json['dropDistance'] ?? '',
// //       pickupTime: json['pickupTime'] ?? '',
// //       dropTime: json['dropTime'] ?? '',
// //       estimatedEarning: json['estimatedEarning'] ?? '',
// //       billingDetails: BillingDetailsModel.fromJson(json['billingDetails'] ?? {}),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'order': order.toJson(),
// //       'pickupDistance': pickupDistance,
// //       'dropDistance': dropDistance,
// //       'pickupTime': pickupTime,
// //       'dropTime': dropTime,
// //       'estimatedEarning': estimatedEarning,
// //       'billingDetails': billingDetails.toJson(),
// //     };
// //   }
// // }

// // class BillingDetailsModel {
// //   final int totalItems;
// //   final String subTotal;
// //   final String platformFee;
// //   final String deliveryCharge;
// //   final String totalPaid;

// //   BillingDetailsModel({
// //     required this.totalItems,
// //     required this.subTotal,
// //     required this.platformFee,
// //     required this.deliveryCharge,
// //     required this.totalPaid,
// //   });

// //   factory BillingDetailsModel.fromJson(Map<String, dynamic> json) {
// //     return BillingDetailsModel(
// //       totalItems: json['totalItems'] ?? 0,
// //       subTotal: json['subTotal'] ?? '',
// //       platformFee: json['platformFee'] ?? '',
// //       deliveryCharge: json['deliveryCharge'] ?? '',
// //       totalPaid: json['totalPaid'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'totalItems': totalItems,
// //       'subTotal': subTotal,
// //       'platformFee': platformFee,
// //       'deliveryCharge': deliveryCharge,
// //       'totalPaid': totalPaid,
// //     };
// //   }
// // }

// // class OrderModel {
// //   final String id;
// //   final UserModel userId;
// //   final DeliveryAddressModel deliveryAddress;
// //   final List<OrderItemModel> orderItems;
// //   final List<StatusTimelineModel> statusTimeline;
// //   final double totalAmount;
// //   final String notes;
// //   final String voiceNoteUrl;
// //   final String paymentMethod;
// //   final String status;
// //   final String assignedRider;
// //   final String assignedRiderStatus;
// //   final DateTime createdAt;
// //   final DateTime updatedAt;
// //   final int? v; 
  

// //   OrderModel({
// //     required this.id,
// //     required this.userId,
// //     required this.deliveryAddress,
// //     required this.orderItems,
// //     required this.statusTimeline,
// //     required this.totalAmount,
// //     required this.notes,
// //     required this.voiceNoteUrl,
// //     required this.paymentMethod,
// //     required this.status,
// //     required this.assignedRider,
// //     required this.assignedRiderStatus,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     this.v,
// //   });

// //   factory OrderModel.fromJson(Map<String, dynamic> json) {
// //     return OrderModel(
// //       id: json['_id'] ?? '',
// //       userId: UserModel.fromJson(json['userId'] ?? {}),
// //       deliveryAddress: DeliveryAddressModel.fromJson(json['deliveryAddress'] ?? {}),
// //       orderItems: (json['orderItems'] as List?)
// //           ?.map((item) => OrderItemModel.fromJson(item))
// //           .toList() ?? [],
// //       statusTimeline: (json['statusTimeline'] as List?)
// //           ?.map((item) => StatusTimelineModel.fromJson(item))
// //           .toList() ?? [],
// //       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
// //       notes: json['notes'] ?? '',
// //       voiceNoteUrl: json['voiceNoteUrl'] ?? '',
// //       paymentMethod: json['paymentMethod'] ?? '',
// //       status: json['status'] ?? '',
// //       assignedRider: json['assignedRider'] ?? '',
// //       assignedRiderStatus: json['assignedRiderStatus'] ?? '',
// //       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
// //       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
// //       v: json['__v'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'userId': userId.toJson(),
// //       'deliveryAddress': deliveryAddress.toJson(),
// //       'orderItems': orderItems.map((item) => item.toJson()).toList(),
// //       'statusTimeline': statusTimeline.map((item) => item.toJson()).toList(),
// //       'totalAmount': totalAmount,
// //       'notes': notes,
// //       'voiceNoteUrl': voiceNoteUrl,
// //       'paymentMethod': paymentMethod,
// //       'status': status,
// //       'assignedRider': assignedRider,
// //       'assignedRiderStatus': assignedRiderStatus,
// //       'createdAt': createdAt.toIso8601String(),
// //       'updatedAt': updatedAt.toIso8601String(),
// //       if (v != null) '__v': v,
// //     };
// //   }
// // }

// // class UserModel {
// //   final String id;
// //   final String name;
// //   final String mobile;
// //   final LocationModel location;

// //   UserModel({
// //     required this.id,
// //     required this.name,
// //     required this.mobile,
// //     required this.location,
// //   });

// //   factory UserModel.fromJson(Map<String, dynamic> json) {
// //     return UserModel(
// //       id: json['_id'] ?? '',
// //       name: json['name'] ?? '',
// //       mobile: json['mobile'] ?? '',
// //       location: LocationModel.fromJson(json['location'] ?? {}),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'name': name,
// //       'mobile': mobile,
// //       'location': location.toJson(),
// //     };
// //   }
// // }

// // class LocationModel {
// //   final String type;
// //   final List<double> coordinates;

// //   LocationModel({
// //     required this.type,
// //     required this.coordinates,
// //   });

// //   factory LocationModel.fromJson(Map<String, dynamic> json) {
// //     return LocationModel(
// //       type: json['type'] ?? 'Point',
// //       coordinates: (json['coordinates'] as List?)
// //               ?.map((coord) => double.tryParse(coord.toString()) ?? 0.0)
// //               .toList() 
// //           ?? [],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'type': type,
// //       'coordinates': coordinates,
// //     };
// //   }
// // }

// // class DeliveryAddressModel {
// //   final String house;
// //   final String street;
// //   final String city;
// //   final String state;
// //   final String pincode;
// //   final String country;

// //   DeliveryAddressModel({
// //     required this.house,
// //     required this.street,
// //     required this.city,
// //     required this.state,
// //     required this.pincode,
// //     required this.country,
// //   });

// //   factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
// //     return DeliveryAddressModel(
// //       house: json['house'] ?? '',
// //       street: json['street'] ?? '',
// //       city: json['city'] ?? '',
// //       state: json['state'] ?? '',
// //       pincode: json['pincode'] ?? '',
// //       country: json['country'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'house': house,
// //       'street': street,
// //       'city': city,
// //       'state': state,
// //       'pincode': pincode,
// //       'country': country,
// //     };
// //   }

// //   String get fullAddress => '$house, $street, $city, $state $pincode';
// // }

// // class OrderItemModel {
// //   final MedicineModel? medicineId;
// //   final String name;
// //   final int quantity;
// //   final String id;

// //   OrderItemModel({
// //     this.medicineId,
// //     required this.name,
// //     required this.quantity,
// //     required this.id,
// //   });

// //   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
// //     return OrderItemModel(
// //       medicineId: json['medicineId'] != null 
// //           ? MedicineModel.fromJson(json['medicineId'])
// //           : null,
// //       name: json['name'] ?? '',
// //       quantity: json['quantity'] ?? 0,
// //       id: json['_id'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'medicineId': medicineId?.toJson(),
// //       'name': name,
// //       'quantity': quantity,
// //       '_id': id,
// //     };
// //   }
// // }

// // class MedicineModel {
// //   final String id;
// //   final PharmacyModel pharmacyId;
// //   final String name;
// //   final List<String> images;
// //   final double mrp;
// //   final String description;

// //   MedicineModel({
// //     required this.id,
// //     required this.pharmacyId,
// //     required this.name,
// //     required this.images,
// //     required this.mrp,
// //     required this.description,
// //   });

// //   factory MedicineModel.fromJson(Map<String, dynamic> json) {
// //     return MedicineModel(
// //       id: json['_id'] ?? '',
// //       pharmacyId: PharmacyModel.fromJson(json['pharmacyId'] ?? {}),
// //       name: json['name'] ?? '',
// //       images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
// //       mrp: (json['mrp'] ?? 0).toDouble(),
// //       description: json['description'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'pharmacyId': pharmacyId.toJson(),
// //       'name': name,
// //       'images': images,
// //       'mrp': mrp,
// //       'description': description,
// //     };
// //   }
// // }

// // class PharmacyModel {
// //   final String id;
// //   final String name;
// //   final double latitude;
// //   final double longitude;

// //   PharmacyModel({
// //     required this.id,
// //     required this.name,
// //     required this.latitude,
// //     required this.longitude,
// //   });

// //   factory PharmacyModel.fromJson(Map<String, dynamic> json) {
// //     return PharmacyModel(
// //       id: json['_id'] ?? '',
// //       name: json['name'] ?? '',
// //       latitude: (json['latitude'] ?? 0).toDouble(),
// //       longitude: (json['longitude'] ?? 0).toDouble(),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'name': name,
// //       'latitude': latitude,
// //       'longitude': longitude,
// //     };
// //   }
// // }

// // class StatusTimelineModel {
// //   final String status;
// //   final String message;
// //   final DateTime timestamp;
// //   final String id;

// //   StatusTimelineModel({
// //     required this.status,
// //     required this.message,
// //     required this.timestamp,
// //     required this.id,
// //   });

// //   factory StatusTimelineModel.fromJson(Map<String, dynamic> json) {
// //     return StatusTimelineModel(
// //       status: json['status'] ?? '',
// //       message: json['message'] ?? '',
// //       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
// //       id: json['_id'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'status': status,
// //       'message': message,
// //       'timestamp': timestamp.toIso8601String(),
// //       '_id': id,
// //     };
// //   }
// // }





















// // class OrderHistoryResponse {
// //   final List<OrderModel> previousOrders;
// //   final List<OrderModel> activeOrders;
// //   final List<NewOrderModel> newOrders;

// //   OrderHistoryResponse({
// //     this.previousOrders = const [],
// //     this.activeOrders = const [],
// //     this.newOrders = const [],
// //   });

// //   factory OrderHistoryResponse.fromPreviousOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       previousOrders: (json['previousOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromActiveOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       activeOrders: (json['activeOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromNewOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       newOrders: (json['newOrders'] as List?)
// //           ?.map((item) => NewOrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }
// // }









// // class OrderHistoryResponse {
// //   final List<OrderModel> previousOrders;
// //   final List<OrderModel> activeOrders;
// //   final List<NewOrderModel> newOrders;

// //   OrderHistoryResponse({
// //     this.previousOrders = const [],
// //     this.activeOrders = const [],
// //     this.newOrders = const [],
// //   });

// //   factory OrderHistoryResponse.fromPreviousOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       // Changed from 'previousOrders' to 'completedOrders' to match API response
// //       previousOrders: (json['completedOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromActiveOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       activeOrders: (json['activeOrders'] as List?)
// //           ?.map((item) => OrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }

// //   factory OrderHistoryResponse.fromNewOrdersJson(Map<String, dynamic> json) {
// //     return OrderHistoryResponse(
// //       newOrders: (json['newOrders'] as List?)
// //           ?.map((item) => NewOrderModel.fromJson(item))
// //           .toList() ?? [],
// //     );
// //   }
// // }

// // class NewOrderModel {
// //   final OrderModel order;
// //   final String pickupDistance;
// //   final String dropDistance;
// //   final String pickupTime;
// //   final String dropTime;
// //   final String estimatedEarning;
// //   final BillingDetailsModel billingDetails;

// //   NewOrderModel({
// //     required this.order,
// //     required this.pickupDistance,
// //     required this.dropDistance,
// //     required this.pickupTime,
// //     required this.dropTime,
// //     required this.estimatedEarning,
// //     required this.billingDetails,
// //   });

// //   factory NewOrderModel.fromJson(Map<String, dynamic> json) {
// //     return NewOrderModel(
// //       order: OrderModel.fromJson(json['order'] ?? {}),
// //       pickupDistance: json['pickupDistance'] ?? '',
// //       dropDistance: json['dropDistance'] ?? '',
// //       pickupTime: json['pickupTime'] ?? '',
// //       dropTime: json['dropTime'] ?? '',
// //       estimatedEarning: json['estimatedEarning'] ?? '',
// //       billingDetails: BillingDetailsModel.fromJson(json['billingDetails'] ?? {}),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'order': order.toJson(),
// //       'pickupDistance': pickupDistance,
// //       'dropDistance': dropDistance,
// //       'pickupTime': pickupTime,
// //       'dropTime': dropTime,
// //       'estimatedEarning': estimatedEarning,
// //       'billingDetails': billingDetails.toJson(),
// //     };
// //   }
// // }

// // class BillingDetailsModel {
// //   final int totalItems;
// //   final String subTotal;
// //   final String platformFee;
// //   final String deliveryCharge;
// //   final String totalPaid;

// //   BillingDetailsModel({
// //     required this.totalItems,
// //     required this.subTotal,
// //     required this.platformFee,
// //     required this.deliveryCharge,
// //     required this.totalPaid,
// //   });

// //   factory BillingDetailsModel.fromJson(Map<String, dynamic> json) {
// //     return BillingDetailsModel(
// //       totalItems: json['totalItems'] ?? 0,
// //       subTotal: json['subTotal'] ?? '',
// //       platformFee: json['platformFee'] ?? '',
// //       deliveryCharge: json['deliveryCharge'] ?? '',
// //       totalPaid: json['totalPaid'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'totalItems': totalItems,
// //       'subTotal': subTotal,
// //       'platformFee': platformFee,
// //       'deliveryCharge': deliveryCharge,
// //       'totalPaid': totalPaid,
// //     };
// //   }
// // }

// // class OrderModel {
// //   final String id;
// //   final UserModel userId;
// //   final DeliveryAddressModel deliveryAddress;
// //   final List<OrderItemModel> orderItems;
// //   final List<StatusTimelineModel> statusTimeline;
// //   final double totalAmount;
// //   final String notes;
// //   final String voiceNoteUrl;
// //   final String paymentMethod;
// //   final String status;
// //   final String assignedRider;
// //   final String assignedRiderStatus;
// //   final DateTime createdAt;
// //   final DateTime updatedAt;
// //   final int? v;
  
// //   // New fields from the JSON response
// //   final String? formattedPickupDistance;
// //   final String? formattedDropDistance;
// //   final String? pickupTime;
// //   final String? dropTime;
// //   final BillingDetailsModel? billingDetails;

// //   OrderModel({
// //     required this.id,
// //     required this.userId,
// //     required this.deliveryAddress,
// //     required this.orderItems,
// //     required this.statusTimeline,
// //     required this.totalAmount,
// //     required this.notes,
// //     required this.voiceNoteUrl,
// //     required this.paymentMethod,
// //     required this.status,
// //     required this.assignedRider,
// //     required this.assignedRiderStatus,
// //     required this.createdAt,
// //     required this.updatedAt,
// //     this.v,
// //     this.formattedPickupDistance,
// //     this.formattedDropDistance,
// //     this.pickupTime,
// //     this.dropTime,
// //     this.billingDetails,
// //   });

// //   factory OrderModel.fromJson(Map<String, dynamic> json) {
// //     return OrderModel(
// //       id: json['_id'] ?? '',
// //       userId: UserModel.fromJson(json['userId'] ?? {}),
// //       deliveryAddress: DeliveryAddressModel.fromJson(json['deliveryAddress'] ?? {}),
// //       orderItems: (json['orderItems'] as List?)
// //           ?.map((item) => OrderItemModel.fromJson(item))
// //           .toList() ?? [],
// //       statusTimeline: (json['statusTimeline'] as List?)
// //           ?.map((item) => StatusTimelineModel.fromJson(item))
// //           .toList() ?? [],
// //       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
// //       notes: json['notes'] ?? '',
// //       voiceNoteUrl: json['voiceNoteUrl'] ?? '',
// //       paymentMethod: json['paymentMethod'] ?? '',
// //       status: json['status'] ?? '',
// //       assignedRider: json['assignedRider'] ?? '',
// //       assignedRiderStatus: json['assignedRiderStatus'] ?? '',
// //       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
// //       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
// //       v: json['__v'],
// //       formattedPickupDistance: json['formattedPickupDistance'],
// //       formattedDropDistance: json['formattedDropDistance'],
// //       pickupTime: json['pickupTime'],
// //       dropTime: json['dropTime'],
// //       billingDetails: json['billingDetails'] != null 
// //           ? BillingDetailsModel.fromJson(json['billingDetails']) 
// //           : null,
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'userId': userId.toJson(),
// //       'deliveryAddress': deliveryAddress.toJson(),
// //       'orderItems': orderItems.map((item) => item.toJson()).toList(),
// //       'statusTimeline': statusTimeline.map((item) => item.toJson()).toList(),
// //       'totalAmount': totalAmount,
// //       'notes': notes,
// //       'voiceNoteUrl': voiceNoteUrl,
// //       'paymentMethod': paymentMethod,
// //       'status': status,
// //       'assignedRider': assignedRider,
// //       'assignedRiderStatus': assignedRiderStatus,
// //       'createdAt': createdAt.toIso8601String(),
// //       'updatedAt': updatedAt.toIso8601String(),
// //       if (v != null) '__v': v,
// //       if (formattedPickupDistance != null) 'formattedPickupDistance': formattedPickupDistance,
// //       if (formattedDropDistance != null) 'formattedDropDistance': formattedDropDistance,
// //       if (pickupTime != null) 'pickupTime': pickupTime,
// //       if (dropTime != null) 'dropTime': dropTime,
// //       if (billingDetails != null) 'billingDetails': billingDetails!.toJson(),
// //     };
// //   }
// // }

// // class UserModel {
// //   final String id;
// //   final String name;
// //   final String mobile;
// //   final LocationModel location;

// //   UserModel({
// //     required this.id,
// //     required this.name,
// //     required this.mobile,
// //     required this.location,
// //   });

// //   factory UserModel.fromJson(Map<String, dynamic> json) {
// //     return UserModel(
// //       id: json['_id'] ?? '',
// //       name: json['name'] ?? '',
// //       mobile: json['mobile'] ?? '',
// //       location: LocationModel.fromJson(json['location'] ?? {}),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'name': name,
// //       'mobile': mobile,
// //       'location': location.toJson(),
// //     };
// //   }
// // }

// // class LocationModel {
// //   final String type;
// //   final List<double> coordinates;

// //   LocationModel({
// //     required this.type,
// //     required this.coordinates,
// //   });

// //   factory LocationModel.fromJson(Map<String, dynamic> json) {
// //     return LocationModel(
// //       type: json['type'] ?? 'Point',
// //       coordinates: (json['coordinates'] as List?)
// //               ?.map((coord) => double.tryParse(coord.toString()) ?? 0.0)
// //               .toList() 
// //           ?? [],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'type': type,
// //       'coordinates': coordinates,
// //     };
// //   }
// // }

// // class DeliveryAddressModel {
// //   final String house;
// //   final String street;
// //   final String city;
// //   final String state;
// //   final String pincode;
// //   final String country;

// //   DeliveryAddressModel({
// //     required this.house,
// //     required this.street,
// //     required this.city,
// //     required this.state,
// //     required this.pincode,
// //     required this.country,
// //   });

// //   factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
// //     return DeliveryAddressModel(
// //       house: json['house'] ?? '',
// //       street: json['street'] ?? '',
// //       city: json['city'] ?? '',
// //       state: json['state'] ?? '',
// //       pincode: json['pincode'] ?? '',
// //       country: json['country'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'house': house,
// //       'street': street,
// //       'city': city,
// //       'state': state,
// //       'pincode': pincode,
// //       'country': country,
// //     };
// //   }

// //   String get fullAddress => '$house, $street, $city, $state $pincode';
// // }

// // class OrderItemModel {
// //   final MedicineModel? medicineId;
// //   final String name;
// //   final int quantity;
// //   final String id;

// //   OrderItemModel({
// //     this.medicineId,
// //     required this.name,
// //     required this.quantity,
// //     required this.id,
// //   });

// //   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
// //     return OrderItemModel(
// //       medicineId: json['medicineId'] != null 
// //           ? MedicineModel.fromJson(json['medicineId'])
// //           : null,
// //       name: json['name'] ?? '',
// //       quantity: json['quantity'] ?? 0,
// //       id: json['_id'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'medicineId': medicineId?.toJson(),
// //       'name': name,
// //       'quantity': quantity,
// //       '_id': id,
// //     };
// //   }
// // }

// // class MedicineModel {
// //   final String id;
// //   final PharmacyModel pharmacyId;
// //   final String name;
// //   final List<String> images;
// //   final double mrp;
// //   final String description;

// //   MedicineModel({
// //     required this.id,
// //     required this.pharmacyId,
// //     required this.name,
// //     required this.images,
// //     required this.mrp,
// //     required this.description,
// //   });

// //   factory MedicineModel.fromJson(Map<String, dynamic> json) {
// //     return MedicineModel(
// //       id: json['_id'] ?? '',
// //       pharmacyId: PharmacyModel.fromJson(json['pharmacyId'] ?? {}),
// //       name: json['name'] ?? '',
// //       images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
// //       mrp: (json['mrp'] ?? 0).toDouble(),
// //       description: json['description'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'pharmacyId': pharmacyId.toJson(),
// //       'name': name,
// //       'images': images,
// //       'mrp': mrp,
// //       'description': description,
// //     };
// //   }
// // }

// // class PharmacyModel {
// //   final String id;
// //   final String name;
// //   final double latitude;
// //   final double longitude;

// //   PharmacyModel({
// //     required this.id,
// //     required this.name,
// //     required this.latitude,
// //     required this.longitude,
// //   });

// //   factory PharmacyModel.fromJson(Map<String, dynamic> json) {
// //     return PharmacyModel(
// //       id: json['_id'] ?? '',
// //       name: json['name'] ?? '',
// //       latitude: (json['latitude'] ?? 0).toDouble(),
// //       longitude: (json['longitude'] ?? 0).toDouble(),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'name': name,
// //       'latitude': latitude,
// //       'longitude': longitude,
// //     };
// //   }
// // }

// // class StatusTimelineModel {
// //   final String status;
// //   final String message;
// //   final DateTime timestamp;
// //   final String id;

// //   StatusTimelineModel({
// //     required this.status,
// //     required this.message,
// //     required this.timestamp,
// //     required this.id,
// //   });

// //   factory StatusTimelineModel.fromJson(Map<String, dynamic> json) {
// //     return StatusTimelineModel(
// //       status: json['status'] ?? '',
// //       message: json['message'] ?? '',
// //       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
// //       id: json['_id'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'status': status,
// //       'message': message,
// //       'timestamp': timestamp.toIso8601String(),
// //       '_id': id,
// //     };
// //   }
// // }













// class OrderHistoryResponse {
//   final List<OrderModel> previousOrders;
//   final List<OrderModel> activeOrders;
//   final List<NewOrderModel> newOrders;

//   OrderHistoryResponse({
//     this.previousOrders = const [],
//     this.activeOrders = const [],
//     this.newOrders = const [],
//   });

//   factory OrderHistoryResponse.fromPreviousOrdersJson(Map<String, dynamic> json) {
//     return OrderHistoryResponse(
//       previousOrders: (json['completedOrders'] as List?)
//           ?.map((item) => OrderModel.fromJson(item))
//           .toList() ?? [],
//     );
//   }

//   factory OrderHistoryResponse.fromActiveOrdersJson(Map<String, dynamic> json) {
//     return OrderHistoryResponse(
//       activeOrders: (json['activeOrders'] as List?)
//           ?.map((item) => OrderModel.fromJson(item))
//           .toList() ?? [],
//     );
//   }

//   factory OrderHistoryResponse.fromNewOrdersJson(Map<String, dynamic> json) {
//     return OrderHistoryResponse(
//       newOrders: (json['newOrders'] as List?)
//           ?.map((item) => NewOrderModel.fromJson(item))
//           .toList() ?? [],
//     );
//   }
// }

// class NewOrderModel {
//   final OrderModel order;
//   final String pickupDistance;
//   final String dropDistance;
//   final String pickupTime;
//   final String dropTime;
//   final String estimatedEarning;
//   final BillingDetailsModel billingDetails;

//   NewOrderModel({
//     required this.order,
//     required this.pickupDistance,
//     required this.dropDistance,
//     required this.pickupTime,
//     required this.dropTime,
//     required this.estimatedEarning,
//     required this.billingDetails,
//   });

//   factory NewOrderModel.fromJson(Map<String, dynamic> json) {
//     return NewOrderModel(
//       order: OrderModel.fromJson(json['order'] ?? {}),
//       pickupDistance: json['pickupDistance'] ?? '',
//       dropDistance: json['dropDistance'] ?? '',
//       pickupTime: json['pickupTime'] ?? '',
//       dropTime: json['dropTime'] ?? '',
//       estimatedEarning: json['estimatedEarning'] ?? '',
//       billingDetails: BillingDetailsModel.fromJson(json['billingDetails'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'order': order.toJson(),
//       'pickupDistance': pickupDistance,
//       'dropDistance': dropDistance,
//       'pickupTime': pickupTime,
//       'dropTime': dropTime,
//       'estimatedEarning': estimatedEarning,
//       'billingDetails': billingDetails.toJson(),
//     };
//   }
// }

// class BillingDetailsModel {
//   final int totalItems;
//   final String subTotal;
//   final String platformFee;
//   final String deliveryCharge;
//   final String totalPaid;

//   BillingDetailsModel({
//     required this.totalItems,
//     required this.subTotal,
//     required this.platformFee,
//     required this.deliveryCharge,
//     required this.totalPaid,
//   });

//   factory BillingDetailsModel.fromJson(Map<String, dynamic> json) {
//     return BillingDetailsModel(
//       totalItems: json['totalItems'] ?? 0,
//       subTotal: json['subTotal'] ?? '',
//       platformFee: json['platformFee'] ?? '',
//       deliveryCharge: json['deliveryCharge'] ?? '',
//       totalPaid: json['totalPaid'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'totalItems': totalItems,
//       'subTotal': subTotal,
//       'platformFee': platformFee,
//       'deliveryCharge': deliveryCharge,
//       'totalPaid': totalPaid,
//     };
//   }
// }

// class OrderModel {
//   final String id;
//   final UserModel userId;
//   final DeliveryAddressModel deliveryAddress;
//   final List<OrderItemModel> orderItems;
//   final List<StatusTimelineModel> statusTimeline;
//   final double totalAmount;
//   final String notes;
//   final String voiceNoteUrl;
//   final String paymentMethod;
//   final String status;
//   final String assignedRider;
//   final String assignedRiderStatus;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int? v;
  
//   // Additional fields from API response
//   final String? formattedPickupDistance;
//   final String? formattedDropDistance;
//   final String? pickupTime;
//   final String? dropTime;
//   final BillingDetailsModel? billingDetails;
//   final String? transactionId;
//   final String paymentStatus;
//   final String? razorpayOrder;
//   final bool isReordered;
//   final double deliveryCharge;
//   final double platformCharge;
//   final double codAmountReceived;
//   final String? couponCode;
//   final double discountAmount;
//   final bool isPrescriptionOrder;
//   final List<String> deliveryProof;
//   final List<String> beforePickupProof;

//   OrderModel({
//     required this.id,
//     required this.userId,
//     required this.deliveryAddress,
//     required this.orderItems,
//     required this.statusTimeline,
//     required this.totalAmount,
//     required this.notes,
//     required this.voiceNoteUrl,
//     required this.paymentMethod,
//     required this.status,
//     required this.assignedRider,
//     required this.assignedRiderStatus,
//     required this.createdAt,
//     required this.updatedAt,
//     this.v,
//     this.formattedPickupDistance,
//     this.formattedDropDistance,
//     this.pickupTime,
//     this.dropTime,
//     this.billingDetails,
//     this.transactionId,
//     this.paymentStatus = 'Pending',
//     this.razorpayOrder,
//     this.isReordered = false,
//     this.deliveryCharge = 0,
//     this.platformCharge = 0,
//     this.codAmountReceived = 0,
//     this.couponCode,
//     this.discountAmount = 0,
//     this.isPrescriptionOrder = false,
//     this.deliveryProof = const [],
//     this.beforePickupProof = const [],
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       id: json['_id'] ?? '',
//       userId: UserModel.fromJson(json['userId'] ?? {}),
//       deliveryAddress: DeliveryAddressModel.fromJson(json['deliveryAddress'] ?? {}),
//       orderItems: (json['orderItems'] as List?)
//           ?.map((item) => OrderItemModel.fromJson(item))
//           .toList() ?? [],
//       statusTimeline: (json['statusTimeline'] as List?)
//           ?.map((item) => StatusTimelineModel.fromJson(item))
//           .toList() ?? [],
//       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
//       notes: json['notes'] ?? '',
//       voiceNoteUrl: json['voiceNoteUrl'] ?? '',
//       paymentMethod: json['paymentMethod'] ?? '',
//       status: json['status'] ?? '',
//       assignedRider: json['assignedRider'] ?? '',
//       assignedRiderStatus: json['assignedRiderStatus'] ?? '',
//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
//       v: json['__v'],
//       formattedPickupDistance: json['formattedPickupDistance'],
//       formattedDropDistance: json['formattedDropDistance'],
//       pickupTime: json['pickupTime'],
//       dropTime: json['dropTime'],
//       billingDetails: json['billingDetails'] != null 
//           ? BillingDetailsModel.fromJson(json['billingDetails']) 
//           : null,
//       transactionId: json['transactionId'],
//       paymentStatus: json['paymentStatus'] ?? 'Pending',
//       razorpayOrder: json['razorpayOrder'],
//       isReordered: json['isReordered'] ?? false,
//       deliveryCharge: (json['deliveryCharge'] ?? 0).toDouble(),
//       platformCharge: (json['platformCharge'] ?? 0).toDouble(),
//       codAmountReceived: (json['codAmountReceived'] ?? 0).toDouble(),
//       couponCode: json['couponCode'],
//       discountAmount: (json['discountAmount'] ?? 0).toDouble(),
//       isPrescriptionOrder: json['isPrescriptionOrder'] ?? false,
//       deliveryProof: (json['deliveryProof'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       beforePickupProof: (json['beforePickupProof'] as List?)?.map((e) => e.toString()).toList() ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId.toJson(),
//       'deliveryAddress': deliveryAddress.toJson(),
//       'orderItems': orderItems.map((item) => item.toJson()).toList(),
//       'statusTimeline': statusTimeline.map((item) => item.toJson()).toList(),
//       'totalAmount': totalAmount,
//       'notes': notes,
//       'voiceNoteUrl': voiceNoteUrl,
//       'paymentMethod': paymentMethod,
//       'status': status,
//       'assignedRider': assignedRider,
//       'assignedRiderStatus': assignedRiderStatus,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       if (v != null) '__v': v,
//       if (formattedPickupDistance != null) 'formattedPickupDistance': formattedPickupDistance,
//       if (formattedDropDistance != null) 'formattedDropDistance': formattedDropDistance,
//       if (pickupTime != null) 'pickupTime': pickupTime,
//       if (dropTime != null) 'dropTime': dropTime,
//       if (billingDetails != null) 'billingDetails': billingDetails!.toJson(),
//       if (transactionId != null) 'transactionId': transactionId,
//       'paymentStatus': paymentStatus,
//       if (razorpayOrder != null) 'razorpayOrder': razorpayOrder,
//       'isReordered': isReordered,
//       'deliveryCharge': deliveryCharge,
//       'platformCharge': platformCharge,
//       'codAmountReceived': codAmountReceived,
//       if (couponCode != null) 'couponCode': couponCode,
//       'discountAmount': discountAmount,
//       'isPrescriptionOrder': isPrescriptionOrder,
//       'deliveryProof': deliveryProof,
//       'beforePickupProof': beforePickupProof,
//     };
//   }
// }

// class UserModel {
//   final String id;
//   final String name;
//   final String mobile;
//   final LocationModel location;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.mobile,
//     required this.location,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       mobile: json['mobile'] ?? '',
//       location: LocationModel.fromJson(json['location'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'mobile': mobile,
//       'location': location.toJson(),
//     };
//   }
// }

// class LocationModel {
//   final String type;
//   final List<double> coordinates;

//   LocationModel({
//     required this.type,
//     required this.coordinates,
//   });

//   factory LocationModel.fromJson(Map<String, dynamic> json) {
//     return LocationModel(
//       type: json['type'] ?? 'Point',
//       coordinates: (json['coordinates'] as List?)
//               ?.map((coord) => double.tryParse(coord.toString()) ?? 0.0)
//               .toList() 
//           ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': coordinates,
//     };
//   }
// }

// class DeliveryAddressModel {
//   final String house;
//   final String street;
//   final String city;
//   final String state;
//   final String pincode;
//   final String country;

//   DeliveryAddressModel({
//     required this.house,
//     required this.street,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.country,
//   });

//   factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
//     return DeliveryAddressModel(
//       house: json['house'] ?? '',
//       street: json['street'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       pincode: json['pincode'] ?? '',
//       country: json['country'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'house': house,
//       'street': street,
//       'city': city,
//       'state': state,
//       'pincode': pincode,
//       'country': country,
//     };
//   }

//   String get fullAddress => '$house, $street, $city, $state $pincode';
// }

// class OrderItemModel {
//   final MedicineModel? medicineId;
//   final String name;
//   final int quantity;
//   final String id;

//   OrderItemModel({
//     this.medicineId,
//     required this.name,
//     required this.quantity,
//     required this.id,
//   });

//   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
//     return OrderItemModel(
//       medicineId: json['medicineId'] != null 
//           ? MedicineModel.fromJson(json['medicineId'])
//           : null,
//       name: json['name'] ?? '',
//       quantity: json['quantity'] ?? 0,
//       id: json['_id'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'medicineId': medicineId?.toJson(),
//       'name': name,
//       'quantity': quantity,
//       '_id': id,
//     };
//   }
// }

// class MedicineModel {
//   final String id;
//   final PharmacyModel pharmacyId;
//   final String name;
//   final List<String> images;
//   final double mrp;
//   final String description;

//   MedicineModel({
//     required this.id,
//     required this.pharmacyId,
//     required this.name,
//     required this.images,
//     required this.mrp,
//     required this.description,
//   });

//   factory MedicineModel.fromJson(Map<String, dynamic> json) {
//     return MedicineModel(
//       id: json['_id'] ?? '',
//       pharmacyId: PharmacyModel.fromJson(json['pharmacyId'] ?? {}),
//       name: json['name'] ?? '',
//       images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       mrp: (json['mrp'] ?? 0).toDouble(),
//       description: json['description'] ?? '',
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

// class PharmacyModel {
//   final String id;
//   final String name;
//   final double latitude;
//   final double longitude;
//   final String? address;

//   PharmacyModel({
//     required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     this.address,
//   });

//   factory PharmacyModel.fromJson(Map<String, dynamic> json) {
//     return PharmacyModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       latitude: (json['latitude'] ?? 0).toDouble(),
//       longitude: (json['longitude'] ?? 0).toDouble(),
//       address: json['address'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'latitude': latitude,
//       'longitude': longitude,
//       if (address != null) 'address': address,
//     };
//   }
// }

// class StatusTimelineModel {
//   final String status;
//   final String message;
//   final DateTime timestamp;
//   final String id;

//   StatusTimelineModel({
//     required this.status,
//     required this.message,
//     required this.timestamp,
//     required this.id,
//   });

//   factory StatusTimelineModel.fromJson(Map<String, dynamic> json) {
//     return StatusTimelineModel(
//       status: json['status'] ?? '',
//       message: json['message'] ?? '',
//       timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
//       id: json['_id'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'timestamp': timestamp.toIso8601String(),
//       '_id': id,
//     };
//   }
// }














// ============================================================================
//                               SAFE PARSER HELPERS
// ============================================================================

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
  if (value is List) return value.map((e) => parser(e)).toList();
  return [];
}

Map<String, dynamic> parseMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return {};
}

// ============================================================================
//                           ORDER HISTORY RESPONSE
// ============================================================================

class OrderHistoryResponse {
  final List<OrderModel> previousOrders;
  final List<OrderModel> activeOrders;
  final List<NewOrderModel> newOrders;

  OrderHistoryResponse({
    this.previousOrders = const [],
    this.activeOrders = const [],
    this.newOrders = const [],
  });

  factory OrderHistoryResponse.fromPreviousOrdersJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      previousOrders: parseList(json['completedOrders'], 
        (e) => OrderModel.fromJson(parseMap(e)),
      ),
    );
  }

  factory OrderHistoryResponse.fromActiveOrdersJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      activeOrders: parseList(json['activeOrders'], 
        (e) => OrderModel.fromJson(parseMap(e)),
      ),
    );
  }

  factory OrderHistoryResponse.fromNewOrdersJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      newOrders: parseList(json['newOrders'], 
        (e) => NewOrderModel.fromJson(parseMap(e)),
      ),
    );
  }
}

// ============================================================================
//                               NEW ORDER MODEL
// ============================================================================

class NewOrderModel {
  final OrderModel order;
  final String pickupDistance;
  final String dropDistance;
  final String pickupTime;
  final String dropTime;
  final String estimatedEarning;
  final BillingDetailsModel billingDetails;

  NewOrderModel({
    required this.order,
    required this.pickupDistance,
    required this.dropDistance,
    required this.pickupTime,
    required this.dropTime,
    required this.estimatedEarning,
    required this.billingDetails,
  });

  factory NewOrderModel.fromJson(Map<String, dynamic> json) {
    return NewOrderModel(
      order: OrderModel.fromJson(parseMap(json['order'])),
      pickupDistance: parseString(json['pickupDistance']),
      dropDistance: parseString(json['dropDistance']),
      pickupTime: parseString(json['pickupTime']),
      dropTime: parseString(json['dropTime']),
      estimatedEarning: parseString(json['estimatedEarning']),
      billingDetails: BillingDetailsModel.fromJson(parseMap(json['billingDetails'])),
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

// ============================================================================
//                        BILLING DETAILS MODEL
// ============================================================================

class BillingDetailsModel {
  final int totalItems;
  final String subTotal;
  final String platformFee;
  final String deliveryCharge;
  final String totalPaid;

  BillingDetailsModel({
    required this.totalItems,
    required this.subTotal,
    required this.platformFee,
    required this.deliveryCharge,
    required this.totalPaid,
  });

  factory BillingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BillingDetailsModel(
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

// ============================================================================
//                               ORDER MODEL
// ============================================================================

class OrderModel {
  final String id;
  final UserModel userId;
  final DeliveryAddressModel deliveryAddress;
  final List<OrderItemModel> orderItems;
  final List<StatusTimelineModel> statusTimeline;
  final double totalAmount;
  final String notes;
  final String voiceNoteUrl;
  final String paymentMethod;
  final String status;
  final String assignedRider;
  final String assignedRiderStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Extended fields
  final String? formattedPickupDistance;
  final String? formattedDropDistance;
  final String? pickupTime;
  final String? dropTime;
  final BillingDetailsModel? billingDetails;
  final String? transactionId;
  final String paymentStatus;
  final String? razorpayOrder;
  final bool isReordered;
  final double deliveryCharge;
  final double platformCharge;
  final double codAmountReceived;
  final String? couponCode;
  final double discountAmount;
  final bool isPrescriptionOrder;
  final List<String> deliveryProof;
  final List<String> beforePickupProof;
  final int? v;

  OrderModel({
    required this.id,
    required this.userId,
    required this.deliveryAddress,
    required this.orderItems,
    required this.statusTimeline,
    required this.totalAmount,
    required this.notes,
    required this.voiceNoteUrl,
    required this.paymentMethod,
    required this.status,
    required this.assignedRider,
    required this.assignedRiderStatus,
    required this.createdAt,
    required this.updatedAt,

    this.v,
    this.formattedPickupDistance,
    this.formattedDropDistance,
    this.pickupTime,
    this.dropTime,
    this.billingDetails,
    this.transactionId,
    this.paymentStatus = 'Pending',
    this.razorpayOrder,
    this.isReordered = false,
    this.deliveryCharge = 0,
    this.platformCharge = 0,
    this.codAmountReceived = 0,
    this.couponCode,
    this.discountAmount = 0,
    this.isPrescriptionOrder = false,
    this.deliveryProof = const [],
    this.beforePickupProof = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: parseString(json['_id']),
      userId: UserModel.fromJson(parseMap(json['userId'])),
      deliveryAddress: DeliveryAddressModel.fromJson(
        parseMap(json['deliveryAddress']),
      ),

      orderItems: parseList(json['orderItems'], 
        (e) => OrderItemModel.fromJson(parseMap(e)),
      ),

      statusTimeline: parseList(json['statusTimeline'],
        (e) => StatusTimelineModel.fromJson(parseMap(e)),
      ),

      totalAmount: parseDouble(json['totalAmount']),
      notes: parseString(json['notes']),
      voiceNoteUrl: parseString(json['voiceNoteUrl']),
      paymentMethod: parseString(json['paymentMethod']),
      status: parseString(json['status']),
      assignedRider: parseString(json['assignedRider']),
      assignedRiderStatus: parseString(json['assignedRiderStatus']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      v: json['__v'],

      formattedPickupDistance: json['formattedPickupDistance']?.toString(),
      formattedDropDistance: json['formattedDropDistance']?.toString(),

      pickupTime: parseString(json['pickupTime']),
      dropTime: parseString(json['dropTime']),

      billingDetails: json['billingDetails'] != null
          ? BillingDetailsModel.fromJson(parseMap(json['billingDetails']))
          : null,

      transactionId: parseString(json['transactionId']),
      paymentStatus: parseString(json['paymentStatus']),
      razorpayOrder: parseString(json['razorpayOrder']),
      isReordered: json['isReordered'] ?? false,

      deliveryCharge: parseDouble(json['deliveryCharge']),
      platformCharge: parseDouble(json['platformCharge']),
      codAmountReceived: parseDouble(json['codAmountReceived']),
      couponCode: parseString(json['couponCode']),
      discountAmount: parseDouble(json['discountAmount']),
      isPrescriptionOrder: json['isPrescriptionOrder'] ?? false,

      deliveryProof: parseList(json['deliveryProof'], (e) => parseString(e)),
      beforePickupProof: parseList(json['beforePickupProof'], (e) => parseString(e)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(),
      'deliveryAddress': deliveryAddress.toJson(),
      'orderItems': orderItems.map((e) => e.toJson()).toList(),
      'statusTimeline': statusTimeline.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'notes': notes,
      'voiceNoteUrl': voiceNoteUrl,
      'paymentMethod': paymentMethod,
      'status': status,
      'assignedRider': assignedRider,
      'assignedRiderStatus': assignedRiderStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

      if (v != null) '__v': v,
      'formattedPickupDistance': formattedPickupDistance,
      'formattedDropDistance': formattedDropDistance,
      'pickupTime': pickupTime,
      'dropTime': dropTime,

      if (billingDetails != null) 'billingDetails': billingDetails!.toJson(),

      'transactionId': transactionId,
      'paymentStatus': paymentStatus,
      'razorpayOrder': razorpayOrder,
      'isReordered': isReordered,
      'deliveryCharge': deliveryCharge,
      'platformCharge': platformCharge,
      'codAmountReceived': codAmountReceived,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
      'isPrescriptionOrder': isPrescriptionOrder,
      'deliveryProof': deliveryProof,
      'beforePickupProof': beforePickupProof,
    };
  }
}

// ============================================================================
//                                USER MODEL
// ============================================================================

class UserModel {
  final String id;
  final String name;
  final String mobile;
  final LocationModel location;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      mobile: parseString(json['mobile']),
      location: LocationModel.fromJson(parseMap(json['location'])),
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

// ============================================================================
//                               LOCATION MODEL
// ============================================================================

class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
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

// ============================================================================
//                           DELIVERY ADDRESS MODEL
// ============================================================================

class DeliveryAddressModel {
  final String house;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String country;

  DeliveryAddressModel({
    required this.house,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
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

  String get fullAddress => "$house, $street, $city, $state $pincode, $country";
}

// ============================================================================
//                             ORDER ITEM MODEL
// ============================================================================

class OrderItemModel {
  final MedicineModel? medicineId;
  final String name;
  final int quantity;
  final String id;

  OrderItemModel({
    this.medicineId,
    required this.name,
    required this.quantity,
    required this.id,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      medicineId: json['medicineId'] != null 
          ? MedicineModel.fromJson(parseMap(json['medicineId']))
          : null,
      name: parseString(json['name']),
      quantity: parseInt(json['quantity']),
      id: parseString(json['_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId?.toJson(),
      'name': name,
      'quantity': quantity,
      '_id': id,
    };
  }
}

// ============================================================================
//                           MEDICINE MODEL
// ============================================================================

class MedicineModel {
  final String id;
  final PharmacyModel pharmacyId;
  final String name;
  final List<String> images;
  final double mrp;
  final String description;

  MedicineModel({
    required this.id,
    required this.pharmacyId,
    required this.name,
    required this.images,
    required this.mrp,
    required this.description,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: parseString(json['_id']),
      pharmacyId: PharmacyModel.fromJson(parseMap(json['pharmacyId'])),
      name: parseString(json['name']),
      images: parseList(json['images'], (e) => parseString(e)),
      mrp: parseDouble(json['mrp']),
      description: parseString(json['description']),
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

// ============================================================================
//                            PHARMACY MODEL
// ============================================================================

class PharmacyModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
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
      if (address != null) 'address': address,
    };
  }
}

// ============================================================================
//                          STATUS TIMELINE MODEL
// ============================================================================

class StatusTimelineModel {
  final String status;
  final String message;
  final DateTime timestamp;
  final String id;

  StatusTimelineModel({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.id,
  });

  factory StatusTimelineModel.fromJson(Map<String, dynamic> json) {
    return StatusTimelineModel(
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
