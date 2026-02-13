// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/login_model.dart';
// import 'package:medical_delivery_app/utils/helper_function.dart';
// import 'package:medical_delivery_app/view/scan/image_showing_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// // import 'package:url_launcher/url_launcher.dart';

// class OrderScanScreen extends StatefulWidget {
//   final String orderId;
//   final String?totalamount;

//   const OrderScanScreen({super.key, required this.orderId,this.totalamount});

//   @override
//   State<OrderScanScreen> createState() => _OrderScanScreenState();
// }

// class _OrderScanScreenState extends State<OrderScanScreen> {
//   AcceptedOrder? currentOrder;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrderData();
//   }

//   void _loadOrderData() {
//     final provider = Provider.of<AcceptPickupProvider>(context, listen: false);
//     currentOrder = provider.getOrderById(widget.orderId);

//     print('=== DEBUG ORDER DATA ===');
//     print('Order ID: ${widget.orderId}');
//     print('Current Order: ${currentOrder != null}');
//     if (currentOrder != null) {
//       print('UPI ID: "${currentOrder!.upiId}"');
//       print('UPI ID isEmpty: ${currentOrder!.upiId.isEmpty}');
//       print('UPI ID isNotEmpty: ${currentOrder!.upiId.isNotEmpty}');
//       print('Billing Details:');
//       print('- Total Items: ${currentOrder!.billingDetails.totalItems}');
//       print('- Sub Total: "${currentOrder!.billingDetails.subTotal}"');
//       print('- Platform Fee: "${currentOrder!.billingDetails.platformFee}"');
//       print(
//         '- Delivery Charge: "${currentOrder!.billingDetails.deliveryCharge}"',
//       );
//       print('- Total Paid: "${currentOrder!.billingDetails.totalPaid}"');
//     }
//     print('========================');
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _openGoogleMaps(location) async {
//     try {
//       // Enhanced debugging for location object
//       print('=== LOCATION DEBUG INFO ===');
//       print('Location object type: ${location.runtimeType}');
//       print('Location object: $location');

//       try {
//         if (location != null) {
//           var coords = location.coordinates ?? location.cordinates;
//           print('Location coordinates: $coords');

//           try {
//             print('Location toString: ${location.toString()}');
//           } catch (_) {}
//         }
//       } catch (e) {
//         print('Error accessing location properties: $e');
//       }
//       print('===========================');

//       // Check for coordinates (handle both possible spellings)
//       List<dynamic>? coords = location?.coordinates ?? location?.cordinates;

//       if (coords != null && coords.length >= 2) {
//         final double latitude = coords[1].toDouble();
//         final double longitude = coords[0].toDouble();

//         print('Extracted coordinates - Lat: $latitude, Lng: $longitude');

//         final String googleMapsUrl =
//             'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

//         final String googleMapsAppUrl =
//             'google.navigation:q=$latitude,$longitude';

//         bool launched = false;

//         // Try different approaches for launching maps
//         try {
//           print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
//           // First try the Google Maps app URL scheme
//           if (await canLaunchUrl(Uri.parse(googleMapsAppUrl))) {
//             launched = await launchUrl(
//               Uri.parse(googleMapsAppUrl),
//               mode: LaunchMode.externalApplication,
//             );
//             print('Launched Google Maps app successfully');
//           }
//         } catch (e) {
//           print('Could not launch Google Maps app: $e');
//         }

//         // If app didn't launch, try web version
//         if (!launched) {
//           try {
//             if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
//               launched = await launchUrl(
//                 Uri.parse(googleMapsUrl),
//                 mode: LaunchMode.externalApplication,
//               );
//               print('Launched Google Maps web version successfully');
//             }
//           } catch (e) {
//             print('Could not launch Google Maps web: $e');
//           }
//         }

//         // Final fallback - try platform default
//         if (!launched) {
//           try {
//             launched = await launchUrl(
//               Uri.parse(googleMapsUrl),
//               mode: LaunchMode.platformDefault,
//             );
//             print('Launched with platform default');
//           } catch (e) {
//             print('Platform default launch failed: $e');
//           }
//         }

//         if (!launched) {
//           _showErrorSnackbar(
//             'Could not open Google Maps. Please check if you have Google Maps installed.',
//           );
//         }
//       } else {
//         print('Invalid coordinates: $coords');
//         _showErrorSnackbar(
//           'Location coordinates are not available or invalid.',
//         );
//       }
//     } catch (e) {
//       print('Failed to open Google Maps: $e');
//       _showErrorSnackbar('Failed to open Google Maps: $e');
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: EdgeInsets.all(16),
//       ),
//     );
//   }



//   String _getCleanAmount(String totalPaid) {
//   if (totalPaid.isEmpty) {
//     // Fallback to order total amount
//     return (currentOrder!.order.totalAmount / 100).toStringAsFixed(2);
//   }
  
//   // Remove currency symbols and clean the string
//   String cleaned = totalPaid
//       .replaceAll('₹', '')
//       .replaceAll(',', '')
//       .replaceAll(RegExp(r'[^\d.]'), '') // Remove any non-digit, non-decimal characters
//       .trim();
  
//   // If still empty, use fallback
//   if (cleaned.isEmpty) {
//     return (currentOrder!.order.totalAmount / 100).toStringAsFixed(2);
//   }
  
//   // Try to parse and format as proper decimal
//   try {
//     double amount = double.parse(cleaned);
//     return amount.toStringAsFixed(2);
//   } catch (e) {
//     print('Error parsing amount: $e');
//     return (currentOrder!.order.totalAmount / 100).toStringAsFixed(2);
//   }
// }

//   // Future<void> _handleOrderDelivered() async {
//   //   final orderDeliveredProvider = Provider.of<OrderDeliveredProvider>(
//   //     context,
//   //     listen: false,
//   //   );

//   //   // Show loading dialog
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (BuildContext context) {
//   //       return const AlertDialog(
//   //         content: Row(
//   //           children: [
//   //             CircularProgressIndicator(color: Color(0xFF5931DD)),
//   //             SizedBox(width: 20),
//   //             Text('Marking order as delivered...'),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );

//   //   try {

//   //     RiderModel?riderModel;
//   //     // final data = SharedPreferenceService.getRiderData();


//   //     final success = await orderDeliveredProvider.deliverOrder(
//   //       orderId: widget.orderId,
//   //     );

//   //     // Close loading dialog
//   //     if (mounted) Navigator.of(context).pop();

//   //     if (success) {
//   //       // Show success message
//   //       if (mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(
//   //             content: Text(orderDeliveredProvider.message),
//   //             backgroundColor: Colors.green,
//   //           ),
//   //         );

//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (context) => ImageShowingScreen(orderId: widget.orderId,userid: riderModel!.id,),
//   //           ),
//   //         );
//   //         // Navigate back or to next screen
//   //       }
//   //     } else {
//   //       // Show error message
//   //       if (mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(
//   //             content: Text(
//   //               orderDeliveredProvider.message.isNotEmpty
//   //                   ? orderDeliveredProvider.message
//   //                   : 'Failed to deliver order',
//   //             ),
//   //             backgroundColor: Colors.red,
//   //           ),
//   //         );
//   //       }
//   //     }
//   //   } catch (e) {
//   //     // Close loading dialog
//   //     if (mounted) Navigator.of(context).pop();

//   //     // Show error message
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text('Error: ${e.toString()}'),
//   //           backgroundColor: Colors.red,
//   //         ),
//   //       );
//   //     }
//   //   }
//   // }



//   Future<void> _handleOrderDelivered() async {
//   final orderDeliveredProvider = Provider.of<OrderDeliveredProvider>(
//     context,
//     listen: false,
//   );

//   // Show loading dialog
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return const AlertDialog(
//         content: Row(
//           children: [
//             CircularProgressIndicator(color: Color(0xFF5931DD)),
//             SizedBox(width: 20),
//             Text('Marking order as delivered'),
//           ],
//         ),
//       );
//     },
//   );

//   try {
//     // SOLUTION 1: Get rider data from SharedPreferences (await the Future)
//     RiderModel? riderModel;
//     try {
//       riderModel = await SharedPreferenceService.getRiderData();
//     } catch (e) {
//       print('Error getting rider data: $e');
//     }

//     final success = await orderDeliveredProvider.deliverOrder(
//       orderId: widget.orderId,
//     );

//     // Close loading dialog
//     if (mounted) Navigator.of(context).pop();

//     if (success) {
//       // Show success message
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(orderDeliveredProvider.message),
//             backgroundColor: Colors.green,
//           ),
//         );

//         // SOLUTION 1: Check if riderModel is not null before navigation
//         if (riderModel != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ImageShowingScreen(
//                 orderId: widget.orderId,
//                 userid: riderModel!.id,
//               ),
//             ),
//           );
//         } else {
//           // SOLUTION 2: Fallback - navigate without userid or show error
//           print('Warning: Rider model is null, navigating without userid');
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ImageShowingScreen(
//                 orderId: widget.orderId,
//                 userid: '', // Or handle this in ImageShowingScreen
//               ),
//             ),
//           );
          
//           // Or show error message:
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(
//           //     content: Text('Unable to get rider information'),
//           //     backgroundColor: Colors.orange,
//           //   ),
//           // );
//         }
//       }
//     } else {
//       // Show error message
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               orderDeliveredProvider.message.isNotEmpty
//                   ? orderDeliveredProvider.message
//                   : 'Failed to deliver order',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   } catch (e) {
//     // Close loading dialog
//     if (mounted) Navigator.of(context).pop();

//     // Show error message
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: const Text(
//             'Drop Details!',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Consumer2<AcceptPickupProvider, OrderDeliveredProvider>(
//         builder: (context, acceptProvider, orderDeliveredProvider, child) {
//           if (isLoading || acceptProvider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF5931DD)),
//             );
//           }

//           if (acceptProvider.errorMessage.isNotEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
//                   const SizedBox(height: 16),
//                   Text(
//                     acceptProvider.errorMessage,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       acceptProvider.refreshData();
//                       _loadOrderData();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF5931DD),
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           currentOrder = acceptProvider.getOrderById(widget.orderId);

//           if (currentOrder == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Order not found',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Map area
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   child: Image.asset(
//                     'assets/mapimage.png',
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[300],
//                         child: const Center(
//                           child: Icon(Icons.map, size: 50, color: Colors.grey),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 // Main content
//                 Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Drop section
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF5931DD).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(6),
//                                 border: Border.all(
//                                   color: const Color(
//                                     0xFF5931DD,
//                                   ).withOpacity(0.3),
//                                   width: 1,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.location_on_outlined,
//                                     color: const Color(0xFF5931DD),
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 6),
//                                   const Text(
//                                     'Drop',
//                                     style: TextStyle(
//                                       color: Color(0xFF5931DD),
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Customer details
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               currentOrder!.order.userId.name,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               currentOrder!.order.deliveryAddress.fullAddress,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Order: ${currentOrder!.order.id}',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // How To Reach section
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'How To Reach:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             // Action buttons
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _buildActionButton(
//                                     context: context,
//                                     icon: Icons.call,
//                                     label: 'Call',
//                                     onTap: () {
//                                       _showHelpModal(context);
//                                       // _makePhoneCall(currentOrder!.order.userId.mobile);
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _buildActionButton(
//                                     context: context,
//                                     icon: Icons.chat_bubble_outline,
//                                     label: 'Chat',
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => ChatScreen(
//                                             userId: currentOrder!.order.id ,
//                                             chatPartnerName: currentOrder!.order.userId.name,
//                                             riderId: currentOrder!.order.assignedRider,
//                                             currentUserType: 'rider',
                                            
//                                             // orderId: currentOrder!.order.id,
//                                             // customerName: currentOrder!.order.userId.name,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _buildActionButton(
//                                     context: context,
//                                     icon: Icons.map_outlined,
//                                     label: 'Map',
//                                     onTap: () {
//                                       _openGoogleMaps(
//                                         currentOrder?.order.userId.location,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       //  ImageUploadWidget(
//                       //   userId: currentOrder!.order.userId.id,
//                       //   orderId: widget.orderId,
//                       //   onUploadSuccess: () {

//                       //     print('Image uploaded successfully for order: ${widget.orderId}');
//                       //   },
//                       // ),
//                       const SizedBox(height: 20),

//                       // Payment status
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 currentOrder!.order.paymentMethod ==
//                                     "Cash on Delivery"
//                                 ? const Color(0xFFF0F9F0)
//                                 : const Color(0xFFE3F2FD),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color:
//                                   currentOrder!.order.paymentMethod ==
//                                       "Cash on Delivery"
//                                   ? const Color(0xFFE0F2E0)
//                                   : const Color(0xFFBBDEFB),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 20,
//                                 height: 20,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(),
//                                   color:
//                                       currentOrder!.order.paymentMethod ==
//                                           "Cash on Delivery"
//                                       ? const Color(0xFF4CAF50)
//                                       : const Color(0xFF2196F3),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child:
//                                     currentOrder!.order.paymentMethod !=
//                                         "Cash on Delivery"
//                                     ? const Icon(
//                                         Icons.check,
//                                         color: Colors.white,
//                                         size: 14,
//                                       )
//                                     : null,
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 currentOrder!.order.paymentMethod,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // QR Code section
//                       if (currentOrder!.upiId.isNotEmpty) ...[
//                         const SizedBox(height: 20),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Column(
//                             children: [
//                               Text(
//                                 'Scan QR for Payment',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.grey[700],
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: Colors.grey[300]!),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     QrImageView(
//                                       data:
//                                           'upi://pay?pa=${currentOrder!.upiId}&am=${currentOrder!.billingDetails.totalPaid.replaceAll('₹', '').replaceAll(',', '')}&cu=INR',
//                                       version: QrVersions.auto,
//                                       size: 200.0,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                     const SizedBox(height: 12),
//                                     Text(
//                                       'UPI ID: ${currentOrder!.upiId}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Amount: ${currentOrder!.billingDetails.totalPaid}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ] else ...[
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Image.asset('assets/scannerimage.png'),
//                         ),
//                       ],

//                       const SizedBox(height: 20),

//                       // Bill details
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[50],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           children: [
//                             // _buildBillRow(
//                             //   'Total Items',
//                             //   currentOrder!.billingDetails.totalItems > 0
//                             //       ? currentOrder!.billingDetails.totalItems
//                             //             .toString()
//                             //       : '',
//                             // ),
//                             // _buildBillRow(
//                             //   'Sub Total',
//                             //   currentOrder!.billingDetails.subTotal.isNotEmpty
//                             //       ? currentOrder!.billingDetails.subTotal
//                             //       : '₹${(currentOrder!.order.totalAmount / 100).toStringAsFixed(2)}',
//                             // ),
//                             // _buildBillRow(
//                             //   'Platform fee',
//                             //   currentOrder!
//                             //           .billingDetails
//                             //           .platformFee
//                             //           .isNotEmpty
//                             //       ? currentOrder!.billingDetails.platformFee
//                             //       : '',
//                             // ),
//                             // _buildBillRow(
//                             //   'Delivery charge',
//                             //   currentOrder!
//                             //           .billingDetails
//                             //           .deliveryCharge
//                             //           .isNotEmpty
//                             //       ? currentOrder!.billingDetails.deliveryCharge
//                             //       : '',
//                             // ),
//                             // const Divider(height: 20),
                   
//                             _buildBillRow(
//                               'Total Paid',
//                               currentOrder!.billingDetails.subTotal.isNotEmpty
//                                   ? currentOrder!.billingDetails.subTotal
//                                   : '₹${(currentOrder!.order.totalAmount).toStringAsFixed(2)}',
//                               isTotal: true,
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),
//                       Container(
//                         width: double.infinity,
//                         margin: const EdgeInsets.all(20),
//                         child: Dismissible(
//                           key: const ValueKey("orderDelivered"),
//                           direction: DismissDirection
//                               .startToEnd, // swipe left to right
//                           confirmDismiss: (_) async {
//                             if (!orderDeliveredProvider.isLoading) {
//                               _handleOrderDelivered();
//                             }
//                             return false; // ❌ prevent actual dismissal (keeps widget in tree)
//                           },
//                           background: Container(
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF5931DD),
//                               borderRadius: BorderRadius.circular(35),
//                             ),
//                             alignment: Alignment.centerLeft,
//                             padding: const EdgeInsets.only(left: 20),
//                             child: const Icon(
//                               Icons.keyboard_double_arrow_right,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: orderDeliveredProvider.isLoading
//                                   ? Colors.grey
//                                   : const Color(0xFF5931DD),
//                               borderRadius: BorderRadius.circular(35),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 16,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: orderDeliveredProvider.isLoading
//                                       ? const SizedBox(
//                                           width: 20,
//                                           height: 20,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             color: Color(0xFF5931DD),
//                                           ),
//                                         )
//                                       : const Icon(
//                                           Icons.keyboard_double_arrow_right,
//                                           color: Colors.deepPurple,
//                                           size: 20,
//                                         ),
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       orderDeliveredProvider.isLoading
//                                           ? 'Delivering...'
//                                           : 'Order Delivered',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showHelpModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header with handle
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 32,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Title
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24),
//                 child: Text(
//                   'How can we help?',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               const Divider(),

//               const SizedBox(height: 24),

//               // Help Center option
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: ListTile(
//                   leading: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.help_outline,
//                       color: Colors.black,
//                       size: 20,
//                     ),
//                   ),
//                   title: const Text(
//                     'Help Center',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   subtitle: Text(
//                     'Find answers to queries and raise ticket',
//                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Add help center navigation logic here
//                   },
//                 ),
//               ),

//               const Divider(),

//               // Support tickets option
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: ListTile(
//                   leading: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.headset_mic_outlined,
//                       color: Colors.black,
//                       size: 20,
//                     ),
//                   ),
//                   title: const Text(
//                     'Support tickets',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   subtitle: Text(
//                     'Check status of tickets raised',
//                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Add support tickets navigation logic here
//                   },
//                 ),
//               ),

//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildActionButton({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: const Color(0xFF5931DD), size: 24),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBillRow(String label, String amount, {bool isTotal = false}) {
         
//          print('totalllllllllllllllllll $isTotal');
//         print('priceeeeeeeeeeeeeeeeeeeeeeee  $amount');



//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: isTotal ? Colors.black : Colors.grey[600],
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             amount,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.black,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
