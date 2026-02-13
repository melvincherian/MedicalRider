
// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/home/navbar_screen.dart';
// import 'package:medical_delivery_app/models/new_order_model.dart';
// import 'package:medical_delivery_app/widget/confirm_order_modal.dart';
// import 'package:provider/provider.dart';
// import 'package:medical_delivery_app/providers/new_order_provider.dart';

// class OrderModal extends StatefulWidget {
//   final NewOrder order;
//   final String riderId; // Add riderId parameter
//   final VoidCallback? onOrderAccepted;
//   final VoidCallback? onOrderRejected;

//   const OrderModal({
//     super.key,
//     required this.order,
//     required this.riderId,
//     this.onOrderAccepted,
//     this.onOrderRejected,
//   });

//   @override
//   State<OrderModal> createState() => _OrderModalState();
// }

// class _OrderModalState extends State<OrderModal> {
//   bool _isAccepting = false;
//   bool _isRejecting = false;
//   String? _selectedPharmacyId;

//   @override
//   void initState() {
//     super.initState();
//     // Debug print to check pharmacies
//     print('=== ORDER MODAL INIT ===');
//     print('Order ID: ${widget.order.id}');
//     print('Pharmacies count: ${widget.order.pharmacyPickups.length}');
//     for (var i = 0; i < widget.order.pharmacyPickups.length; i++) {
//       print('Pharmacy $i: ${widget.order.pharmacyPickups[i].pharmacyName} - ID: ${widget.order.pharmacyPickups[i].pharmacyId}');
//     }
//     print('========================');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NewOrderProvider>(
//       builder: (context, provider, child) {
//         final order = widget.order;

//         print('=== ORDER MODAL DEBUG ===');
//         print('Order ID: ${order.id}');
//         print('Order Status: "${order.status}"');
//         print('Pharmacies Count: ${order.pharmacyPickups.length}');
//         print('========================');

//         // Check if order can be accepted/rejected
//         final canAcceptReject = order.assignedRiderStatus.toLowerCase() == 'assigned';

//         return Container(
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Handle bar
//               Container(
//                 margin: const EdgeInsets.only(top: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),

//               // Header with Reject button
//               if (canAcceptReject)
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: _isRejecting
//                             ? null
//                             : () {
//                                 _handleRejectOrder(context, provider, order.id);
//                               },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: _isRejecting ? Colors.grey : Colors.red,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: _isRejecting
//                               ? const SizedBox(
//                                   width: 16,
//                                   height: 16,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.red,
//                                     ),
//                                   ),
//                                 )
//                               : const Text(
//                                   'Reject',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 20),

//                       // Order status badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[400]!),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Text(
//                           order.assignedRiderStatus.toLowerCase() == 'assigned'
//                               ? 'New Order!'
//                               : order.assignedRiderStatus,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 30),

//                       // Estimated Earning
//                       const Text(
//                         'ESTIMATED EARNING',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 1,
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       Text(
//                         '₹${order.estimatedEarning.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const Divider(),
//                       const SizedBox(height: 20),

//                       // Order details card
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[50],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: const Color.fromARGB(255, 117, 117, 117),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Order info
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 8,
//                                   height: 8,
//                                   decoration: const BoxDecoration(
//                                     color: Colors.deepPurple,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Order #${order.orderId.isNotEmpty ? order.orderId : order.id.substring(0, 8)}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       order.paymentMethod,
//                                       style: const TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 16),

//                             // Delivery location info
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 8,
//                                   height: 8,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[400],
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _formatAddress(order.deliveryAddress),
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 16),

//                             // Customer info
//                             const Divider(),
//                             const SizedBox(height: 12),
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 20,
//                                   backgroundImage: order.user.profileImage.isNotEmpty
//                                       ? NetworkImage(order.user.profileImage)
//                                       : null,
//                                   child: order.user.profileImage.isEmpty
//                                       ? const Icon(Icons.person)
//                                       : null,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         order.user.name,
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       Text(
//                                         order.user.mobile,
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Pharmacy Pickup Section - Only show if order can be accepted/rejected
//                       if (order.pharmacyPickups.isNotEmpty && canAcceptReject) ...[
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.blue.withOpacity(0.1),
//                                 Colors.blue.withOpacity(0.05),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.blue.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.local_pharmacy,
//                                     color: Colors.blue[700],
//                                     size: 24,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   const Text(
//                                     'Select Pickup Pharmacy',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Tap to choose one pharmacy (${order.pharmacyPickups.length} available)',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               if (_selectedPharmacyId != null)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.check_circle,
//                                         color: Colors.green[600],
//                                         size: 16,
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         'Pharmacy selected',
//                                         style: TextStyle(
//                                           fontSize: 11,
//                                           color: Colors.green[700],
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Pharmacy List
//                         ...order.pharmacyPickups.asMap().entries.map((entry) {
//                           final pharmacy = entry.value;
//                           final isSelected = _selectedPharmacyId == pharmacy.pharmacyId;
                          
//                           print('Pharmacy ${entry.key}: ${pharmacy.pharmacyName}, ID: ${pharmacy.pharmacyId}, Selected: $isSelected');
                          
//                           return GestureDetector(
//                             onTap: () {
//                               print('Tapped pharmacy: ${pharmacy.pharmacyName}, ID: ${pharmacy.pharmacyId}');
//                               setState(() {
//                                 _selectedPharmacyId = pharmacy.pharmacyId;
//                               });
//                               print('Selected pharmacy ID updated to: $_selectedPharmacyId');
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               padding: const EdgeInsets.all(14),
//                               decoration: BoxDecoration(
//                                 color: isSelected 
//                                     ? Colors.blue.withOpacity(0.1)
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: isSelected 
//                                       ? Colors.blue
//                                       : Colors.grey[300]!,
//                                   width: isSelected ? 2 : 1.5,
//                                 ),
//                                 boxShadow: [
//                                   if (isSelected)
//                                     BoxShadow(
//                                       color: Colors.blue.withOpacity(0.2),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                 ],
//                               ),
//                               child: Row(
//                                 children: [
//                                   // Selection indicator
//                                   Container(
//                                     width: 24,
//                                     height: 24,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: isSelected 
//                                             ? Colors.blue
//                                             : Colors.grey[400]!,
//                                         width: 2,
//                                       ),
//                                       color: isSelected 
//                                           ? Colors.blue
//                                           : Colors.transparent,
//                                     ),
//                                     child: isSelected
//                                         ? const Icon(
//                                             Icons.check,
//                                             size: 16,
//                                             color: Colors.white,
//                                           )
//                                         : null,
//                                   ),
//                                   const SizedBox(width: 12),
                                  
//                                   // Pharmacy image
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: Colors.grey[200],
//                                     ),
//                                     child: pharmacy.pharmacyImage.isNotEmpty
//                                         ? ClipRRect(
//                                             borderRadius: BorderRadius.circular(8),
//                                             child: Image.network(
//                                               pharmacy.pharmacyImage,
//                                               fit: BoxFit.cover,
//                                               errorBuilder: (context, error, stackTrace) {
//                                                 return const Icon(
//                                                   Icons.local_pharmacy,
//                                                   size: 25,
//                                                   color: Colors.deepPurple,
//                                                 );
//                                               },
//                                             ),
//                                           )
//                                         : const Icon(
//                                             Icons.local_pharmacy,
//                                             size: 25,
//                                             color: Colors.deepPurple,
//                                           ),
//                                   ),
//                                   const SizedBox(width: 12),

//                                   // Pharmacy details
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           pharmacy.pharmacyName,
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: isSelected ? Colors.blue[900] : Colors.black87,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           pharmacy.pharmacyAddress,
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey[600],
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Row(
//                                           children: [
//                                             Icon(
//                                               Icons.medication,
//                                               size: 14,
//                                               color: isSelected ? Colors.blue[700] : Colors.grey[600],
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               '${pharmacy.totalItems} items • ${pharmacy.medicines.length} medicines',
//                                               style: TextStyle(
//                                                 fontSize: 11,
//                                                 color: isSelected ? Colors.blue[700] : Colors.grey[600],
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
                                  
//                                   // Arrow indicator
//                                   Icon(
//                                     Icons.arrow_forward_ios,
//                                     size: 16,
//                                     color: isSelected ? Colors.blue : Colors.grey[400],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ],

//                       // Order Items Section
//                       if (order.orderItems.isNotEmpty) ...[
//                         const SizedBox(height: 16),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.deepPurple.withOpacity(0.1),
//                                 Colors.deepPurple.withOpacity(0.05),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.deepPurple.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.shopping_bag_outlined,
//                                     color: Colors.deepPurple[700],
//                                     size: 24,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   const Text(
//                                     'Order Items',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${order.orderItems.length} ${order.orderItems.length == 1 ? 'Item' : 'Items'}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Items List
//                         ...order.orderItems.map((item) {
//                           return Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: Colors.grey[300]!,
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 // Item image
//                                 Container(
//                                   width: 60,
//                                   height: 60,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: Colors.grey[200],
//                                   ),
//                                   child: item.images.isNotEmpty
//                                       ? ClipRRect(
//                                           borderRadius: BorderRadius.circular(8),
//                                           child: Image.network(
//                                             item.images.first,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return const Icon(
//                                                 Icons.medication,
//                                                 size: 30,
//                                               );
//                                             },
//                                           ),
//                                         )
//                                       : const Icon(
//                                           Icons.medication,
//                                           size: 30,
//                                         ),
//                                 ),
//                                 const SizedBox(width: 12),

//                                 // Item details
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         item.name,
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         'Qty: ${item.quantity}',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // Item price
//                                 Text(
//                                   '₹${item.price.toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.deepPurple,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),

//                         const SizedBox(height: 16),

//                         // Total Amount
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.deepPurple.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                               color: Colors.deepPurple.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Total Amount',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 '₹${order.totalAmount.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.deepPurple,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],

//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ),

//               // Bottom action buttons
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 1,
//                       blurRadius: 10,
//                       offset: const Offset(0, -3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Accept Order button
//                     if (canAcceptReject)
//                       SizedBox(
//                         width: double.infinity,
//                         child: GestureDetector(
//                           onTap: _isAccepting || _selectedPharmacyId == null
//                               ? null
//                               : () => _handleAcceptOrder(context, provider, order),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 18),
//                             decoration: BoxDecoration(
//                               color: _isAccepting || _selectedPharmacyId == null
//                                   ? Colors.grey[300]
//                                   : const Color(0xFF5931DD),
//                               borderRadius: BorderRadius.circular(14),
//                               boxShadow: !_isAccepting && _selectedPharmacyId != null
//                                   ? [
//                                       BoxShadow(
//                                         color: const Color(0xFF5931DD).withOpacity(0.3),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 4),
//                                       ),
//                                     ]
//                                   : null,
//                             ),
//                             child: _isAccepting
//                                 ? const Center(
//                                     child: SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 : Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(
//                                         Icons.check_circle_outline,
//                                         color: Colors.white,
//                                         size: 22,
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Text(
//                                         _selectedPharmacyId == null
//                                             ? 'Select a Pharmacy First'
//                                             : 'Accept Order',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ),
//                       ),

//                     // Show current status if not pending
//                     if (!canAcceptReject)
//                       GestureDetector(
//                         onTap: () {
//                           if (order.assignedRiderStatus.toLowerCase() == 'rejected') {
//                             Navigator.of(context).pop();
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const NavbarScreen(),
//                               ),
//                             );
//                           }
//                         },
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: _getStatusColor(order.status),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Order Status: ${order.assignedRiderStatus}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _handleAcceptOrder(
//     BuildContext context,
//     NewOrderProvider provider,
//     NewOrder order,
//   ) async {
//     if (_selectedPharmacyId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a pharmacy first'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isAccepting = true;
//     });

//     try {
//       final success = await provider.updateOrderStatusWithPharmacy(
//         riderId: widget.riderId,
//         orderId: order.id,
//         status: 'Accepted',
//         pharmacyId: _selectedPharmacyId,
//       );

//       if (success) {
//         // if (!mounted) return;

//         // // Call the callback
//         // widget.onOrderAccepted?.call();

//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(
//         //     content: Text(provider.updateMessage),
//         //     backgroundColor: Colors.green,
//         //   ),
//         // );

//         // Close modal
//         Navigator.of(context).pop();

//         // // Navigate to Pickup Screen
//         await Future.delayed(const Duration(milliseconds: 300));
        
//         // if (!mounted) return;

//         // // Find the selected pharmacy
//         // final selectedPharmacy = order.pharmacyPickups.firstWhere(
//         //   (p) => p.pharmacyId == _selectedPharmacyId,
//         // );

//         // Navigate to pharmacy pickup screen
//         // Note: You'll need to adapt this based on your actual navigation structure
//         // and how you pass the order data to PharmacyPickupScreen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ConfirmOrderModal(
//               orderId: order.id,
//               riderId: widget.riderId,
//             ),
//           ),
//         );
//       } else {
//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               provider.updateMessage.isEmpty
//                   ? 'Failed to accept order'
//                   : provider.updateMessage,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error accepting order: $e');
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isAccepting = false;
//         });
//       }
//     }
//   }

//   Future<void> _handleRejectOrder(
//     BuildContext context,
//     NewOrderProvider provider,
//     String orderId,
//   ) async {
//     setState(() {
//       _isRejecting = true;
//     });

//     try {
//       final success = await provider.updateOrderStatusWithPharmacy(
//         riderId: widget.riderId,
//         orderId: orderId,
//         status: 'Rejected',
//       );

//       if (success) {
//         if (!mounted) return;

//         // Call the callback
//         widget.onOrderRejected?.call();

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(provider.updateMessage),
//             backgroundColor: Colors.orange,
//           ),
//         );

//         // Close modal
//         Navigator.of(context).pop();

//         // Navigate to home screen
//         await Future.delayed(const Duration(milliseconds: 300));
        
//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const NavbarScreen(),
//           ),
//         );
//       } else {
//         if (!mounted) return;

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               provider.updateMessage.isEmpty
//                   ? 'Failed to reject order'
//                   : provider.updateMessage,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error rejecting order: $e');
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isRejecting = false;
//         });
//       }
//     }
//   }

//   String _formatAddress(DeliveryAddress address) {
//     final parts = <String>[];
    
//     if (address.house.isNotEmpty) parts.add(address.house);
//     if (address.street.isNotEmpty) parts.add(address.street);
//     if (address.city.isNotEmpty) parts.add(address.city);
//     if (address.state.isNotEmpty) parts.add(address.state);
//     if (address.pincode.isNotEmpty) parts.add(address.pincode);
    
//     return parts.join(', ');
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'accepted':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       case 'pickedup':
//       case 'picked up':
//         return Colors.blue;
//       case 'delivered':
//         return Colors.deepPurple;
//       default:
//         return Colors.grey;
//     }
//   }
// }



















import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/navbar_screen.dart';
import 'package:medical_delivery_app/models/new_order_model.dart';
import 'package:medical_delivery_app/widget/confirm_order_modal.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/new_order_provider.dart';

class OrderModal extends StatefulWidget {
  final NewOrder order;
  final String riderId;
  final VoidCallback? onOrderAccepted;
  final VoidCallback? onOrderRejected;

  const OrderModal({
    super.key,
    required this.order,
    required this.riderId,
    this.onOrderAccepted,
    this.onOrderRejected,
  });

  @override
  State<OrderModal> createState() => _OrderModalState();
}

class _OrderModalState extends State<OrderModal> {
  bool _isAccepting = false;
  bool _isRejecting = false;
  String? _selectedPharmacyId;

  @override
  void initState() {
    super.initState();
    print('=== ORDER MODAL INIT ===');
    print('Order ID: ${widget.order.id}');
    print('Pharmacies count: ${widget.order.pharmacyPickups.length}');
    for (var i = 0; i < widget.order.pharmacyPickups.length; i++) {
      print('Pharmacy $i: ${widget.order.pharmacyPickups[i].pharmacyName} - ID: ${widget.order.pharmacyPickups[i].pharmacyId}');
    }
    print('========================');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewOrderProvider>(
      builder: (context, provider, child) {
        final order = widget.order;

        print('=== ORDER MODAL DEBUG ===');
        print('Order ID: ${order.id}');
        print('Order Status: "${order.status}"');
        print('Pharmacies Count: ${order.pharmacyPickups.length}');
        print('========================');

        final canAcceptReject = order.assignedRiderStatus.toLowerCase() == 'assigned';

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              if (canAcceptReject)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _isRejecting
                            ? null
                            : () {
                                _handleRejectOrder(context, provider, order.id);
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _isRejecting ? Colors.grey : Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isRejecting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Reject',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          order.assignedRiderStatus.toLowerCase() == 'assigned'
                              ? 'New Order!'
                              : order.assignedRiderStatus,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'ESTIMATED EARNING',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '₹${order.estimatedEarning.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color.fromARGB(255, 117, 117, 117),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.deepPurple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${order.orderId.isNotEmpty ? order.orderId : order.id.substring(0, 8)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      order.paymentMethod,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatAddress(order.deliveryAddress),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: order.user.profileImage.isNotEmpty
                                      ? NetworkImage(order.user.profileImage)
                                      : null,
                                  child: order.user.profileImage.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.user.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        order.user.mobile,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (order.pharmacyPickups.isNotEmpty && canAcceptReject) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.1),
                                Colors.blue.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_pharmacy,
                                    color: Colors.blue[700],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Select Pickup Pharmacy',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to choose one pharmacy (${order.pharmacyPickups.length} available)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (_selectedPharmacyId != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green[600],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Pharmacy selected',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        ...order.pharmacyPickups.asMap().entries.map((entry) {
                          final pharmacy = entry.value;
                          final isSelected = _selectedPharmacyId == pharmacy.pharmacyId;
                          
                          return GestureDetector(
                            onTap: () {
                              print('Tapped pharmacy: ${pharmacy.pharmacyName}, ID: ${pharmacy.pharmacyId}');
                              setState(() {
                                _selectedPharmacyId = pharmacy.pharmacyId;
                              });
                              print('Selected pharmacy ID updated to: $_selectedPharmacyId');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected 
                                      ? Colors.blue
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1.5,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected 
                                            ? Colors.blue
                                            : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                      color: isSelected 
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: pharmacy.pharmacyImage.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              pharmacy.pharmacyImage,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.local_pharmacy,
                                                  size: 25,
                                                  color: Colors.deepPurple,
                                                );
                                              },
                                            ),
                                          )
                                        : const Icon(
                                            Icons.local_pharmacy,
                                            size: 25,
                                            color: Colors.deepPurple,
                                          ),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pharmacy.pharmacyName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected ? Colors.blue[900] : Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          pharmacy.pharmacyAddress,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.medication,
                                              size: 14,
                                              color: isSelected ? Colors.blue[700] : Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${pharmacy.totalItems} items • ${pharmacy.medicines.length} medicines',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isSelected ? Colors.blue[700] : Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: isSelected ? Colors.blue : Colors.grey[400],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],

                      if (order.orderItems.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.withOpacity(0.1),
                                Colors.deepPurple.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.deepPurple.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.deepPurple[700],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Order Items',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${order.orderItems.length} ${order.orderItems.length == 1 ? 'Item' : 'Items'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        ...order.orderItems.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                  ),
                                  child: item.images.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            item.images.first,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.medication,
                                                size: 30,
                                              );
                                            },
                                          ),
                                        )
                                      : const Icon(
                                          Icons.medication,
                                          size: 30,
                                        ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Qty: ${item.quantity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  '₹${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.deepPurple.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '₹${order.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canAcceptReject)
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: _isAccepting || _selectedPharmacyId == null
                              ? null
                              : () => _handleAcceptOrder(context, provider, order),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: _isAccepting || _selectedPharmacyId == null
                                  ? Colors.grey[300]
                                  : const Color(0xFF5931DD),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: !_isAccepting && _selectedPharmacyId != null
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF5931DD).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: _isAccepting
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _selectedPharmacyId == null
                                            ? 'Select a Pharmacy First'
                                            : 'Accept Order',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                    if (!canAcceptReject)
                      GestureDetector(
                        onTap: () {
                          if (order.assignedRiderStatus.toLowerCase() == 'rejected') {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NavbarScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Order Status: ${order.assignedRiderStatus}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAcceptOrder(
    BuildContext context,
    NewOrderProvider provider,
    NewOrder order,
  ) async {
    if (_selectedPharmacyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pharmacy first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('=== ACCEPTING ORDER ===');
    print('Order ID: ${order.id}');
    print('Rider ID: ${widget.riderId}');
    print('Selected Pharmacy ID: $_selectedPharmacyId');

    setState(() {
      _isAccepting = true;
    });

    try {
      final success = await provider.updateOrderStatusWithPharmacy(
        riderId: widget.riderId,
        orderId: order.id,
        status: 'Accepted',
        pharmacyId: _selectedPharmacyId,
      );



      print('Update status result: $success');
      print('Provider message: ${provider.updateMessage}');

              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmOrderModal(
                orderId: order.id,
                riderId: widget.riderId,
              ),
            ),
          );

      if (success && mounted) {
        // Call the callback first
        widget.onOrderAccepted?.call();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.updateMessage.isNotEmpty 
                ? provider.updateMessage 
                : 'Order accepted successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Close the current modal FIRST
        Navigator.of(context).pop();

        // Wait a bit for the modal to close
        await Future.delayed(const Duration(milliseconds: 300));

        // NOW navigate to ConfirmOrderModal
        if (mounted) {
          print('Navigating to ConfirmOrderModal...');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmOrderModal(
                orderId: order.id,
                riderId: widget.riderId,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                provider.updateMessage.isEmpty
                    ? 'Failed to accept order'
                    : provider.updateMessage,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error accepting order: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAccepting = false;
        });
      }
    }
  }

  Future<void> _handleRejectOrder(
    BuildContext context,
    NewOrderProvider provider,
    String orderId,
  ) async {
    setState(() {
      _isRejecting = true;
    });

    try {
      final success = await provider.updateOrderStatusWithPharmacy(
        riderId: widget.riderId,
        orderId: orderId,
        status: 'Rejected',
      );

      if (success) {
        if (!mounted) return;

        widget.onOrderRejected?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.updateMessage),
            backgroundColor: Colors.orange,
          ),
        );

        Navigator.of(context).pop();

        await Future.delayed(const Duration(milliseconds: 300));
        
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavbarScreen(),
          ),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.updateMessage.isEmpty
                  ? 'Failed to reject order'
                  : provider.updateMessage,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error rejecting order: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRejecting = false;
        });
      }
    }
  }

  String _formatAddress(DeliveryAddress address) {
    final parts = <String>[];
    
    if (address.house.isNotEmpty) parts.add(address.house);
    if (address.street.isNotEmpty) parts.add(address.street);
    if (address.city.isNotEmpty) parts.add(address.city);
    if (address.state.isNotEmpty) parts.add(address.state);
    if (address.pincode.isNotEmpty) parts.add(address.pincode);
    
    return parts.join(', ');
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pickedup':
      case 'picked up':
        return Colors.blue;
      case 'delivered':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}