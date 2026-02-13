// import 'package:flutter/material.dart';
// import '../models/new_order_model.dart';
// import '../services/new_order_service.dart';

// class NewOrderProvider extends ChangeNotifier {
//   final NewOrderService _service = NewOrderService();

//   List<NewOrder> _pendingOrders = [];
//   bool _isLoading = false;
//   String? _error;
//   String _updateMessage = '';

//   List<NewOrder> get pendingOrders => _pendingOrders;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String get updateMessage => _updateMessage;

//   Future<void> fetchNewOrders(String riderId) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       _pendingOrders = await _service.fetchNewOrders(riderId);

//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshOrders(String riderId) async {
//     await fetchNewOrders(riderId);
//   }

//   Future<bool> updateOrderStatus(String orderId, String status) async {
//     try {
//       _updateMessage = '';
      
//       final success = await _service.updateOrderStatus(orderId, status);
      
//       if (success) {
//         _updateMessage = status == 'Accepted' 
//             ? 'Order accepted successfully' 
//             : 'Order rejected successfully';
        
//         // Remove the order from pending list
//         _pendingOrders.removeWhere((order) => order.id == orderId);
//         notifyListeners();
        
//         return true;
//       } else {
//         _updateMessage = 'Failed to update order status';
//         return false;
//       }
//     } catch (e) {
//       _updateMessage = 'Error: ${e.toString()}';
//       return false;
//     }
//   }

//   void clearOrders() {
//     _pendingOrders.clear();
//     notifyListeners();
//   }
// }




















import 'package:flutter/material.dart';
import '../models/new_order_model.dart';
import '../services/new_order_service.dart';

class NewOrderProvider extends ChangeNotifier {
  final NewOrderService _service = NewOrderService();

  List<NewOrder> _pendingOrders = [];
  bool _isLoading = false;
  String? _error;
  String _updateMessage = '';

  List<NewOrder> get pendingOrders => _pendingOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get updateMessage => _updateMessage;

  Future<void> fetchNewOrders(String riderId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _pendingOrders = await _service.fetchNewOrders(riderId);

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOrders(String riderId) async {
    await fetchNewOrders(riderId);
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      _updateMessage = '';
      
      final success = await _service.updateOrderStatus(orderId, status);
      
      if (success) {
        _updateMessage = status == 'Accepted' 
            ? 'Order accepted successfully' 
            : 'Order rejected successfully';
        
        // Remove the order from pending list
        _pendingOrders.removeWhere((order) => order.id == orderId);
        notifyListeners();
        
        return true;
      } else {
        _updateMessage = 'Failed to update order status';
        return false;
      }
    } catch (e) {
      _updateMessage = 'Error: ${e.toString()}';
      return false;
    }
  }

  /// New method for updating order status with pharmacy selection
  Future<bool> updateOrderStatusWithPharmacy({
    required String riderId,
    required String orderId,
    required String status,
    String? pharmacyId,
  }) async {
    try {
      _updateMessage = '';
      
      final success = await _service.updateOrderStatusWithPharmacy(
        riderId: riderId,
        orderId: orderId,
        status: status,
        pharmacyId: pharmacyId,
      );
      
      if (success) {
        _updateMessage = status == 'Accepted' 
            ? 'Order accepted successfully' 
            : status == 'PickedUp'
                ? 'Pickup confirmed successfully'
                : 'Order rejected successfully';
        
        // Remove the order from pending list if rejected
        if (status == 'Rejected') {
          _pendingOrders.removeWhere((order) => order.id == orderId);
        }
        notifyListeners();
        
        return true;
      } else {
        _updateMessage = 'Failed to update order status';
        return false;
      }
    } catch (e) {
      _updateMessage = 'Error: ${e.toString()}';
      return false;
    }
  }

  void clearOrders() {
    _pendingOrders.clear();
    notifyListeners();
  }
}