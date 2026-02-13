class QueryModel {
  final String? id;
  final String riderId;
  final String name;
  final String email;
  final String mobile;
  final String message;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QueryModel({
    this.id,
    required this.riderId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory QueryModel.fromJson(Map<String, dynamic> json) {
    return QueryModel(
      id: json['_id'],
      riderId: json['riderId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      message: json['message'] ?? '',
      status: json['status'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riderId': riderId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'message': message,
    };
  }
}

class QueryResponse {
  final String message;
  final QueryModel query;

  QueryResponse({
    required this.message,
    required this.query,
  });

  factory QueryResponse.fromJson(Map<String, dynamic> json) {
    return QueryResponse(
      message: json['message'] ?? '',
      query: QueryModel.fromJson(json['query'] ?? {}),
    );
  }
}