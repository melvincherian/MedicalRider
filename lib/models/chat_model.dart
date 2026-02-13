// chat_message_model.dart
class ChatMessage {
  final String id;
  final String riderId;
  final String userId;
  final String message;
  final String senderType; // "user" or "rider"
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? sender;
  final String? receiver;

  ChatMessage({
    required this.id,
    required this.riderId,
    required this.userId,
    required this.message,
    required this.senderType,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      riderId: json['riderId'] ?? '',
      userId: json['userId'] ?? '',
      message: json['message'] ?? '',
      senderType: json['senderType'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sender: json['sender'],
      receiver: json['receiver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'riderId': riderId,
      'userId': userId,
      'message': message,
      'senderType': senderType,
      'timestamp': timestamp.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sender': sender,
      'receiver': receiver,
    };
  }

  bool get isFromUser => senderType == 'user';
  bool get isFromRider => senderType == 'rider';
}