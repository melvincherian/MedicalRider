// // lib/widget/pharmacy_selection_modal.dart
// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/order_model.dart';
// import 'package:medical_delivery_app/providers/rider_order_provider.dart';
// import 'package:provider/provider.dart';

// class PharmacySelectionModal extends StatefulWidget {
//   final Order order;
//   final List<PharmacyResponse> pendingPharmacies;
//   final String riderId;

//   const PharmacySelectionModal({
//     super.key,
//     required this.order,
//     required this.pendingPharmacies,
//     required this.riderId,
//   });

//   @override
//   State<PharmacySelectionModal> createState() => _PharmacySelectionModalState();
// }

// class _PharmacySelectionModalState extends State<PharmacySelectionModal> {
//   bool _isProcessing = false;
//   String? _selectedPharmacyId;
//   String? _error;

//   String? _getPharmacyName(String pharmacyId) {
//     for (var item in widget.order.orderItems) {
//       if (item.medicineId?.pharmacyId.id == pharmacyId) {
//         return item.medicineId?.pharmacyId.name;
//       }
//     }
//     return 'Unknown Pharmacy';
//   }

//   List<Map<String, dynamic>> _getPharmacyItems(String pharmacyId) {
//     return widget.order.orderItems
//         .where((item) => item.medicineId?.pharmacyId.id == pharmacyId)
//         .map((item) => {
//               'name': item.medicineId?.name ?? item.name,
//               'quantity': item.quantity,
//               'image': item.medicineId?.images.isNotEmpty ?? false
//                   ? item.medicineId!.images.first
//                   : null,
//             })
//         .toList();
//   }

//   Future<void> _handlePharmacySelection(String pharmacyId) async {
//     setState(() {
//       _selectedPharmacyId = pharmacyId;
//       _error = null;
//     });
//   }

//   Future<void> _confirmSelection() async {
//     if (_selectedPharmacyId == null) {
//       setState(() {
//         _error = 'Please select a pharmacy';
//       });
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//       _error = null;
//     });

//     try {
//       final riderProvider = Provider.of<RiderProvider>(context, listen: false);
      
//       final success = await riderProvider.updateOrderStatus(
//         riderId: widget.riderId,
//         orderId: widget.order.id,
//         newStatus: 'Accepted',
//         pharmacyId: _selectedPharmacyId,
//       );

//       if (!mounted) return;

//       if (success) {
//         Navigator.pop(context, {
//           'success': true,
//           'pharmacyId': _selectedPharmacyId,
//         });
//       } else {
//         setState(() {
//           _error = riderProvider.error ?? 'Failed to update status';
//           _isProcessing = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isProcessing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Container(
//         width: double.infinity,
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 16),
            
//             const Text(
//               'Select Pharmacy to Pickup',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
            
//             Text(
//               '${widget.pendingPharmacies.length} pharmacies pending',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Pharmacy List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: widget.pendingPharmacies.length,
//                 itemBuilder: (context, index) {
//                   final pharmacy = widget.pendingPharmacies[index];
//                   final pharmacyName = _getPharmacyName(pharmacy.pharmacyId) ?? 'Pharmacy';
//                   final items = _getPharmacyItems(pharmacy.pharmacyId);
                  
//                   return GestureDetector(
//                     onTap: () => _handlePharmacySelection(pharmacy.pharmacyId),
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: _selectedPharmacyId == pharmacy.pharmacyId
//                             ? Colors.deepPurple.withOpacity(0.1)
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: _selectedPharmacyId == pharmacy.pharmacyId
//                               ? Colors.deepPurple
//                               : Colors.grey[300]!,
//                           width: _selectedPharmacyId == pharmacy.pharmacyId ? 2 : 1,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 40,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   color: Colors.deepPurple.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(
//                                   Icons.local_pharmacy,
//                                   color: Colors.deepPurple,
//                                   size: 20,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       pharmacyName,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       '${items.length} items',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (_selectedPharmacyId == pharmacy.pharmacyId)
//                                 const Icon(
//                                   Icons.check_circle,
//                                   color: Colors.deepPurple,
//                                   size: 20,
//                                 ),
//                             ],
//                           ),
                          
//                           if (items.isNotEmpty) ...[
//                             const SizedBox(height: 8),
//                             const Divider(height: 1),
//                             const SizedBox(height: 8),
                            
//                             // Items preview
//                             SizedBox(
//                               height: 40,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: items.length,
//                                 itemBuilder: (context, itemIndex) {
//                                   final item = items[itemIndex];
//                                   return Container(
//                                     width: 40,
//                                     height: 40,
//                                     margin: const EdgeInsets.only(right: 8),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(6),
//                                       border: Border.all(
//                                         color: Colors.grey[200]!,
//                                       ),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(6),
//                                       child: item['image'] != null
//                                           ? Image.network(
//                                               item['image'],
//                                               fit: BoxFit.cover,
//                                               errorBuilder: (context, error, stackTrace) {
//                                                 return Container(
//                                                   color: Colors.grey[100],
//                                                   child: const Icon(
//                                                     Icons.medical_services,
//                                                     size: 20,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 );
//                                               },
//                                             )
//                                           : Container(
//                                               color: Colors.grey[100],
//                                               child: const Icon(
//                                                 Icons.medical_services,
//                                                 size: 20,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
                            
//                             const SizedBox(height: 4),
//                             Text(
//                               'Qty: ${items.map((e) => e['quantity']).join(', ')}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey[500],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             if (_error != null) ...[
//               const SizedBox(height: 12),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red.shade200),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         _error!,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.red.shade700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],

//             const SizedBox(height: 20),

//             // Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: _isProcessing ? null : () => Navigator.pop(context),
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _isProcessing ? null : _confirmSelection,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: _isProcessing
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Confirm',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }