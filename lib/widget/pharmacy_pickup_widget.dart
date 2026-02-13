
// // import 'package:flutter/material.dart';
// // import 'package:medical_delivery_app/models/order_model.dart';
// // import 'package:provider/provider.dart';
// // import 'package:medical_delivery_app/providers/new_order_provider.dart';
// // import 'package:medical_delivery_app/widget/confirm_order_modal.dart';

// // class PharmacyPickupScreen extends StatefulWidget {
// //   final String orderId;

// //   const PharmacyPickupScreen({
// //     super.key,
// //     required this.orderId,
// //   });

// //   @override
// //   State<PharmacyPickupScreen> createState() => _PharmacyPickupScreenState();
// // }

// // class _PharmacyPickupScreenState extends State<PharmacyPickupScreen> {
// //   String? selectedPharmacyId;
// //   bool isConfirming = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<NewOrderProvider>(
// //       builder: (context, provider, child) {
// //         final order = provider.getOrderById(widget.orderId);

// //         if (order == null) {
// //           return Scaffold(
// //             appBar: AppBar(
// //               title: const Text('Order Not Found'),
// //             ),
// //             body: const Center(
// //               child: Text('Order not found'),
// //             ),
// //           );
// //         }

// //         // Filter pharmacies that have accepted the order
// //         final acceptedPharmacies = order.pharmacyResponses
// //             .where((response) => response.status.toLowerCase() == 'accepted')
// //             .toList();

// //         return Scaffold(
// //           backgroundColor: const Color(0xFFF8F9FA),
// //           appBar: AppBar(
// //             elevation: 0,
// //             backgroundColor: Colors.white,
// //             leading: IconButton(
// //               icon: const Icon(Icons.arrow_back, color: Colors.black87),
// //               onPressed: () => Navigator.pop(context),
// //             ),
// //             title: const Text(
// //               'Select Pickup Location',
// //               style: TextStyle(
// //                 color: Colors.black87,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             centerTitle: true,
// //           ),
// //           body: Column(
// //             children: [
// //               // Order Summary Card
// //               Container(
// //                 margin: const EdgeInsets.all(16),
// //                 padding: const EdgeInsets.all(20),
// //                 decoration: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                     colors: [Color(0xFF5931DD), Color(0xFF7B5AE8)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                   borderRadius: BorderRadius.circular(16),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: const Color(0xFF5931DD).withOpacity(0.3),
// //                       blurRadius: 12,
// //                       offset: const Offset(0, 4),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(12),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: const Icon(
// //                             Icons.receipt_long,
// //                             color: Colors.white,
// //                             size: 28,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               const Text(
// //                                 'Order Details',
// //                                 style: TextStyle(
// //                                   color: Colors.white70,
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w500,
// //                                   letterSpacing: 0.5,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 4),
// //                               Text(
// //                                 'Order #${order.id.substring(0, 8)}',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 18,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 12,
// //                             vertical: 6,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(20),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               const Icon(
// //                                 Icons.shopping_bag,
// //                                 color: Colors.white,
// //                                 size: 16,
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Text(
// //                                 '${order.orderItems.length} items',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w600,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     Container(
// //                       padding: const EdgeInsets.all(12),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.15),
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           const Icon(
// //                             Icons.location_on,
// //                             color: Colors.white,
// //                             size: 20,
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               'Delivering to: ${order.deliveryAddress.fullAddress}',
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 13,
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                               maxLines: 2,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Instructions Banner
// //               Container(
// //                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: Colors.blue.shade50,
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(color: Colors.blue.shade100),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.all(8),
// //                       decoration: BoxDecoration(
// //                         color: Colors.blue.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Icon(
// //                         Icons.info_outline,
// //                         color: Colors.blue.shade700,
// //                         size: 20,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     const Expanded(
// //                       child: Text(
// //                         'Select a pharmacy to navigate and pick up the order',
// //                         style: TextStyle(
// //                           fontSize: 13,
// //                           color: Color(0xFF1976D2),
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Section Header
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
// //                 child: Row(
// //                   children: [
// //                     const Text(
// //                       'Available Pharmacies',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w700,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 8,
// //                         vertical: 4,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.green.shade50,
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Text(
// //                         '${acceptedPharmacies.length} Ready',
// //                         style: TextStyle(
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.w600,
// //                           color: Colors.green.shade700,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Pharmacies List
// //               Expanded(
// //                 child: acceptedPharmacies.isEmpty
// //                     ? _buildEmptyState()
// //                     : ListView.builder(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 16,
// //                           vertical: 8,
// //                         ),
// //                         itemCount: acceptedPharmacies.length,
// //                         itemBuilder: (context, index) {
// //                           final pharmacyResponse = acceptedPharmacies[index];
// //                           final pharmacy = pharmacyResponse.pharmacyId;
// //                           final isSelected =
// //                               selectedPharmacyId == pharmacy.id.toString();

// //                           return GestureDetector(
// //                             onTap: () {
// //                               setState(() {
// //                                 selectedPharmacyId = pharmacy.id.toString();
// //                               });
// //                             },
// //                             child: AnimatedContainer(
// //                               duration: const Duration(milliseconds: 200),
// //                               margin: const EdgeInsets.only(bottom: 12),
// //                               padding: const EdgeInsets.all(18),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 borderRadius: BorderRadius.circular(16),
// //                                 border: Border.all(
// //                                   color: isSelected
// //                                       ? const Color(0xFF5931DD)
// //                                       : Colors.grey[200]!,
// //                                   width: isSelected ? 2.5 : 1.5,
// //                                 ),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: isSelected
// //                                         ? const Color(0xFF5931DD)
// //                                             .withOpacity(0.15)
// //                                         : Colors.grey.withOpacity(0.08),
// //                                     blurRadius: isSelected ? 12 : 8,
// //                                     offset: const Offset(0, 4),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Row(
// //                                     children: [
// //                                       // Pharmacy Icon
// //                                       Container(
// //                                         padding: const EdgeInsets.all(14),
// //                                         decoration: BoxDecoration(
// //                                           gradient: LinearGradient(
// //                                             colors: isSelected
// //                                                 ? [
// //                                                     const Color(0xFF5931DD),
// //                                                     const Color(0xFF7B5AE8)
// //                                                   ]
// //                                                 : [
// //                                                     Colors.grey[100]!,
// //                                                     Colors.grey[100]!,
// //                                                   ],
// //                                             begin: Alignment.topLeft,
// //                                             end: Alignment.bottomRight,
// //                                           ),
// //                                           borderRadius:
// //                                               BorderRadius.circular(12),
// //                                         ),
// //                                         child: Icon(
// //                                           Icons.local_pharmacy,
// //                                           color: isSelected
// //                                               ? Colors.white
// //                                               : Colors.grey[600],
// //                                           size: 28,
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 16),

// //                                       // Pharmacy Details
// //                                       Expanded(
// //                                         child: Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: [
// //                                             Row(
// //                                               children: [
// //                                                 Expanded(
// //                                                   child: Text(
// //                                                     pharmacy.name,
// //                                                     style: TextStyle(
// //                                                       fontSize: 16,
// //                                                       fontWeight:
// //                                                           FontWeight.w700,
// //                                                       color: isSelected
// //                                                           ? const Color(
// //                                                               0xFF5931DD)
// //                                                           : Colors.black87,
// //                                                     ),
// //                                                     maxLines: 2,
// //                                                     overflow:
// //                                                         TextOverflow.ellipsis,
// //                                                   ),
// //                                                 ),
// //                                                 if (isSelected)
// //                                                   Container(
// //                                                     padding:
// //                                                         const EdgeInsets.all(6),
// //                                                     decoration:
// //                                                         const BoxDecoration(
// //                                                       color: Color(0xFF5931DD),
// //                                                       shape: BoxShape.circle,
// //                                                     ),
// //                                                     child: const Icon(
// //                                                       Icons.check,
// //                                                       color: Colors.white,
// //                                                       size: 16,
// //                                                     ),
// //                                                   ),
// //                                               ],
// //                                             ),
// //                                             const SizedBox(height: 8),
// //                                             Row(
// //                                               children: [
// //                                                 Icon(
// //                                                   Icons.location_on,
// //                                                   size: 16,
// //                                                   color: Colors.grey[600],
// //                                                 ),
// //                                                 const SizedBox(width: 4),
// //                                                 Expanded(
// //                                                   child: Text(
// //                                                     pharmacy.address,
// //                                                     style: TextStyle(
// //                                                       fontSize: 13,
// //                                                       color: Colors.grey[700],
// //                                                       height: 1.3,
// //                                                     ),
// //                                                     maxLines: 2,
// //                                                     overflow:
// //                                                         TextOverflow.ellipsis,
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   const SizedBox(height: 12),
// //                                   // Status Badge
// //                                   Row(
// //                                     children: [
// //                                       Container(
// //                                         padding: const EdgeInsets.symmetric(
// //                                           horizontal: 10,
// //                                           vertical: 6,
// //                                         ),
// //                                         decoration: BoxDecoration(
// //                                           color: Colors.green.withOpacity(0.1),
// //                                           borderRadius:
// //                                               BorderRadius.circular(8),
// //                                         ),
// //                                         child: Row(
// //                                           mainAxisSize: MainAxisSize.min,
// //                                           children: [
// //                                             Container(
// //                                               width: 6,
// //                                               height: 6,
// //                                               decoration: const BoxDecoration(
// //                                                 color: Colors.green,
// //                                                 shape: BoxShape.circle,
// //                                               ),
// //                                             ),
// //                                             const SizedBox(width: 6),
// //                                             const Text(
// //                                               'Ready for pickup',
// //                                               style: TextStyle(
// //                                                 fontSize: 11,
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.green,
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                       const Spacer(),
// //                                       // Navigate Button
// //                                       if (isSelected)
// //                                         Container(
// //                                           padding: const EdgeInsets.symmetric(
// //                                             horizontal: 12,
// //                                             vertical: 6,
// //                                           ),
// //                                           decoration: BoxDecoration(
// //                                             color: const Color(0xFF5931DD)
// //                                                 .withOpacity(0.1),
// //                                             borderRadius:
// //                                                 BorderRadius.circular(8),
// //                                           ),
// //                                           child: const Row(
// //                                             mainAxisSize: MainAxisSize.min,
// //                                             children: [
// //                                               Icon(
// //                                                 Icons.navigation,
// //                                                 size: 14,
// //                                                 color: Color(0xFF5931DD),
// //                                               ),
// //                                               SizedBox(width: 4),
// //                                               Text(
// //                                                 'Navigate',
// //                                                 style: TextStyle(
// //                                                   fontSize: 11,
// //                                                   fontWeight: FontWeight.w600,
// //                                                   color: Color(0xFF5931DD),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //               ),

// //               // Bottom Confirm Button
// //               Container(
// //                 padding: const EdgeInsets.all(20),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.2),
// //                       spreadRadius: 1,
// //                       blurRadius: 10,
// //                       offset: const Offset(0, -3),
// //                     ),
// //                   ],
// //                 ),
// //                 child: SafeArea(
// //                   child: SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton(
// //                       onPressed: selectedPharmacyId == null || isConfirming
// //                           ? null
// //                           : () => _confirmAndNavigate(context, order),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFF5931DD),
// //                         disabledBackgroundColor: Colors.grey[300],
// //                         padding: const EdgeInsets.symmetric(vertical: 18),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(14),
// //                         ),
// //                         elevation: selectedPharmacyId != null ? 4 : 0,
// //                         shadowColor: const Color(0xFF5931DD).withOpacity(0.4),
// //                       ),
// //                       child: isConfirming
// //                           ? const SizedBox(
// //                               height: 20,
// //                               width: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2.5,
// //                                 valueColor: AlwaysStoppedAnimation<Color>(
// //                                   Colors.white,
// //                                 ),
// //                               ),
// //                             )
// //                           : Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 const Icon(
// //                                   Icons.check_circle_outline,
// //                                   color: Colors.white,
// //                                   size: 22,
// //                                 ),
// //                                 const SizedBox(width: 10),
// //                                 Text(
// //                                   selectedPharmacyId == null
// //                                       ? 'Select a pharmacy'
// //                                       : 'Proceed to Pickup',
// //                                   style: const TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.w600,
// //                                     letterSpacing: 0.5,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(24),
// //             decoration: BoxDecoration(
// //               color: Colors.grey[100],
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(
// //               Icons.local_pharmacy_outlined,
// //               size: 64,
// //               color: Colors.grey[400],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'No pharmacies available',
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w600,
// //               color: Colors.grey[700],
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Waiting for pharmacy confirmation',
// //             style: TextStyle(
// //               fontSize: 14,
// //               color: Colors.grey[500],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _confirmAndNavigate(
// //     BuildContext context,
// //     Order order,
// //   ) async {
// //     if (selectedPharmacyId == null) return;

// //     setState(() {
// //       isConfirming = true;
// //     });

// //     try {
// //       // Navigate to ConfirmOrderModal
// //       await Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => ConfirmOrderModal(orderId: order.id),
// //         ),
// //       );
// //     } catch (e) {
// //       print('Error navigating to confirm order: $e');
// //       if (!mounted) return;

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Row(
// //             children: [
// //               const Icon(Icons.error_outline, color: Colors.white),
// //               const SizedBox(width: 12),
// //               Expanded(child: Text('Error: ${e.toString()}')),
// //             ],
// //           ),
// //           backgroundColor: Colors.red,
// //           behavior: SnackBarBehavior.floating,
// //         ),
// //       );
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           isConfirming = false;
// //         });
// //       }
// //     }
// //   }
// // }


























// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/order_model.dart';
// import 'package:provider/provider.dart';
// import 'package:medical_delivery_app/providers/new_order_provider.dart';
// import 'package:medical_delivery_app/widget/confirm_order_modal.dart';
// import 'package:medical_delivery_app/widget/order_modal.dart';
// import 'package:medical_delivery_app/utils/pharmacy_pickup_manager.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class PharmacyPickupScreen extends StatefulWidget {
//   final String orderId;
//   final String pharmacyId;
//   final NewOrderItem orderItem;

//   const PharmacyPickupScreen({
//     super.key,
//     required this.orderId,
//     required this.pharmacyId,
//     required this.orderItem,
//   });

//   @override
//   State<PharmacyPickupScreen> createState() => _PharmacyPickupScreenState();
// }

// class _PharmacyPickupScreenState extends State<PharmacyPickupScreen> {
//   bool isConfirming = false;
//   File? _pickupImage;
//   bool _isUploadingImage = false;
//   bool _imageUploadedSuccessfully = false;
//   final ImagePicker _picker = ImagePicker();
//   final _pickupManager = PharmacyPickupManager();

//   PharmacyResponse? _getSelectedPharmacy() {
//     return widget.orderItem.order.pharmacyResponses.firstWhere(
//       (response) => response.pharmacyId.id == widget.pharmacyId,
//       orElse: () => widget.orderItem.order.pharmacyResponses.first,
//     );
//   }

//   List<OrderItem> _getPharmacyItems() {
//     final selectedPharmacy = _getSelectedPharmacy();
//     if (selectedPharmacy == null) return [];

//     return widget.orderItem.order.orderItems.where((item) {
//       return item.medicineId?.pharmacyId.id == selectedPharmacy.pharmacyId.id;
//     }).toList();
//   }

//   Future<void> _pickImage() async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           _pickupImage = File(pickedFile.path);
//           _imageUploadedSuccessfully = true;
//         });
        
//         _showSuccessSnackbar('Image captured successfully!');
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//       _showErrorSnackbar('Failed to pick image: $e');
//     }
//   }

//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedPharmacy = _getSelectedPharmacy();
//     final pharmacyItems = _getPharmacyItems();

//     if (selectedPharmacy == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Pharmacy Not Found'),
//         ),
//         body: const Center(
//           child: Text('Selected pharmacy not found'),
//         ),
//       );
//     }

//     final pharmacy = selectedPharmacy.pharmacyId;
//     final order = widget.orderItem.order;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Pharmacy Pickup',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Pharmacy Details Card
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF5931DD), Color(0xFF7B5AE8)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF5931DD).withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Icon(
//                         Icons.local_pharmacy,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Pickup Location',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             pharmacy.name,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           pharmacy.address,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Order Info Banner
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.receipt_long,
//                     color: Colors.blue.shade700,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Order #${order.id.substring(0, 8)}',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         '${pharmacyItems.length} items from this pharmacy',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Section Header
//           Padding(
//             padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
//             child: Row(
//               children: [
//                 const Text(
//                   'Items to Pickup',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${pharmacyItems.length}',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.orange.shade700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Items List
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               itemCount: pharmacyItems.length,
//               itemBuilder: (context, index) {
//                 final item = pharmacyItems[index];
//                 final medicine = item.medicineId;

//                 if (medicine == null) return const SizedBox.shrink();

//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey[200]!, width: 1.5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.08),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: medicine.images.isNotEmpty
//                               ? Image.network(
//                                   medicine.images.first,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return _buildErrorImage();
//                                   },
//                                 )
//                               : _buildErrorImage(),
//                         ),
//                       ),
//                       const SizedBox(width: 14),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               medicine.name,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               medicine.description,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 6),
//                             Row(
//                               children: [
//                                 Text(
//                                   '₹${medicine.mrp}',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF5931DD),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 3,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Text(
//                                     'Qty: ${item.quantity}',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Bottom Section - Image Upload and Confirm
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 1,
//                   blurRadius: 10,
//                   offset: const Offset(0, -3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Upload Image Button
//                 GestureDetector(
//                   onTap: _isUploadingImage || _imageUploadedSuccessfully
//                       ? null
//                       : _pickImage,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _imageUploadedSuccessfully
//                           ? Colors.green.shade50
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _imageUploadedSuccessfully
//                             ? Colors.green
//                             : Colors.grey[300]!,
//                         width: 1.5,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (_isUploadingImage)
//                           const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Color(0xFF5931DD),
//                             ),
//                           )
//                         else
//                           Icon(
//                             _imageUploadedSuccessfully
//                                 ? Icons.check_circle
//                                 : Icons.camera_alt,
//                             color: _imageUploadedSuccessfully
//                                 ? Colors.green
//                                 : Colors.grey[700],
//                             size: 22,
//                           ),
//                         const SizedBox(width: 10),
//                         Text(
//                           _isUploadingImage
//                               ? 'Uploading...'
//                               : _imageUploadedSuccessfully
//                                   ? 'Image Captured ✓'
//                                   : 'Capture Pickup Image',
//                           style: TextStyle(
//                             color: _imageUploadedSuccessfully
//                                 ? Colors.green
//                                 : Colors.grey[700],
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 // Confirm Pickup Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: !_imageUploadedSuccessfully || isConfirming
//                         ? null
//                         : () => _confirmPickup(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF5931DD),
//                       disabledBackgroundColor: Colors.grey[300],
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: _imageUploadedSuccessfully ? 4 : 0,
//                     ),
//                     child: isConfirming
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.5,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Colors.white,
//                               ),
//                             ),
//                           )
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.check_circle_outline,
//                                 color: Colors.white,
//                                 size: 22,
//                               ),
//                               const SizedBox(width: 10),
//                               Text(
//                                 !_imageUploadedSuccessfully
//                                     ? 'Capture image to continue'
//                                     : 'Confirm Pickup',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorImage() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: const Center(
//         child: Icon(Icons.local_pharmacy, color: Colors.white, size: 30),
//       ),
//     );
//   }

//   Future<void> _confirmPickup(BuildContext context) async {
//     if (!_imageUploadedSuccessfully) {
//       _showErrorSnackbar('Please capture an image first');
//       return;
//     }

//     setState(() {
//       isConfirming = true;
//     });

//     try {
//       // Mark this pharmacy as picked up using the manager
//       _pickupManager.markAsPickedUp(widget.pharmacyId);

//       // Show success message
//       _showSuccessSnackbar(
//         'Pickup confirmed! Proceeding to next pharmacy...',
//       );

//       await Future.delayed(const Duration(milliseconds: 800));

//       if (!mounted) return;

//       // Pop back to show the order modal with remaining pharmacies
//       Navigator.of(context).pop();
      
//       // Show order modal again with remaining pharmacies
//       await Future.delayed(const Duration(milliseconds: 300));
      
//       if (!mounted) return;
      
//       showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         isDismissible: false,
//         enableDrag: false,
//         builder: (context) => OrderModal(
//           orderItem: widget.orderItem,
//         ),
//       );

//     } catch (e) {
//       print('Error confirming pickup: $e');
//       if (!mounted) return;

//       _showErrorSnackbar('Error: ${e.toString()}');
//     } finally {
//       if (mounted) {
//         setState(() {
//           isConfirming = false;
//         });
//       }
//     }
//   }
// }