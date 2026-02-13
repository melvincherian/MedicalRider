// // // ignore_for_file: deprecated_member_use

// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:medical_delivery_app/providers/notification_provider.dart';
// // import 'package:medical_delivery_app/models/notification_model.dart';

// // class NotificationScreen extends StatefulWidget {
// //   const NotificationScreen({super.key});

// //   @override
// //   State<NotificationScreen> createState() => _NotificationScreenState();
// // }

// // class _NotificationScreenState extends State<NotificationScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch notifications when screen loads
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<NotificationProvider>().fetchNotifications();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       appBar: AppBar(
// //         title: const Text(
// //           "Notifications",
// //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: Colors.blue,
// //         elevation: 0,
// //         leading: IconButton(
// //           onPressed: () {
// //             Navigator.of(context).pop();
// //           },
// //           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
// //         ),
// //         actions: [
// //           Consumer<NotificationProvider>(
// //             builder: (context, provider, child) {
// //               if (provider.unreadCount > 0) {
// //                 return Padding(
// //                   padding: const EdgeInsets.only(right: 16.0),
// //                   child: Center(
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: Colors.red,
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Text(
// //                         '${provider.unreadCount}',
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               }
// //               return const SizedBox.shrink();
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Consumer<NotificationProvider>(
// //         builder: (context, provider, child) {
// //           return RefreshIndicator(
// //             onRefresh: () => provider.refreshNotifications(),
// //             child: _buildNotificationContent(provider),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildNotificationContent(NotificationProvider provider) {
// //     if (provider.isLoading) {
// //       return const Center(
// //         child: CircularProgressIndicator(
// //           color: Colors.teal,
// //         ),
// //       );
// //     }

// //     if (provider.hasError) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.error_outline,
// //               size: 64,
// //               color: Colors.grey[400],
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'Failed to load notifications',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.grey[600],
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               provider.errorMessage,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.grey[500],
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: () => provider.fetchNotifications(),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.teal,
// //                 foregroundColor: Colors.white,
// //               ),
// //               child: const Text('Retry'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     if (provider.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.notifications_none,
// //               size: 64,
// //               color: Colors.grey[400],
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No notifications',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.grey[600],
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'You\'re all caught up!',
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.grey[500],
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return ListView(
// //       padding: const EdgeInsets.all(16),
// //       children: [
// //         // Today's notifications
// //         if (provider.todayNotifications.isNotEmpty) ...[
// //           const Text(
// //             "Today",
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           ...provider.todayNotifications.map((notification) =>
// //               _buildNotificationCard(notification, provider)),
// //           const SizedBox(height: 20),
// //         ],
        
// //         // Earlier notifications
// //         if (provider.earlierNotifications.isNotEmpty) ...[
// //           const Text(
// //             "Earlier",
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black87,
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           ...provider.earlierNotifications.map((notification) =>
// //               _buildNotificationCard(notification, provider)),
// //         ],
// //       ],
// //     );
// //   }

// //   Widget _buildNotificationCard(
// //     NotificationModel notification,
// //     NotificationProvider provider,
// //   ) {
// //     final isUnread = !notification.read;
    
// //     return GestureDetector(
// //       onTap: () {
// //         if (isUnread) {
// //           provider.markAsRead(notification.id);
// //         }
// //         // You can add navigation to notification details here if needed
// //         // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetailScreen(notification: notification)));
// //       },
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 14),
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           color: isUnread ? Colors.teal.withOpacity(0.05) : Colors.white,
// //           borderRadius: BorderRadius.circular(14),
// //           border: isUnread 
// //               ? Border.all(color: Colors.teal.withOpacity(0.2), width: 1)
// //               : null,
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black12,
// //               blurRadius: 6,
// //               offset: const Offset(0, 3),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             Stack(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 24,
// //                   backgroundColor: provider.getNotificationColor(notification).withOpacity(0.15),
// //                   child: Icon(
// //                     provider.getNotificationIcon(notification),
// //                     color: provider.getNotificationColor(notification),
// //                     size: 26,
// //                   ),
// //                 ),
// //                 if (isUnread)
// //                   Positioned(
// //                     top: 0,
// //                     right: 0,
// //                     child: Container(
// //                       width: 12,
// //                       height: 12,
// //                       decoration: const BoxDecoration(
// //                         color: Colors.red,
// //                         shape: BoxShape.circle,
// //                       ),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //             const SizedBox(width: 14),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     notification.message,
// //                     style: TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
// //                       color: isUnread ? Colors.black87 : Colors.black54,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   if (notification.order.id.isNotEmpty)
// //                     Text(
// //                       'Order #${notification.order.id} - ${notification.order.status}',
// //                       style: TextStyle(
// //                         fontSize: 13,
// //                         color: Colors.grey[600],
// //                         height: 1.3,
// //                       ),
// //                     ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 10),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 Text(
// //                   provider.getTimeAgo(notification.createdAt),
// //                   style: TextStyle(
// //                     fontSize: 12,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //                 if (isUnread)
// //                   Container(
// //                     margin: const EdgeInsets.only(top: 4),
// //                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                     decoration: BoxDecoration(
// //                       color: Colors.teal,
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: const Text(
// //                       'NEW',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 10,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



















// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/view/notifications/notification_detail.dart';
// import 'package:provider/provider.dart';
// import 'package:medical_delivery_app/providers/notification_provider.dart';
// import 'package:medical_delivery_app/models/notification_model.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch notifications when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<NotificationProvider>().fetchNotifications();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           "Notifications",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         // actions: [
//         //   Consumer<NotificationProvider>(
//         //     builder: (context, provider, child) {
//         //       if (provider.unreadCount > 0) {
//         //         return Padding(
//         //           padding: const EdgeInsets.only(right: 16.0),
//         //           child: Center(
//         //             child: Container(
//         //               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         //               decoration: BoxDecoration(
//         //                 color: Colors.red,
//         //                 borderRadius: BorderRadius.circular(12),
//         //               ),
//         //               child: Text(
//         //                 '${provider.unreadCount}',
//         //                 style: const TextStyle(
//         //                   color: Colors.white,
//         //                   fontSize: 12,
//         //                   fontWeight: FontWeight.bold,
//         //                 ),
//         //               ),
//         //             ),
//         //           ),
//         //         );
//         //       }
//         //       return const SizedBox.shrink();
//         //     },
//         //   ),
//         // ],
//       ),
//       body: Consumer<NotificationProvider>(
//         builder: (context, provider, child) {
//           return RefreshIndicator(
//             onRefresh: () => provider.refreshNotifications(),
//             child: _buildNotificationContent(provider),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationContent(NotificationProvider provider) {
//     if (provider.isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(
//           color: Colors.teal,
//         ),
//       );
//     }

//     if (provider.hasError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon(
//             //   Icons.error_outline,
//             //   size: 64,
//             //   color: Colors.grey[400],
//             // ),
//             const SizedBox(height: 16),
//             Text(
//               'Failed to load notifications',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               provider.errorMessage,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => provider.fetchNotifications(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (provider.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.notifications_none,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No notifications',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'You\'re all caught up!',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         // Today's notifications
//         if (provider.todayNotifications.isNotEmpty) ...[
//           const Text(
//             "Today",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ...provider.todayNotifications.map((notification) =>
//               _buildNotificationCard(notification, provider)),
//           const SizedBox(height: 20),
//         ],
        
//         // Earlier notifications
//         if (provider.earlierNotifications.isNotEmpty) ...[
//           const Text(
//             "Earlier",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ...provider.earlierNotifications.map((notification) =>
//               _buildNotificationCard(notification, provider)),
//         ],
//       ],
//     );
//   }

//   Widget _buildNotificationCard(
//     NotificationModel notification,
//     NotificationProvider provider,
//   ) {
//     final isUnread = !notification.read;
    
//     return GestureDetector(
//       onTap: () async {
//         // Mark as read if unread
//         if (isUnread) {
//           provider.markAsRead(notification.id);
//         }
        
//         // Navigate to notification detail screen
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NotificationDetailScreen(
//               notification: notification,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: isUnread ? Colors.teal.withOpacity(0.05) : Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: isUnread 
//               ? Border.all(color: Colors.teal.withOpacity(0.2), width: 1)
//               : null,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundColor: provider.getNotificationColor(notification).withOpacity(0.15),
//                   child: Icon(
//                     provider.getNotificationIcon(notification),
//                     color: provider.getNotificationColor(notification),
//                     size: 26,
//                   ),
//                 ),
//                 // if (isUnread)
//                 //   Positioned(
//                 //     top: 0,
//                 //     right: 0,
//                 //     child: Container(
//                 //       width: 12,
//                 //       height: 12,
//                 //       decoration: const BoxDecoration(
//                 //         color: Colors.red,
//                 //         shape: BoxShape.circle,
//                 //       ),
//                 //     ),
//                 //   ),
//               ],
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     notification.message,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
//                       color: isUnread ? Colors.black87 : Colors.black54,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   if (notification.order.id.isNotEmpty)
//                     Text(
//                       'Order #${notification.order.id} - ${notification.order.status}',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                         height: 1.3,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   provider.getTimeAgo(notification.createdAt),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 if (isUnread)
//                   Container(
//                     margin: const EdgeInsets.only(top: 4),
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.teal,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       'NEW',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }










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
  @override
  void initState() {
    super.initState();
    // Fetch notifications when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.refreshNotifications(),
            child: _buildNotificationContent(provider),
          );
        },
      ),
    );
  }

  Widget _buildNotificationContent(NotificationProvider provider) {
    if (provider.isLoading) {
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

    return ListView(
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
          // const Text(
          //   "Earlier",
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black87,
          //   ),
          // ),
          const SizedBox(height: 10),
          ...sortedEarlierNotifications.map((notification) =>
              _buildNotificationCard(notification, provider)),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    final isUnread = !notification.read;
    
    return GestureDetector(
      onTap: () async {
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? Colors.teal.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isUnread 
              ? Border.all(color: Colors.teal.withOpacity(0.2), width: 1)
              : null,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}