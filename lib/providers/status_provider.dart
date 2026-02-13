// // providers/status_provider.dart
// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/utils/helper_function.dart';
// import '../models/details_model.dart';
// import '../services/status_service.dart';
// import '../models/login_model.dart';

// enum OrderStatusType {
//   pending,
//   accepted,
//   pickedUp,
//   delivered,
//   cancelled,
//   all,
// }

// class StatusProvider extends ChangeNotifier {
//   final StatusService _statusService = StatusService();

//   // Loading states
//   bool _isLoading = false;
//   bool _isUpdatingStatus = false;

//   // Data
//   List<OrderModel> _orders = [];
//   OrderResponse? _orderResponse;
//   String? _errorMessage;
//   RiderModel? _currentRider;

//   // Current filter
//   OrderStatusType _currentFilter = OrderStatusType.all;

//   // Getters
//   bool get isLoading => _isLoading;
//   bool get isUpdatingStatus => _isUpdatingStatus;
//   List<OrderModel> get orders => _orders;
//   OrderResponse? get orderResponse => _orderResponse;
//   String? get errorMessage => _errorMessage;
//   RiderModel? get currentRider => _currentRider;
//   OrderStatusType get currentFilter => _currentFilter;

//   // Initialize - load current rider data
//   Future<void> initialize() async {
//     _currentRider = await SharedPreferenceService.getRiderData();
//     if (_currentRider != null) {
//       await fetchAllOrders();
//     } else {
//       _errorMessage = 'Rider data not found. Please login again.';
//       notifyListeners();
//     }
//   }

//   // Fetch orders by status
//   Future<void> fetchOrdersByStatus(OrderStatusType statusType) async {
//     if (_currentRider?.id == null) {
//       _errorMessage = 'Rider ID not found';
//       notifyListeners();
//       return;
//     }

//     _setLoading(true);
//     _currentFilter = statusType;
//     _clearError();

//     try {
//       OrderResponse? response;

//       switch (statusType) {
//         case OrderStatusType.pending:
//           response = await _statusService.getPendingOrders(_currentRider!.id);
//           break;
//         case OrderStatusType.accepted:
//           response = await _statusService.getAcceptedOrders(_currentRider!.id);
//           break;
//         case OrderStatusType.pickedUp:
//           response = await _statusService.getPickedUpOrders(_currentRider!.id);
//           break;
//         case OrderStatusType.delivered:
//           response = await _statusService.getDeliveredOrders(_currentRider!.id);
//           break;
//         case OrderStatusType.cancelled:
//           response = await _statusService.getCancelledOrders(_currentRider!.id);
//           break;
//         case OrderStatusType.all:
//           response = await _statusService.getAllOrders(_currentRider!.id);
//           break;
//       }

//       if (response != null) {
//         _orderResponse = response;
//         _orders = response.orders;
//         _clearError();
//       } else {
//         _setError('Failed to fetch orders');
//         _orders = [];
//       }
//     } catch (e) {
//       _setError('Error fetching orders: $e');
//       _orders = [];
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Convenience methods for specific statuses
//   Future<void> fetchPendingOrders() async {
//     await fetchOrdersByStatus(OrderStatusType.pending);
//   }

//   Future<void> fetchAcceptedOrders() async {
//     await fetchOrdersByStatus(OrderStatusType.accepted);
//   }

//   Future<void> fetchPickedUpOrders() async {
//     await fetchOrdersByStatus(OrderStatusType.pickedUp);
//   }

//   Future<void> fetchDeliveredOrders() async {
//     await fetchOrdersByStatus(OrderStatusType.delivered);
//   }

//   Future<void> fetchCancelledOrders() async {
//     await fetchOrdersByStatus(OrderStatusType.cancelled);
//   }

//   Future<void> fetchAllOrders() async {
//     await fetchOrdersByStatus(OrderStatusType.all);
//   }

//   // Update order status
//   Future<bool> updateOrderStatus(String orderId, String newStatus) async {
//     if (_currentRider?.id == null) {
//       _setError('Rider ID not found');
//       return false;
//     }

//     _isUpdatingStatus = true;
//     _clearError();
//     notifyListeners();

//     try {
//       final success = await _statusService.updateOrderStatus(
//         riderId: _currentRider!.id,
//         orderId: orderId,
//         newStatus: newStatus,
//       );

//       if (success) {
//         // Refresh the current list after successful update
//         await _refreshCurrentFilter();
//         return true;
//       } else {
//         _setError('Failed to update order status');
//         return false;
//       }
//     } catch (e) {
//       _setError('Error updating order status: $e');
//       return false;
//     } finally {
//       _isUpdatingStatus = false;
//       notifyListeners();
//     }
//   }

//   // Refresh current filter
//   Future<void> refreshCurrentFilter() async {
//     await _refreshCurrentFilter();
//   }

//   Future<void> _refreshCurrentFilter() async {
//     await fetchOrdersByStatus(_currentFilter);
//   }

//   // Get orders count by status
//   int getOrdersCountByStatus(String status) {
//     return _orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).length;
//   }

//   // Filter orders locally by status
//   List<OrderModel> getOrdersByStatusLocal(String status) {
//     return _orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();
//   }

//   // Get order by ID
//   OrderModel? getOrderById(String orderId) {
//     try {
//       return _orders.firstWhere((order) => order.id == orderId);
//     } catch (e) {
//       return null;
//     }
//   }

//   // Utility methods
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _errorMessage = error;
//     notifyListeners();
//   }

//   void _clearError() {
//     _errorMessage = null;
//   }

//   // Clear all data
//   void clearData() {
//     _orders = [];
//     _orderResponse = null;
//     _errorMessage = null;
//     _currentRider = null;
//     _currentFilter = OrderStatusType.all;
//     _isLoading = false;
//     _isUpdatingStatus = false;
//     notifyListeners();
//   }

//   // Get status display name
//   String getStatusDisplayName(OrderStatusType statusType) {
//     switch (statusType) {
//       case OrderStatusType.pending:
//         return 'Pending';
//       case OrderStatusType.accepted:
//         return 'Accepted';
//       case OrderStatusType.pickedUp:
//         return 'Picked Up';
//       case OrderStatusType.delivered:
//         return 'Delivered';
//       case OrderStatusType.cancelled:
//         return 'Cancelled';
//       case OrderStatusType.all:
//         return 'All Orders';
//     }
//   }

//   // Get status color
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'accepted':
//       case 'rider assigned':
//         return Colors.blue;
//       case 'picked up':
//         return Colors.purple;
//       case 'delivered':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// providers/status_provider.dart
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';
import '../models/details_model.dart';
import '../services/status_service.dart';
import '../models/login_model.dart';

enum OrderStatusType {
  all,
  pending,
  assigned,
  accepted,
  confirmed,
  shipped,
  pickedUp,
  inProgress,
  delivered,
  completed,
  cancelled,
  rejected,
  failed,
  refunded,
}

class StatusProvider extends ChangeNotifier {
  final StatusService _statusService = StatusService();

  // State variables
  bool _isLoading = false;
  bool _isUpdatingStatus = false;
  List<OrderModel> _orders = [];
  OrderResponse? _orderResponse;
  String? _errorMessage;
  RiderModel? _currentRider;
  OrderStatusType _currentFilter = OrderStatusType.all;

  // Getters
  bool get isLoading => _isLoading;
  bool get isUpdatingStatus => _isUpdatingStatus;
  List<OrderModel> get orders => _orders;
  OrderResponse? get orderResponse => _orderResponse;
  String? get errorMessage => _errorMessage;
  RiderModel? get currentRider => _currentRider;
  OrderStatusType get currentFilter => _currentFilter;

  /// Initialize provider with rider data
  Future<void> initialize() async {
    try {
      _currentRider = await SharedPreferenceService.getRiderData();
      if (_currentRider == null) {
        _setError('Rider data not found. Please login again.');
        return;
      }
      print('Rider initialized: ${_currentRider!.name} (${_currentRider!.id})');
    } catch (e) {
      _setError('Failed to initialize rider data: $e');
    }
  }

  /// Fetch orders by status type
  Future<void> fetchOrdersByStatus(OrderStatusType statusType) async {
    if (_currentRider?.id == null) {
      _setError('Rider ID not found. Please login again.');
      return;
    }

    _setLoading(true);
    _currentFilter = statusType;
    _clearError();

    try {
      OrderResponse? response;

      if (statusType == OrderStatusType.all) {
        response = await _statusService.getAllOrders(_currentRider!.id);
      } else {
        final statusString = _getApiStatusString(statusType);
        response = await _statusService.getOrdersByStatus(
          riderId: _currentRider!.id,
          status: statusString,
        );
      }

      if (response != null) {
        _orderResponse = response;
        _orders = response.orders;
        _clearError();
        print(
          'Fetched ${_orders.length} orders for ${getStatusDisplayName(statusType)}',
        );
      } else {
        _setError(response?.message ?? 'Failed to fetch orders');
        _orders = [];
      }
    } catch (e) {
      _setError('Error fetching orders: $e');
      _orders = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    if (_currentRider?.id == null) {
      _setError('Rider ID not found');
      return false;
    }

    _isUpdatingStatus = true;
    _clearError();
    notifyListeners();

    try {
      final success = await _statusService.updateOrderStatus(
        riderId: _currentRider!.id,
        orderId: orderId,
        newStatus: newStatus,
      );

      print('riderrrrrrrrrrrrrrrrrrrrrrridddddddddddd ${_currentRider!.id}');
      print('ordeeeeeeeerrrrrrrrrrrrrriddddddddddddddd $orderId');
      print('newwwwwwwwwwwwwwstatussssssssssssssssss $newStatus');

      if (success) {
        // Update local order status immediately for better UX
        _updateLocalOrderStatus(orderId, newStatus);

        // Then refresh from server to ensure consistency
        await fetchOrdersByStatus(_currentFilter);
        return true;
      } else {
        _setError('Failed to update order status');
        return false;
      }
    } catch (e) {
      _setError('Error updating order status: $e');
      return false;
    } finally {
      _isUpdatingStatus = false;
      notifyListeners();
    }
  }

  /// Update local order status for immediate UI feedback
  void _updateLocalOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      // Create a new order with updated status
      final updatedOrder = _orders[orderIndex];
      // Note: You might need to implement a copyWith method in your OrderModel
      // For now, directly updating the status
      // updatedOrder.status = newStatus;

      // Add to timeline if it exists
      // if (updatedOrder.statusTimeline.isNotEmpty) {
      //   updatedOrder.statusTimeline.add(
      //     StatusTimeline(
      //       status: newStatus,
      //       message: 'Order status updated to $newStatus',
      //       timestamp: DateTime.now().toIso8601String(),
      //     )
      //   );
      // }

      notifyListeners();
    }
  }

  /// Refresh current filter
  Future<void> refreshCurrentFilter() async {
    await fetchOrdersByStatus(_currentFilter);
  }

  /// Get orders count by status string
  int getOrdersCountByStatus(String status) {
    if (_orders.isEmpty) return 0;
    return _orders
        .where(
          (order) =>
              order.status.toLowerCase().replaceAll(' ', '') ==
              status.toLowerCase().replaceAll(' ', ''),
        )
        .length;
  }

  /// Get filtered orders by status
  List<OrderModel> getFilteredOrders(OrderStatusType statusType) {
    if (statusType == OrderStatusType.all) {
      return _orders;
    }

    final statusString = _getApiStatusString(statusType);
    return _orders
        .where(
          (order) =>
              order.status.toLowerCase().replaceAll(' ', '') ==
              statusString.toLowerCase().replaceAll(' ', ''),
        )
        .toList();
  }

  /// Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Get display name for status type
  String getStatusDisplayName(OrderStatusType statusType) {
    switch (statusType) {
      case OrderStatusType.all:
        return 'All';
      case OrderStatusType.pending:
        return 'Pending';
      case OrderStatusType.assigned:
        return 'Assigned';
      case OrderStatusType.accepted:
        return 'Accepted';
      case OrderStatusType.confirmed:
        return 'Confirmed';
      case OrderStatusType.shipped:
        return 'Shipped';
      case OrderStatusType.pickedUp:
        return 'Picked Up';
      case OrderStatusType.inProgress:
        return 'In Progress';
      case OrderStatusType.delivered:
        return 'Delivered';
      case OrderStatusType.completed:
        return 'Completed';
      case OrderStatusType.cancelled:
        return 'Cancelled';
      case OrderStatusType.rejected:
        return 'Rejected';
      case OrderStatusType.failed:
        return 'Failed';
      case OrderStatusType.refunded:
        return 'Refunded';
    }
  }

  /// Get API status string from enum
  String _getApiStatusString(OrderStatusType statusType) {
    switch (statusType) {
      case OrderStatusType.pending:
        return 'Pending';
      case OrderStatusType.assigned:
        return 'Assigned';
      case OrderStatusType.accepted:
        return 'Accepted';
      case OrderStatusType.confirmed:
        return 'Confirmed';
      case OrderStatusType.shipped:
        return 'Shipped';
      case OrderStatusType.pickedUp:
        return 'PickedUp';
      case OrderStatusType.inProgress:
        return 'In Progress';
      case OrderStatusType.delivered:
        return 'Delivered';
      case OrderStatusType.completed:
        return 'Completed';
      case OrderStatusType.cancelled:
        return 'Cancelled';
      case OrderStatusType.rejected:
        return 'Rejected';
      case OrderStatusType.failed:
        return 'Failed';
      case OrderStatusType.refunded:
        return 'Refunded';
      case OrderStatusType.all:
        return '';
    }
  }

  /// Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase().replaceAll(' ', '')) {
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'assigned':
        return const Color(0xFF2196F3); // Blue
      case 'accepted':
        return const Color(0xFF1976D2); // Dark Blue
      case 'confirmed':
        return const Color(0xFF3F51B5); // Indigo
      case 'shipped':
        return const Color(0xFF9C27B0); // Purple
      case 'pickedup':
      case 'picked':
        return const Color(0xFF673AB7); // Deep Purple
      case 'inprogress':
        return const Color(0xFF00BCD4); // Cyan
      case 'delivered':
        return const Color(0xFF4CAF50); // Green
      case 'completed':
        return const Color(0xFF2E7D32); // Dark Green
      case 'cancelled':
        return const Color(0xFFF44336); // Red
      case 'rejected':
        return const Color(0xFFD32F2F); // Dark Red
      case 'failed':
        return const Color(0xFFB71C1C); // Very Dark Red
      case 'refunded':
        return const Color(0xFF757575); // Grey
      default:
        return const Color(0xFF9E9E9E); // Default Grey
    }
  }

  /// Check if status can be updated
  bool canUpdateStatus(String currentStatus) {
    final updatableStatuses = [
      'pending',
      'assigned',
      'accepted',
      'confirmed',
      'shipped',
      'pickedup',
      'inprogress',
    ];
    return updatableStatuses.contains(
      currentStatus.toLowerCase().replaceAll(' ', ''),
    );
  }

  /// Get next possible statuses for current status
  List<String> getNextPossibleStatuses(String currentStatus) {
    switch (currentStatus.toLowerCase().replaceAll(' ', '')) {
      case 'pending':
        return ['Assigned', 'Cancelled'];
      case 'assigned':
        return ['Accepted', 'Rejected'];
      case 'accepted':
        return ['Confirmed', 'Cancelled'];
      case 'confirmed':
        return ['Shipped', 'Cancelled'];
      case 'shipped':
        return ['PickedUp', 'Failed'];
      case 'pickedup':
        return ['In Progress', 'Failed'];
      case 'inprogress':
        return ['Delivered', 'Failed'];
      case 'delivered':
        return ['Completed'];
      default:
        return [];
    }
  }

  /// Get status statistics
  Map<String, int> getStatusStatistics() {
    final stats = <String, int>{};
    for (final statusType in OrderStatusType.values) {
      if (statusType != OrderStatusType.all) {
        final count = getOrdersCountByStatus(getStatusDisplayName(statusType));
        stats[getStatusDisplayName(statusType)] = count;
      }
    }
    return stats;
  }

  /// Search orders by customer name or order ID
  List<OrderModel> searchOrders(String query) {
    if (query.isEmpty) return _orders;

    final lowercaseQuery = query.toLowerCase();
    return _orders.where((order) {
      final orderIdMatch = order.id.toLowerCase().contains(lowercaseQuery);
      final customerNameMatch =
          order.userId?.name.toLowerCase().contains(lowercaseQuery) ?? false;
      final phoneMatch = order.userId?.mobile.contains(query) ?? false;

      return orderIdMatch || customerNameMatch || phoneMatch;
    }).toList();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    print('StatusProvider Error: $error');
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clear all data
  void clearData() {
    _orders = [];
    _orderResponse = null;
    _errorMessage = null;
    _currentRider = null;
    _currentFilter = OrderStatusType.all;
    _isLoading = false;
    _isUpdatingStatus = false;
    notifyListeners();
    print('StatusProvider data cleared');
  }

  /// Reset to initial state
  void reset() {
    clearData();
  }

  /// Get loading state for specific operation
  bool isLoadingForStatus(OrderStatusType statusType) {
    return _isLoading && _currentFilter == statusType;
  }
}
