import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/models/notification_model.dart';
import 'package:medical_delivery_app/providers/notification_provider.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Notification Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () => _showDeleteDialog(context),
        //     icon: const Icon(Icons.delete_outline, color: Colors.white),
        //   ),
        // ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Header
                _buildNotificationHeader(provider),
                
                const SizedBox(height: 24),
                
                // Notification Content
                _buildNotificationContent(),
                
                const SizedBox(height: 24),
                
                // Order Details (if applicable)
                if (widget.notification.order.id.isNotEmpty)
                  _buildOrderDetails(),
                
                const SizedBox(height: 24),
                
                // Action Buttons
                _buildActionButtons(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationHeader(NotificationProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: provider.getNotificationColor(widget.notification).withOpacity(0.15),
            child: Icon(
              provider.getNotificationIcon(widget.notification),
              color: provider.getNotificationColor(widget.notification),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getNotificationTitle(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.getTimeAgo(widget.notification.createdAt),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                // if (!widget.notification.read)
                //   Container(
                //     margin: const EdgeInsets.only(top: 8),
                //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //     decoration: BoxDecoration(
                //       color: Colors.teal,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Text(
                //       'UNREAD',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 11,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Message",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.notification.message,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildOrderDetailRow("Order ID", "#${widget.notification.order.id}"),
          const SizedBox(height: 8),
          _buildOrderDetailRow("Status", widget.notification.order.status),
          // Add more order details as needed
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "$label:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(NotificationProvider provider) {
    return Row(
      children: [
        if (!widget.notification.read)
          // Expanded(
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       provider.markAsRead(widget.notification.id);
          //       setState(() {});
          //     },
          //     icon: const Icon(Icons.check),
          //     label: const Text("Mark as Read"),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.teal,
          //       foregroundColor: Colors.white,
          //       padding: const EdgeInsets.symmetric(vertical: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
        if (!widget.notification.read) const SizedBox(width: 12),
        // Expanded(
        //   child: ElevatedButton.icon(
        //     onPressed: () => _showDeleteDialog(context),
        //     icon: const Icon(Icons.delete_outline),
        //     label: const Text("Delete"),
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.red[50],
        //       foregroundColor: Colors.red,
        //       padding: const EdgeInsets.symmetric(vertical: 12),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //         side: BorderSide(color: Colors.red.withOpacity(0.3)),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  String _getNotificationTitle() {
    // You can customize this based on notification type
    if (widget.notification.order.id.isNotEmpty) {
      return "Order Notification";
    }
    return "System Notification";
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Delete Notification"),
          content: const Text("Are you sure you want to delete this notification?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // _deleteNotification();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _deleteNotification() {
  //   final provider = context.read<NotificationProvider>();
  //   provider.deleteNotification(widget.notification.id);
  //   Navigator.of(context).pop(); // Go back to notifications list
    
  //   // Show success message
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text("Notification deleted successfully"),
  //       backgroundColor: Colors.green,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }
}