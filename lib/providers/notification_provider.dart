import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/notification_model.dart';
import 'package:medical_delivery_app/services/notification_service.dart';

enum NotificationState { initial, loading, loaded, error, empty }

class NotificationProvider extends ChangeNotifier {
  // Private variables
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _todayNotifications = [];
  List<NotificationModel> _earlierNotifications = [];
  NotificationState _state = NotificationState.initial;
  String _errorMessage = '';
  int _unreadCount = 0;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get todayNotifications => _todayNotifications;
  List<NotificationModel> get earlierNotifications => _earlierNotifications;
  NotificationState get state => _state;
  String get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;
  bool get isLoading => _state == NotificationState.loading;
  bool get hasError => _state == NotificationState.error;
  bool get isEmpty => _state == NotificationState.empty;
  bool get hasNotifications => _notifications.isNotEmpty;

  /// Fetch notifications from API
  Future<void> fetchNotifications() async {
    try {
      _state = NotificationState.loading;
      _errorMessage = '';
      notifyListeners();

      final response = await NotificationService.getNotifications();
      
      if (response != null && response.notifications.isNotEmpty) {
        _notifications = response.notifications;
        _categorizeNotifications();
        _calculateUnreadCount();
        _state = NotificationState.loaded;
      } else {
        _notifications = [];
        _todayNotifications = [];
        _earlierNotifications = [];
        _unreadCount = 0;
        _state = NotificationState.empty;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = NotificationState.error;
      _notifications = [];
      _todayNotifications = [];
      _earlierNotifications = [];
      print('Error fetching notifications: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final success = await NotificationService.markNotificationAsRead(notificationId);
      
      if (success) {
        // Update local state
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            order: _notifications[index].order,
            message: _notifications[index].message,
            read: true,
            createdAt: _notifications[index].createdAt,
          );
          
          _categorizeNotifications();
          _calculateUnreadCount();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  /// Get unread count
  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await NotificationService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      print('Error fetching unread count: $e');
    }
  }

  /// Clear all notifications locally (for testing purposes)
  void clearNotifications() {
    _notifications = [];
    _todayNotifications = [];
    _earlierNotifications = [];
    _unreadCount = 0;
    _state = NotificationState.empty;
    notifyListeners();
  }

  /// Private method to categorize notifications into today and earlier
  void _categorizeNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _todayNotifications = _notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      return notificationDate.isAtSameMomentAs(today);
    }).toList();
    
    _earlierNotifications = _notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      return notificationDate.isBefore(today);
    }).toList();
    
    // Sort notifications by created date (newest first)
    _todayNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _earlierNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Private method to calculate unread count
  void _calculateUnreadCount() {
    _unreadCount = _notifications.where((notification) => !notification.read).length;
  }

  /// Get formatted time difference
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    }
  }

  /// Get notification icon based on order status or type
  IconData getNotificationIcon(NotificationModel notification) {
    final message = notification.message.toLowerCase();
    final status = notification.order.status.toLowerCase();
    
    if (message.contains('assigned') || message.contains('new order')) {
      return Icons.assignment;
    } else if (status.contains('picked') || message.contains('pickup')) {
      return Icons.local_shipping;
    } else if (status.contains('delivered') || message.contains('deliver')) {
      return Icons.check_circle;
    } else if (message.contains('cancelled')) {
      return Icons.cancel;
    } else {
      return Icons.notifications;
    }
  }

  /// Get notification color based on order status or type
  Color getNotificationColor(NotificationModel notification) {
    final message = notification.message.toLowerCase();
    final status = notification.order.status.toLowerCase();
    
    if (message.contains('assigned') || message.contains('new order')) {
      return Colors.blue;
    } else if (status.contains('picked') || message.contains('pickup')) {
      return Colors.orange;
    } else if (status.contains('delivered') || message.contains('deliver')) {
      return Colors.green;
    } else if (message.contains('cancelled')) {
      return Colors.red;
    } else {
      return Colors.teal;
    }
  }
}