import 'package:flutter/material.dart';
import 'package:medical_delivery_app/view/notifications/notification_detail.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/notification_provider.dart';
import 'package:medical_delivery_app/models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedNotificationIds = {};

  @override
  void initState() {
    super.initState();
    // Fetch notifications when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedNotificationIds.clear();
      }
    });
  }

  void _toggleNotificationSelection(String notificationId) {
    setState(() {
      if (_selectedNotificationIds.contains(notificationId)) {
        _selectedNotificationIds.remove(notificationId);
        if (_selectedNotificationIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNotificationIds.add(notificationId);
      }
    });
  }

  void _selectAllNotifications(List<NotificationModel> notifications) {
    setState(() {
      if (_selectedNotificationIds.length == notifications.length) {
        _selectedNotificationIds.clear();
        _isSelectionMode = false;
      } else {
        _selectedNotificationIds.addAll(notifications.map((n) => n.id));
        _isSelectionMode = true;
      }
    });
  }

  Future<void> _showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteSingleNotification(
    BuildContext context,
    NotificationProvider provider,
    String notificationId,
  ) async {
    await _showDeleteConfirmation(
      context: context,
      title: 'Delete Notification',
      message: 'Are you sure you want to delete this notification?',
      onConfirm: () async {
        // Clear any previous error
        provider.resetDeleteState();
        
        await provider.deleteNotifications([notificationId]);
        
        if (mounted) {
          // Check delete state instead of deleteError
          if (provider.deleteState == DeleteState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification deleted successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (provider.deleteState == DeleteState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete: ${provider.deleteError}'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _deleteSelectedNotifications(
    BuildContext context,
    NotificationProvider provider,
  ) async {
    if (_selectedNotificationIds.isEmpty) return;

    await _showDeleteConfirmation(
      context: context,
      title: 'Delete Notifications',
      message: 'Are you sure you want to delete ${_selectedNotificationIds.length} notification(s)?',
      onConfirm: () async {
        // Clear any previous error
        provider.resetDeleteState();
        
        await provider.deleteNotifications(_selectedNotificationIds.toList());
        
        if (mounted) {
          // Check delete state instead of deleteError
          if (provider.deleteState == DeleteState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${_selectedNotificationIds.length} notification(s) deleted successfully'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            setState(() {
              _selectedNotificationIds.clear();
              _isSelectionMode = false;
            });
          } else if (provider.deleteState == DeleteState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete: ${provider.deleteError}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: _isSelectionMode
            ? Text(
                '${_selectedNotificationIds.length} selected',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )
            : const Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: _isSelectionMode
              ? () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedNotificationIds.clear();
                  });
                }
              : () {
                  Navigator.of(context).pop();
                },
          icon: Icon(
            _isSelectionMode ? Icons.close : Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: _buildAppBarActions(),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.refreshNotifications();
              if (mounted) {
                setState(() {
                  _isSelectionMode = false;
                  _selectedNotificationIds.clear();
                });
              }
            },
            child: _buildNotificationContent(provider),
          );
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      if (_isSelectionMode)
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white),
          onPressed: () {
            final provider = context.read<NotificationProvider>();
            _deleteSelectedNotifications(context, provider);
          },
        )
      else
        Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            final allNotifications = [
              ...provider.todayNotifications,
              ...provider.earlierNotifications,
            ];
            
            if (allNotifications.isEmpty) return const SizedBox();
            
            return IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () {
                _showDeleteConfirmation(
                  context: context,
                  title: 'Delete All Notifications',
                  message: 'Are you sure you want to delete all notifications?',
                  onConfirm: () async {
                    // Clear any previous error
                    provider.resetDeleteState();
                    
                    final notificationIds = allNotifications.map((n) => n.id).toList();
                    await provider.deleteNotifications(notificationIds);
                    
                    if (mounted) {
                      // Check delete state instead of deleteError
                      if (provider.deleteState == DeleteState.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All notifications deleted successfully'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else if (provider.deleteState == DeleteState.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete: ${provider.deleteError}'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
        ),
    ];
  }

  Widget _buildNotificationContent(NotificationProvider provider) {
    if (provider.isLoading && provider.deleteState != DeleteState.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.teal,
        ),
      );
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Failed to load notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchNotifications(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Sort notifications by createdAt in descending order (newest first)
    final sortedTodayNotifications = List<NotificationModel>.from(provider.todayNotifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    final sortedEarlierNotifications = List<NotificationModel>.from(provider.earlierNotifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final allNotifications = [...sortedTodayNotifications, ...sortedEarlierNotifications];

    return Stack(
      children: [
        Column(
          children: [
            if (_isSelectionMode && allNotifications.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.blue.withOpacity(0.1),
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedNotificationIds.length == allNotifications.length,
                      onChanged: (_) => _selectAllNotifications(allNotifications),
                      activeColor: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Select All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_selectedNotificationIds.length} selected',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Today's notifications (sorted newest first)
                  if (sortedTodayNotifications.isNotEmpty) ...[
                    const Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...sortedTodayNotifications.map((notification) =>
                        _buildNotificationCard(notification, provider)),
                    const SizedBox(height: 20),
                  ],
                  
                  // Earlier notifications (sorted newest first)
                  if (sortedEarlierNotifications.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...sortedEarlierNotifications.map((notification) =>
                        _buildNotificationCard(notification, provider)),
                  ],
                ],
              ),
            ),
          ],
        ),
        
        // Show loading indicator during delete
        if (provider.isDeleting)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationCard(
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    final isUnread = !notification.read;
    final isSelected = _selectedNotificationIds.contains(notification.id);
    
    return GestureDetector(
      onTap: _isSelectionMode
          ? () => _toggleNotificationSelection(notification.id)
          : () async {
              // Mark as read if unread
              if (isUnread) {
                provider.markAsRead(notification.id);
              }
              
              // Navigate to notification detail screen
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetailScreen(
                    notification: notification,
                  ),
                ),
              );
            },
      onLongPress: () {
        if (!_isSelectionMode) {
          _toggleSelectionMode();
          _toggleNotificationSelection(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.1)
              : (isUnread ? Colors.teal.withOpacity(0.05) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: Colors.blue, width: 2)
              : (isUnread 
                  ? Border.all(color: Colors.teal.withOpacity(0.2), width: 1)
                  : null),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleNotificationSelection(notification.id),
                activeColor: Colors.blue,
              ),
              const SizedBox(width: 8),
            ],
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: provider.getNotificationColor(notification).withOpacity(0.15),
                  child: Icon(
                    provider.getNotificationIcon(notification),
                    color: provider.getNotificationColor(notification),
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                      color: isUnread ? Colors.black87 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (notification.order.id.isNotEmpty)
                    Text(
                      'Order #${notification.order.id} - ${notification.order.status}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  provider.getTimeAgo(notification.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (!_isSelectionMode)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () => _deleteSingleNotification(context, provider, notification.id),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}