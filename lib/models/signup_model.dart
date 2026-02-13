
// ==========================================================
//                 SAFE PARSER HELPERS
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

bool parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value.toLowerCase() == "true";
  return false;
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
//                 SIGNUP REQUEST MODEL
// ==========================================================

class SignupRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String drivingLicensePath;
  final String profileImage;

  SignupRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.drivingLicensePath,
    required this.profileImage,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'drivingLicense': drivingLicensePath,
      'profileImage': profileImage,
    };
  }
}

// ==========================================================
//                 SIGNUP RESPONSE MODEL
// ==========================================================

class SignupResponse {
  final bool success;
  final String message;
  final String? error;
  final RiderData? rider;

  SignupResponse({
    required this.success,
    required this.message,
    this.error,
    this.rider,
  });

  // Safer version
  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: parseBool(json['success']) == true || true,
      message: parseString(json['message']),
      rider: json['rider'] != null && json['rider'] is Map
          ? RiderData.fromJson(json['rider'])
          : null,
    );
  }

  // Error response handler
  factory SignupResponse.error(String errorMessage, {String? error}) {
    return SignupResponse(
      success: false,
      message: errorMessage,
      error: error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
      'rider': rider?.toJson(),
    };
  }
}

// ==========================================================
//                 RIDER DATA MODEL
// ==========================================================

class RiderData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String drivingLicense;
  final String profileImage;
  final double wallet;
  final double deliveryCharge;
  final String status;
  final List<dynamic> rideImages;
  final List<dynamic> accountDetails;
  final String createdAt;
  final String updatedAt;

  RiderData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.drivingLicense,
    required this.profileImage,
    required this.wallet,
    required this.deliveryCharge,
    required this.status,
    required this.rideImages,
    required this.accountDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RiderData.fromJson(Map<String, dynamic> json) {
    return RiderData(
      id: parseString(json['_id']),
      name: parseString(json['name']),
      email: parseString(json['email']),
      phone: parseString(json['phone']),
      drivingLicense: parseString(json['drivingLicense']),
      profileImage: parseString(json['profileImage']),

      wallet: parseDouble(json['wallet']),
      deliveryCharge: parseDouble(json['deliveryCharge']),

      status: parseString(json['status'].toString().isEmpty
          ? 'offline'
          : json['status']),

      rideImages: (json['rideImages'] is List) ? json['rideImages'] : [],
      accountDetails: (json['accountDetails'] is List)
          ? json['accountDetails']
          : [],

      createdAt: parseString(json['createdAt']),
      updatedAt: parseString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'drivingLicense': drivingLicense,
      'profileImage': profileImage,
      'wallet': wallet,
      'deliveryCharge': deliveryCharge,
      'status': status,
      'rideImages': rideImages,
      'accountDetails': accountDetails,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
