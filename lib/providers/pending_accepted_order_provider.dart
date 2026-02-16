// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/pending_accepted_order_model.dart';
// import 'package:medical_delivery_app/services/pending_accepted_order_service.dart';

// class PendingAcceptedOrderProvider extends ChangeNotifier {
//   final PendingAcceptedOrderService _service = PendingAcceptedOrderService();

//   List<NewOrder> _orders = [];
//   bool _isLoading = false;
//   String? _error;
//   String _updateMessage = '';
//   bool _isUpdating = false;

//   // Getters
//   List<NewOrder> get orders => _orders;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String get updateMessage => _updateMessage;
//   bool get isUpdating => _isUpdating;

//   // Fetch all pending accepted orders for a rider
//   Future<void> fetchPendingAcceptedOrders(String riderId) async {
//     _setLoading(true);
//     _error = null;

//     try {
//       final response = await _service.fetchPendingAcceptedOrders(riderId);
//       _orders = response.newOrders;
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//       print('Provider error: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Accept an order with specific pharmacy
// // Update the acceptOrderWithPharmacy method in your provider
// Future<bool> acceptOrderWithPharmacy({
//   required String riderId,
//   required String orderId,
//   required String pharmacyId,
// }) async {
//   _setUpdating(true);
//   _updateMessage = '';

//   try {
//     final response = await _service.acceptOrderWithPharmacy(
//       riderId: riderId,
//       orderId: orderId,
//       pharmacyId: pharmacyId,
//     );

//     if (response['success'] == true) {
//       _updateMessage = response['message'] ?? 'Order accepted successfully';

//       // Update the local order status
//       final orderIndex = _orders.indexWhere((o) => o.id == orderId);
//       if (orderIndex != -1) {
//         // Create updated order with new status
//         final updatedOrder = NewOrder.fromJson({
//           ..._orders[orderIndex].toJson(),
//           'assignedRiderStatus': 'Accepted',
//         });
//         _orders[orderIndex] = updatedOrder;
//       }

//       return true;
//     } else {
//       _updateMessage = response['message'] ?? 'Failed to accept order';
//       return false;
//     }
//   } catch (e) {
//     _updateMessage = 'Error: $e';
//     print('Provider accept error: $e');
//     return false;
//   } finally {
//     _setUpdating(false);
//   }
// }

//   // Update order status (for future steps like picked up, delivered)
//   Future<bool> updateOrderStatus({
//     required String riderId,
//     required String orderId,
//     required String status,
//     String? pharmacyId,
//   }) async {
//     _setUpdating(true);
//     _updateMessage = '';

//     try {
//       final response = await _service.updateOrderStatus(
//         riderId: riderId,
//         orderId: orderId,
//         status: status,
//         pharmacyId: pharmacyId,
//       );

//       if (response['success'] == true) {
//         _updateMessage = response['message'] ?? 'Order updated successfully';

//         // Update the local order status
//         final orderIndex = _orders.indexWhere((o) => o.id == orderId);
//         if (orderIndex != -1) {
//           _orders[orderIndex] = NewOrder.fromJson({
//             ..._orders[orderIndex].toJson(),
//             'assignedRiderStatus': status,
//           });
//         }

//         return true;
//       } else {
//         _updateMessage = response['message'] ?? 'Failed to update order';
//         return false;
//       }
//     } catch (e) {
//       _updateMessage = 'Error: $e';
//       print('Provider update error: $e');
//       return false;
//     } finally {
//       _setUpdating(false);
//     }
//   }

//   // Clear error
//   void clearError() {
//     _error = null;
//     _updateMessage = '';
//   }

//   // Private setters
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void _setUpdating(bool value) {
//     _isUpdating = value;
//     notifyListeners();
//   }
// }

// // Extension to help with JSON conversion (optional)
// extension NewOrderExtension on NewOrder {
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'orderItems': orderItems.map((item) => item.toJson()).toList(),
//       'pharmacyResponses': pharmacyResponses.map((r) => r.toJson()).toList(),
//       'estimatedEarning': estimatedEarning,
//       'orderId': orderId,
//       'userId': userId,
//       'user': user?.toJson(),
//       'assignedRiderId': assignedRiderId,
//       'assignedRiderStatus': assignedRiderStatus,
//       'paymentMethod': paymentMethod,
//       'deliveryAddress': deliveryAddress?.toJson(),
//       'specialInstructions': specialInstructions,
//       'totalAmount': totalAmount,
//       'status': status,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }

// extension OrderItemExtension on OrderItem {
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'medicineId': medicineId?.toJson(),
//       'name': name,
//       'price': price,
//       'quantity': quantity,
//       'images': images,
//       'description': description,
//       'pharmacyDetails': pharmacyDetails?.toJson(),
//       'isPicked': isPicked,
//     };
//   }
// }

// extension MedicineIdExtension on MedicineId {
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'pharmacyId': pharmacyId?.toJson(),
//       'name': name,
//       'images': images,
//       'mrp': mrp,
//       'description': description,
//     };
//   }
// }

// extension PharmacyIdExtension on PharmacyId {
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'image': image,
//       'latitude': latitude,
//       'longitude': longitude,
//       'vendorPhone': vendorPhone,
//       'address': address,
//     };
//   }
// }

// extension PharmacyDetailsExtension on PharmacyDetails {
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'address': address,
//       'image': image,
//       'latitude': latitude,
//       'longitude': longitude,
//       'vendorPhone': vendorPhone,
//     };
//   }
// }

// extension PharmacyResponseExtension on PharmacyResponse {
//   Map<String, dynamic> toJson() {
//     return {
//       'pharmacyId': pharmacyId,
//       'status': status,
//       'respondedAt': respondedAt?.toIso8601String(),
//       '_id': id,
//     };
//   }
// }

// extension UserExtension on User {
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'mobile': mobile,
//       'profileImage': profileImage,
//     };
//   }
// }

// extension DeliveryAddressExtension on DeliveryAddress {
//   Map<String, dynamic> toJson() {
//     return {
//       'house': house,
//       'street': street,
//       'city': city,
//       'state': state,
//       'pincode': pincode,
//     };
//   }
// }





















import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/pending_accepted_order_model.dart';
import 'package:medical_delivery_app/services/pending_accepted_order_service.dart';

class PendingAcceptedOrderProvider extends ChangeNotifier {
  final PendingAcceptedOrderService _service = PendingAcceptedOrderService();

  List<NewOrder> _orders = [];
  bool _isLoading = false;
  String? _error;
  String _updateMessage = '';
  bool _isUpdating = false;

  // Getters
  List<NewOrder> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get updateMessage => _updateMessage;
  bool get isUpdating => _isUpdating;

  // Fetch all pending accepted orders for a rider
  Future<void> fetchPendingAcceptedOrders(String riderId) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _service.fetchPendingAcceptedOrders(riderId);
      _orders = response.newOrders;
      _error = null;
      print('Fetched ${_orders.length} orders');
    } catch (e) {
      _error = e.toString();
      print('Provider error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Accept an order with specific pharmacy
  Future<bool> acceptOrderWithPharmacy({
    required String riderId,
    required String orderId,
    required String pharmacyId,
  }) async {
    _setUpdating(true);
    _updateMessage = '';

    try {
      final response = await _service.acceptOrderWithPharmacy(
        riderId: riderId,
        orderId: orderId,
        pharmacyId: pharmacyId,
      );

      if (response['success'] == true) {
        _updateMessage = response['message'] ?? 'Order accepted successfully';

        // Refresh orders after accepting
        await fetchPendingAcceptedOrders(riderId);

        return true;
      } else {
        _updateMessage = response['message'] ?? 'Failed to accept order';
        return false;
      }
    } catch (e) {
      _updateMessage = 'Error: $e';
      print('Provider accept error: $e');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  // Get order by ID
  NewOrder? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    _updateMessage = '';
  }

  // Private setters
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }
}