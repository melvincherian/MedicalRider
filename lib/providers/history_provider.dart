// // history_provider.dart
// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/models/history_model.dart';
// import 'package:medical_delivery_app/services/order_history_service.dart';


// class HistoryProvider extends ChangeNotifier {
//   // State variables
//   List<OrderModel> _previousOrders = [];
//   List<OrderModel> _activeOrders = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//   bool _hasError = false;

//   // Getters
//   List<OrderModel> get previousOrders => _previousOrders;
//   List<OrderModel> get activeOrders => _activeOrders;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   bool get hasError => _hasError;
//   bool get hasPreviousOrders => _previousOrders.isNotEmpty;
//   bool get hasActiveOrders => _activeOrders.isNotEmpty;

//   // Set loading state
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   // Set error state
//   void _setError(String? error) {
//     _errorMessage = error;
//     _hasError = error != null;
//     notifyListeners();
//   }

//   // Clear error
//   void clearError() {
//     _errorMessage = null;
//     _hasError = false;
//     notifyListeners();
//   }

//   // Fetch previous orders
//   Future<void> fetchPreviousOrders() async {
//     try {
//       _setLoading(true);
//       _setError(null);

//       final orders = await OrderHistoryService.getPreviousOrders();
//       _previousOrders = orders;
      
//       _setLoading(false);
//     } catch (e) {
//       _setLoading(false);
//       _setError(e.toString());
//       _previousOrders = [];
//     }
//   }

//   // Fetch active orders
//   Future<void> fetchActiveOrders() async {
//     try {
//       _setLoading(true);
//       _setError(null);

//       final orders = await OrderHistoryService.getActiveOrders();
//       _activeOrders = orders;
      
//       _setLoading(false);
//     } catch (e) {
//       _setLoading(false);
//       _setError(e.toString());
//       _activeOrders = [];
//     }
//   }

//   // Fetch all orders (both previous and active)
//   Future<void> fetchAllOrders() async {
//     try {
//       _setLoading(true);
//       _setError(null);

//       final allOrders = await OrderHistoryService.getAllOrders();
//       _previousOrders = allOrders['previous'] ?? [];
//       _activeOrders = allOrders['active'] ?? [];
      
//       _setLoading(false);
//     } catch (e) {
//       _setLoading(false);
//       _setError(e.toString());
//       _previousOrders = [];
//       _activeOrders = [];
//     }
//   }

//   // Refresh orders
//   Future<void> refreshOrders() async {
//     await fetchAllOrders();
//   }

//   // Get order by ID
//   OrderModel? getOrderById(String orderId) {
//     // First check in active orders
//     try {
//       return _activeOrders.firstWhere((order) => order.id == orderId);
//     } catch (e) {
//       // If not found in active orders, check previous orders
//       try {
//         return _previousOrders.firstWhere((order) => order.id == orderId);
//       } catch (e) {
//         return null;
//       }
//     }
//   }

//   // Get formatted date
//   String getFormattedDate(DateTime dateTime) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final orderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

//     if (orderDate == today) {
//       return 'Today, ${_formatTime(dateTime)}';
//     } else if (orderDate == yesterday) {
//       return 'Yesterday, ${_formatTime(dateTime)}';
//     } else {
//       return '${_formatDate(dateTime)}, ${_formatTime(dateTime)}';
//     }
//   }

//   // Format time
//   String _formatTime(DateTime dateTime) {
//     final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
//     final minute = dateTime.minute.toString().padLeft(2, '0');
//     final period = dateTime.hour >= 12 ? 'PM' : 'AM';
//     return '$hour:$minute $period';
//   }

//   // Format date
//   String _formatDate(DateTime dateTime) {
//     final months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return '${dateTime.day} ${months[dateTime.month - 1]}';
//   }

//   // Get order status color
//   Color getOrderStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'accepted':
//       case 'rider assigned':
//         return Colors.blue;
//       case 'picked up':
//         return Colors.purple;
//       case 'delivered':
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   // Get payment method display text
//   String getPaymentMethodDisplay(String paymentMethod) {
//     switch (paymentMethod.toLowerCase()) {
//       case 'cash on delivery':
//         return 'COD';
//       case 'online':
//         return 'Online';
//       case 'upi':
//         return 'UPI';
//       case 'card':
//         return 'Card';
//       default:
//         return paymentMethod;
//     }
//   }

//   // Calculate total items in order
//   int getTotalItemsCount(List<OrderItemModel> items) {
//     return items.fold(0, (total, item) => total + item.quantity);
//   }

//   // Get latest status from timeline
//   StatusTimelineModel? getLatestStatus(List<StatusTimelineModel> timeline) {
//     if (timeline.isEmpty) return null;
    
//     timeline.sort((a, b) => b.timestamp.compareTo(a.timestamp));
//     return timeline.first;
//   }

//   // Reset provider state
//   void reset() {
//     _previousOrders = [];
//     _activeOrders = [];
//     _isLoading = false;
//     _errorMessage = null;
//     _hasError = false;
//     notifyListeners();
//   }

//   // Dispose method
//   @override
//   void dispose() {
//     reset();
//     super.dispose();
//   }
// }















// history_provider.dart
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/history_model.dart';
import 'package:medical_delivery_app/services/order_history_service.dart';


class HistoryProvider extends ChangeNotifier {
  // State variables
  List<OrderModel> _previousOrders = [];
  List<OrderModel> _activeOrders = [];
  List<NewOrderModel> _newOrders = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasError = false;

  // Getters
  List<OrderModel> get previousOrders => _previousOrders;
  List<OrderModel> get activeOrders => _activeOrders;
  List<NewOrderModel> get newOrders => _newOrders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _hasError;
  bool get hasPreviousOrders => _previousOrders.isNotEmpty;
  bool get hasActiveOrders => _activeOrders.isNotEmpty;
  bool get hasNewOrders => _newOrders.isNotEmpty;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _errorMessage = error;
    _hasError = error != null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    _hasError = false;
    notifyListeners();
  }

  // Fetch previous orders
  Future<void> fetchPreviousOrders() async {
    try {
      _setLoading(true);
      _setError(null);

      final orders = await OrderHistoryService.getPreviousOrders();
      _previousOrders = orders;
      
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      _previousOrders = [];
    }
  }

  // Fetch active orders
  Future<void> fetchActiveOrders() async {
    try {
      _setLoading(true);
      _setError(null);

      final orders = await OrderHistoryService.getActiveOrders();
      _activeOrders = orders;
      
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      _activeOrders = [];
    }
  }

  // Fetch new orders
  // Future<void> fetchNewOrders() async {
  //   try {
  //     _setLoading(true);
  //     _setError(null);

  //     final orders = await OrderHistoryService.getNewOrders();
  //     _newOrders = orders;
      
  //     _setLoading(false);
  //   } catch (e) {
  //     _setLoading(false);
  //     _setError(e.toString());
  //     _newOrders = [];
  //   }
  // }

  // Fetch all orders (previous, active, and new)
  Future<void> fetchAllOrders() async {
    try {
      _setLoading(true);
      _setError(null);

      final allOrders = await OrderHistoryService.getAllOrders();
      _previousOrders = allOrders['previous'] ?? [];
      _activeOrders = allOrders['active'] ?? [];
      // _newOrders = allOrders['new'] ?? [];
      
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      _previousOrders = [];
      _activeOrders = [];
      _newOrders = [];
    }
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await fetchAllOrders();
  }

  // Get order by ID from any list
  OrderModel? getOrderById(String orderId) {
    // First check in active orders
    try {
      return _activeOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      // If not found in active orders, check previous orders
      try {
        return _previousOrders.firstWhere((order) => order.id == orderId);
      } catch (e) {
        // Finally check in new orders
        try {
          return _newOrders.firstWhere((order) => order.order.id == orderId).order;
        } catch (e) {
          return null;
        }
      }
    }
  }

  // Get new order by ID
  NewOrderModel? getNewOrderById(String orderId) {
    try {
      return _newOrders.firstWhere((order) => order.order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Accept a new order (move from new to active)
  void acceptOrder(String orderId) {
    final newOrderIndex = _newOrders.indexWhere((order) => order.order.id == orderId);
    if (newOrderIndex != -1) {
      final newOrder = _newOrders[newOrderIndex];
      _activeOrders.add(newOrder.order);
      _newOrders.removeAt(newOrderIndex);
      notifyListeners();
    }
  }

  // Reject a new order (remove from new orders)
  void rejectOrder(String orderId) {
    _newOrders.removeWhere((order) => order.order.id == orderId);
    notifyListeners();
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus, String message) {
    final order = getOrderById(orderId);
    if (order != null) {
      final timeline = StatusTimelineModel(
        status: newStatus,
        message: message,
        timestamp: DateTime.now(),
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      
      order.statusTimeline.add(timeline);
      notifyListeners();
    }
  }

  // Get formatted date
  String getFormattedDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final orderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (orderDate == today) {
      return 'Today, ${_formatTime(dateTime)}';
    } else if (orderDate == yesterday) {
      return 'Yesterday, ${_formatTime(dateTime)}';
    } else {
      return '${_formatDate(dateTime)}, ${_formatTime(dateTime)}';
    }
  }

  // Format time
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // Format date
  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}';
  }

  // Get order status color
  Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
      case 'rider assigned':
        return Colors.blue;
      case 'picked up':
        return Colors.purple;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'assigned':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // Get payment method display text
  String getPaymentMethodDisplay(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash on delivery':
        return 'COD';
      case 'online':
        return 'Online';
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Card';
      default:
        return paymentMethod;
    }
  }

  // Calculate total items in order
  int getTotalItemsCount(List<OrderItemModel> items) {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  // Get latest status from timeline
  StatusTimelineModel? getLatestStatus(List<StatusTimelineModel> timeline) {
    if (timeline.isEmpty) return null;
    
    timeline.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return timeline.first;
  }

  // Get medicine details from order item
  String getMedicineDetails(OrderItemModel item) {
    if (item.medicineId != null) {
      return '${item.medicineId!.name} - ₹${item.medicineId!.mrp} x ${item.quantity}';
    }
    return '${item.name} x ${item.quantity}';
  }

  // Get pharmacy name from order
  String? getPharmacyName(OrderModel order) {
    if (order.orderItems.isNotEmpty && 
        order.orderItems.first.medicineId != null) {
      return order.orderItems.first.medicineId!.pharmacyId.name;
    }
    return null;
  }

  // Calculate estimated delivery time based on distance
  String calculateEstimatedDelivery(String pickupTime, String dropTime) {
    return 'Pickup: $pickupTime, Drop: $dropTime';
  }

  // Parse currency amount (remove ₹ symbol and convert to double)
  double parseCurrencyAmount(String amount) {
    return double.tryParse(amount.replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
  }

  // Format currency amount
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Get order summary for new orders
  String getNewOrderSummary(NewOrderModel newOrder) {
    final totalItems = getTotalItemsCount(newOrder.order.orderItems);
    final pharmacyName = getPharmacyName(newOrder.order);
    return '$totalItems item${totalItems > 1 ? 's' : ''} from ${pharmacyName ?? 'Pharmacy'}';
  }

  // Check if order has voice note
  bool hasVoiceNote(OrderModel order) {
    return order.voiceNoteUrl.isNotEmpty;
  }

  // Get rider assignment status display
  String getRiderStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return 'Assigned to you';
      case 'accepted':
        return 'Accepted by you';
      case 'picked_up':
        return 'Picked up';
      case 'delivering':
        return 'Out for delivery';
      default:
        return status;
    }
  }

  // Reset provider state
  void reset() {
    _previousOrders = [];
    _activeOrders = [];
    _newOrders = [];
    _isLoading = false;
    _errorMessage = null;
    _hasError = false;
    notifyListeners();
  }

  // Dispose method
  @override
  void dispose() {
    reset();
    super.dispose();
  }
}