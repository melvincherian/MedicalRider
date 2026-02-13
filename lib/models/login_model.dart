
// class RiderModel {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String address;
//   final String city;
//   final String state;
//   final String pinCode;
//   final String latitude;
//   final String longitude;
//   final String profileImage;
//   final List<String> rideImages;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//   final double deliveryCharge;
//   final List<AccountDetails> accountDetails;
//   final double wallet;
//   final String status;

//   RiderModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.pinCode,
//     required this.latitude,
//     required this.longitude,
//     required this.profileImage,
//     required this.rideImages,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.deliveryCharge,
//     required this.accountDetails,
//     required this.wallet,
//         required this.status,

//   });

//   factory RiderModel.fromJson(Map<String, dynamic> json) {
//     return RiderModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       address: json['address'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       pinCode: json['pinCode'] ?? '',
//       latitude: json['latitude'] ?? '',
//       longitude: json['longitude'] ?? '',
//       profileImage: json['profileImage'] ?? '',
//       rideImages: List<String>.from(json['rideImages'] ?? []),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       v: json['__v'] ?? 0,
//       deliveryCharge: (json['deliveryCharge'] ?? 0).toDouble(),
//       accountDetails: (json['accountDetails'] as List?)
//           ?.map((e) => AccountDetails.fromJson(e))
//           .toList() ?? [],
//       wallet: (json['wallet'] ?? 0).toDouble(),
//       status: json['status'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'address': address,
//       'city': city,
//       'state': state,
//       'pinCode': pinCode,
//       'latitude': latitude,
//       'longitude': longitude,
//       'profileImage': profileImage,
//       'rideImages': rideImages,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': v,
//       'deliveryCharge': deliveryCharge,
//       'accountDetails': accountDetails.map((e) => e.toJson()).toList(),
//       'wallet': wallet,
//        'status': status,
//     };
//   }
// }

// class AccountDetails {
//   final String accountHolderName;
//   final String accountNumber;
//   final String ifscCode;
//   final String bankName;
//   final String upiId;
//   final String id;
//   final DateTime addedAt;

//   AccountDetails({
//     required this.accountHolderName,
//     required this.accountNumber,
//     required this.ifscCode,
//     required this.bankName,
//     required this.upiId,
//     required this.id,
//     required this.addedAt,
//   });

//   factory AccountDetails.fromJson(Map<String, dynamic> json) {
//     return AccountDetails(
//       accountHolderName: json['accountHolderName'] ?? '',
//       accountNumber: json['accountNumber'] ?? '',
//       ifscCode: json['ifscCode'] ?? '',
//       bankName: json['bankName'] ?? '',
//       upiId: json['upiId'] ?? '',
//       id: json['_id'] ?? '',
//       addedAt: DateTime.parse(json['addedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'accountHolderName': accountHolderName,
//       'accountNumber': accountNumber,
//       'ifscCode': ifscCode,
//       'bankName': bankName,
//       'upiId': upiId,
//       '_id': id,
//       'addedAt': addedAt.toIso8601String(),
//     };
//   }
// }

// class LoginResponse {
//   final String message;
//   final RiderModel rider;

//   LoginResponse({
//     required this.message,
//     required this.rider,
//   });

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       message: json['message'] ?? '',
//       rider: RiderModel.fromJson(json['rider']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'rider': rider.toJson(),
//     };
//   }
// }














// ==========================================================
//                  SAFE PARSER HELPERS
// ==========================================================

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
  if (value is DateTime) return value;

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

// ==========================================================
//                       RIDER MODEL
// ==========================================================

class RiderModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String latitude;
  final String longitude;
  final String profileImage;
  final List<String> rideImages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final double deliveryCharge;
  final List<AccountDetails> accountDetails;
  final double wallet;
  final String status;

  RiderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.latitude,
    required this.longitude,
    required this.profileImage,
    required this.rideImages,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.deliveryCharge,
    required this.accountDetails,
    required this.wallet,
    required this.status,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      email: parseString(json['email']),
      phone: parseString(json['phone']),
      address: parseString(json['address']),
      city: parseString(json['city']),
      state: parseString(json['state']),
      pinCode: parseString(json['pinCode']),
      latitude: parseString(json['latitude']),
      longitude: parseString(json['longitude']),
      profileImage: parseString(json['profileImage']),

      rideImages: parseList(json['rideImages'], (e) => parseString(e)),

      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),

      v: parseInt(json['__v']),
      deliveryCharge: parseDouble(json['deliveryCharge']),
      wallet: parseDouble(json['wallet']),

      accountDetails: parseList(
        json['accountDetails'],
        (e) => AccountDetails.fromJson(parseMap(e)),
      ),

      status: parseString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'latitude': latitude,
      'longitude': longitude,
      'profileImage': profileImage,
      'rideImages': rideImages,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'deliveryCharge': deliveryCharge,
      'accountDetails': accountDetails.map((e) => e.toJson()).toList(),
      'wallet': wallet,
      'status': status,
    };
  }
}

// ==========================================================
//                ACCOUNT DETAILS MODEL
// ==========================================================

class AccountDetails {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String upiId;
  final String id;
  final DateTime addedAt;

  AccountDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.upiId,
    required this.id,
    required this.addedAt,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    return AccountDetails(
      accountHolderName: parseString(json['accountHolderName']),
      accountNumber: parseString(json['accountNumber']),
      ifscCode: parseString(json['ifscCode']),
      bankName: parseString(json['bankName']),
      upiId: parseString(json['upiId']),
      id: parseString(json['_id']),
      addedAt: parseDate(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'upiId': upiId,
      '_id': id,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

// ==========================================================
//                    LOGIN RESPONSE MODEL
// ==========================================================

class LoginResponse {
  final String message;
  final RiderModel rider;

  LoginResponse({
    required this.message,
    required this.rider,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: parseString(json['message']),
      rider: RiderModel.fromJson(parseMap(json['rider'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'rider': rider.toJson(),
    };
  }
}
