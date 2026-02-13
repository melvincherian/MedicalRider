// // chat_provider.dart - Fixed Version

// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/chat_model.dart';
// import 'package:medical_delivery_app/services/chat_service.dart';

// class ChatProvider extends ChangeNotifier {
//   final ChatService _chatService = ChatService.instance; // Use singleton instance
//   List<ChatMessage> _messages = [];
//   bool _isLoading = false;
//   bool _isSending = false;
//   String _error = '';
//   String _currentUserId = '';
//   String _currentRiderId = '';

//   // Getters
//   List<ChatMessage> get messages => _messages;
//   bool get isLoading => _isLoading;
//   bool get isSending => _isSending;
//   String get error => _error;
//   bool get isConnected => _chatService.isConnected;

//   // Initialize chat
//   Future<void> initializeChat({
//     required String userId,
//     required String riderId,
//   }) async {
//     _isLoading = true;
//     _error = '';
//     _currentUserId = userId;
//     _currentRiderId = riderId;
//     notifyListeners();

//     try {
//       // Initialize socket with await
//       await _chatService.initSocket();
      
//       // Wait a bit for socket to connect
//       await Future.delayed(Duration(milliseconds: 1000));
      
//       // Join room
//       _chatService.joinRoom(userId, riderId);
      
//       // Remove existing listeners to avoid duplicates
//       _chatService.removeAllListeners();
      
//       // Listen for incoming messages
//       _chatService.onMessageReceived((message) {
//         print('📨 Received message in provider: ${message.message}');
//         _addMessage(message);
//       });
      
//       // Load chat history
//       await loadChatHistory(userId: userId, riderId: riderId);
      
//     } catch (e) {
//       _error = 'Failed to initialize chat: $e';
//       print('❌ Chat initialization error: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Load chat history
//   Future<void> loadChatHistory({
//     required String userId,
//     required String riderId,
//   }) async {
//     try {
//       final history = await _chatService.getChatHistory(
//         userId: userId,
//         riderId: riderId,
//       );
      
//       _messages = history;
//       _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
//       notifyListeners();
//       print('📚 Loaded ${_messages.length} messages from history');
//     } catch (e) {
//       _error = 'Failed to load chat history: $e';
//       print('❌ Error loading chat history: $e');
//     }
//   }

//   // Send message
//   Future<bool> sendMessage({
//     required String userId,
//     required String riderId,
//     required String message,
//     required String senderType,
//   }) async {
//     if (message.trim().isEmpty) return false;

//     _isSending = true;
//     _error = '';
//     notifyListeners();

//     try {
//       final success = await _chatService.sendMessage(
//         userId: userId,
//         riderId: riderId,
//         message: message.trim(),
//         senderType: senderType,
//       );

//       if (!success) {
//         _error = 'Failed to send message';
//       } else {
//         // If socket is not connected, add message locally for immediate feedback
//         if (!_chatService.isConnected) {
//           final localMessage = ChatMessage(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             riderId: riderId,
//             userId: userId,
//             message: message.trim(),
//             senderType: senderType,
//             timestamp: DateTime.now(),
//             createdAt: DateTime.now(),
//             updatedAt: DateTime.now(),
//           );
//           _addMessage(localMessage);
//         }
//       }

//       return success;
//     } catch (e) {
//       _error = 'Error sending message: $e';
//       print('❌ Error sending message: $e');
//       return false;
//     } finally {
//       _isSending = false;
//       notifyListeners();
//     }
//   }

//   // Add message to list (for real-time updates)
//   void _addMessage(ChatMessage message) {
//     // Check if message already exists to avoid duplicates
//     final exists = _messages.any((m) => 
//       m.id == message.id || 
//       (m.message == message.message && 
//        m.senderType == message.senderType && 
//        m.timestamp.difference(message.timestamp).abs().inSeconds < 5));
    
//     if (!exists) {
//       _messages.add(message);
//       _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
//       notifyListeners();
//       print('➕ Added new message: ${message.message}');
//     } else {
//       print('⚠️ Duplicate message ignored: ${message.message}');
//     }
//   }

//   // Clear messages
//   void clearMessages() {
//     _messages.clear();
//     notifyListeners();
//   }

//   // Clear error
//   void clearError() {
//     _error = '';
//     notifyListeners();
//   }

//   // Refresh chat
//   Future<void> refreshChat({
//     required String userId,
//     required String riderId,
//   }) async {
//     await loadChatHistory(userId: userId, riderId: riderId);
//   }

//   // Reconnect socket if needed
//   Future<void> reconnectIfNeeded() async {
//     if (!_chatService.isConnected && _currentUserId.isNotEmpty && _currentRiderId.isNotEmpty) {
//       print('🔄 Attempting to reconnect...');
//       await _chatService.reconnect();
//       await Future.delayed(Duration(milliseconds: 1000));
//       _chatService.joinRoom(_currentUserId, _currentRiderId);
      
//       // Re-setup message listener
//       _chatService.removeAllListeners();
//       _chatService.onMessageReceived((message) {
//         _addMessage(message);
//       });
//     }
//   }

//   // Check connection status and reconnect if needed
//   void checkConnectionStatus() {
//     if (!_chatService.isConnected && _currentUserId.isNotEmpty && _currentRiderId.isNotEmpty) {
//       reconnectIfNeeded();
//     }
//   }

//   @override
//   void dispose() {
//     if (_currentUserId.isNotEmpty && _currentRiderId.isNotEmpty) {
//       _chatService.leaveRoom(_currentUserId, _currentRiderId);
//     }
//     _chatService.removeAllListeners();
//     // Don't disconnect here as it's a singleton and might be used elsewhere
//     super.dispose();
//   }
// }


















import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/chat_model.dart';
import 'package:medical_delivery_app/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService.instance;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String _error = '';
  String _currentUserId = '';
  String _currentRiderId = '';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String get error => _error;
  bool get isConnected => _chatService.isConnected;

  Future<void> initializeChat({
    required String userId,
    required String riderId,
  }) async {
    _isLoading = true;
    _error = '';
    _currentUserId = userId;
    _currentRiderId = riderId;
    notifyListeners();

    try {
      await _chatService.initSocket();
      await Future.delayed(Duration(milliseconds: 1000));

      _chatService.joinRoom(userId, riderId);
      _chatService.removeAllListeners();

      _chatService.onMessageReceived((message) {
        print('📨 Received message in provider: ${message.message}');
        _addMessage(message);
      });

      await loadChatHistory(userId: userId, riderId: riderId);
    } catch (e) {
      _error = 'Failed to initialize chat: $e';
      print('❌ Chat initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChatHistory({
    required String userId,
    required String riderId,
  }) async {
    try {
      final history = await _chatService.getChatHistory(
        userId: userId,
        riderId: riderId,
      );

      _messages = history;
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners();
      print('📚 Loaded ${_messages.length} messages from history');
    } catch (e) {
      _error = 'Failed to load chat history: $e';
      print('❌ Error loading chat history: $e');
    }
  }

  Future<bool> sendMessage({
    required String userId,
    required String riderId,
    required String message,
    required String senderType,
  }) async {
    if (message.trim().isEmpty) return false;

    _isSending = true;
    _error = '';
    notifyListeners();

    try {
      final success = await _chatService.sendMessage(
        userId: userId,
        riderId: riderId,
        message: message.trim(),
        senderType: senderType,
      );

      if (!success) {
        _error = 'Failed to send message';
      } else if (!_chatService.isConnected) {
        final localMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          riderId: riderId,
          userId: userId,
          message: message.trim(),
          senderType: senderType,
          timestamp: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _addMessage(localMessage);
      }

      return success;
    } catch (e) {
      _error = 'Error sending message: $e';
      print('❌ Error sending message: $e');
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void _addMessage(ChatMessage message) {
    final exists = _messages.any((m) =>
        m.id == message.id ||
        (m.message == message.message &&
            m.senderType == message.senderType &&
            m.timestamp.difference(message.timestamp).abs().inSeconds < 5));

    if (!exists) {
      _messages.add(message);
      _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      notifyListeners();
      print('➕ Added new message: ${message.message}');
    } else {
      print('⚠️ Duplicate message ignored: ${message.message}');
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  Future<void> refreshChat({
    required String userId,
    required String riderId,
  }) async {
    await loadChatHistory(userId: userId, riderId: riderId);
  }

  Future<void> reconnectIfNeeded() async {
    if (!_chatService.isConnected &&
        _currentUserId.isNotEmpty &&
        _currentRiderId.isNotEmpty) {
      print('🔄 Attempting to reconnect...');
      await _chatService.reconnect();
      await Future.delayed(Duration(milliseconds: 1000));
      _chatService.joinRoom(_currentUserId, _currentRiderId);

      _chatService.removeAllListeners();
      _chatService.onMessageReceived((message) {
        _addMessage(message);
      });
    }
  }

  void checkConnectionStatus() {
    if (!_chatService.isConnected &&
        _currentUserId.isNotEmpty &&
        _currentRiderId.isNotEmpty) {
      reconnectIfNeeded();
    }
  }

  @override
  void dispose() {
    if (_currentUserId.isNotEmpty && _currentRiderId.isNotEmpty) {
      _chatService.leaveRoom(_currentUserId, _currentRiderId);
    }
    _chatService.removeAllListeners();
    super.dispose();
  }
}
