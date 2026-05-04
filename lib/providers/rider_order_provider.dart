
// import 'package:flutter/material.dart';
// import '../models/rider_order_model.dart';
// import '../models/update_status_request.dart';
// import '../services/rider_order_service.dart';

// class RiderOrderProvider extends ChangeNotifier {
//   final RiderOrderService _service = RiderOrderService();

//   AcceptedOrder? _currentOrder;
//   bool _isLoading = false;
//   String? _error;

//   /// ================= GETTERS =================

//   AcceptedOrder? get currentOrder => _currentOrder;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   /// Get pending pharmacies from pharmacyResponses array
//   /// This is the single source of truth - when a pharmacy is picked up,
//   /// it gets removed from this array by the backend
//   List<PendingPharmacy> get pendingPharmacies {
//     if (_currentOrder == null) return [];
    
//     print('=== GETTING PENDING PHARMACIES ===');
//     print('Total pharmacyResponses: ${_currentOrder!.pharmacyResponses.length}');
    
//     // Use the static helper method to create PendingPharmacy list from pharmacyResponses
//     final pharmacies = PendingPharmacy.fromOrder(_currentOrder!);
    
//     for (var pharmacy in pharmacies) {
//       print('Pharmacy: ${pharmacy.pharmacyName}, Status: ${pharmacy.status}');
//     }
    
//     print('Total pending pharmacies: ${pharmacies.length}');
//     return pharmacies;
//   }

//   /// Get only accepted pharmacies (status = "Accepted")
//   /// These are the pharmacies the rider needs to pick up now
//   List<PendingPharmacy> get acceptedPharmacies {
//     final accepted = pendingPharmacies
//         .where((p) => p.status.toLowerCase() == 'rider accepted')
//         .toList();
    
//     print('Accepted pharmacies count: ${accepted.length}');
//     return accepted;
//   }

//   /// Check if there are any pending pharmacies left in pharmacyResponses array
//   /// If empty, all pharmacies have been picked up
//   bool get hasNoPendingPharmacies {
//     final isEmpty = _currentOrder?.pharmacyResponses.isEmpty ?? true;
//     print('pharmacyResponses is empty: $isEmpty');
//     return isEmpty;
//   }

//   /// Check if all pharmacies are picked up (same as hasNoPendingPharmacies)
//   bool get areAllPharmaciesPickedUp {
//     return hasNoPendingPharmacies;
//   }

//   /// ================= LOAD ORDER =================

//   // Future<bool> loadOrder(String orderId, String riderId) async {
//   //   print('=== LOADING ORDER ===');
//   //   print('Order ID: $orderId');
//   //   print('Rider ID: $riderId');
    
//   //   _isLoading = true;
//   //   _error = null;
//   //   notifyListeners();

//   //   try {
//   //     _currentOrder = await _service.getAcceptedOrder(orderId, riderId);

//   //     if (_currentOrder != null) {
//   //       print('Order loaded successfully');
//   //       print('Order status: ${_currentOrder!.status}');
//   //       print('Assigned rider status: ${_currentOrder!.assignedRiderStatus}');
//   //       print('PharmacyResponses count: ${_currentOrder!.pharmacyResponses.length}');
        
//   //       // Print pharmacy responses
//   //       for (var response in _currentOrder!.pharmacyResponses) {
//   //         print('Pharmacy ${response.pharmacyId}: ${response.status}');
//   //       }
        
//   //       _error = null;
//   //     } else {
//   //       _error = 'No accepted order found';
//   //       print('No order found for rider');
//   //     }

//   //     _isLoading = false;
//   //     notifyListeners();
//   //     return _currentOrder != null;
//   //   } catch (e) {
//   //     _error = e.toString();
//   //     print('Error loading order: $e');
//   //     _isLoading = false;
//   //     notifyListeners();
//   //     return false;
//   //   }
//   // }

// ///   New code added for delay in aab file//

// Future<bool> loadOrder(String orderId, String riderId) async {
//   print('=== LOADING ORDER ===');

//   _isLoading = true;
//   _error = null;
//   notifyListeners();

//   const int maxRetries = 5;
//   const int delayMs = 1000; 

//   for (int attempt = 1; attempt <= maxRetries; attempt++) {
//     try {
//       print('Load attempt $attempt of $maxRetries');

//       final order = await _service.getAcceptedOrder(orderId, riderId);

//       if (order != null) {
//         _currentOrder = order;
//         _error = null;
//         _isLoading = false;
//         notifyListeners();
//         print('Order loaded successfully on attempt $attempt');
//         return true;
//       }

//       print('Attempt $attempt: order null, retrying in ${delayMs * attempt}ms...');
//       await Future.delayed(Duration(milliseconds: delayMs * attempt));

//     } catch (e) {
//       print('Attempt $attempt failed: $e');
//       if (attempt == maxRetries) {
//         _error = 'Failed to load order after $maxRetries attempts: $e';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//       await Future.delayed(Duration(milliseconds: delayMs * attempt));
//     }
//   }

//   _error = 'Order not found after $maxRetries attempts';
//   _isLoading = false;
//   notifyListeners();
//   return false;
// }
//   /// ================= NEXT PHARMACY =================

//   /// Get the first accepted pharmacy to process
//   PendingPharmacy? getNextPendingPharmacy() {
//     if (acceptedPharmacies.isEmpty) return null;
//     return acceptedPharmacies.first;
//   }

//   /// ================= UPDATE STATUS =================

// Future<bool> updatePharmacyStatus({
//   required String riderId,
//   required String orderId,
//   required String pharmacyId,
//   required String newStatus,
// }) async {
//   _isLoading = true;
//   notifyListeners();

//   try {
//     final request = UpdateStatusRequest(
//       orderId: orderId,
//       newStatus: newStatus,
//       pharmacyId: pharmacyId,
//     );

//     final response = await _service.updateOrderStatus(
//       riderId: riderId,
//       request: request,
//     );

//     final bool success = response['success'] == true;

//     if (!success) {
//       _error = response['message'] ?? 'Failed to update status';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }

//     // reload only on real success
//     await loadOrder(orderId, riderId);

//     _isLoading = false;
//     notifyListeners();
//     return true;
//   } catch (e) {
//     _error = e.toString();
//     _isLoading = false;
//     notifyListeners();
//     return false;
//   }
// }


//   /// ================= SHORTCUT METHODS =================

//   /// Mark pharmacy as picked up
//   /// This will REMOVE the pharmacy from pharmacyResponses array
// Future<bool> markPharmacyAsPickedUp({
//   required String riderId,
//   required String orderId,
//   required String pharmacyId,
// }) {
//   return updatePharmacyStatus(
//     riderId: riderId,
//     orderId: orderId,
//     pharmacyId: pharmacyId,
//     newStatus: 'PickedUp',
//   );
// }

//   /// Mark pharmacy as accepted
//   /// This will update the pharmacy status in pharmacyResponses array to "Accepted"
//   Future<bool> markPharmacyAsAccepted({
//     required String riderId,
//     required String orderId,
//     required String pharmacyId,
//   }) {
//     print('=== MARK PHARMACY AS ACCEPTED ===');
//     print('This will update pharmacy $pharmacyId status to "Accepted"');
    
//     return updatePharmacyStatus(
//       riderId: riderId,
//       orderId: orderId,
//       pharmacyId: pharmacyId,
//       newStatus: 'Accepted',
//     );
//   }

//   /// ================= CLEAR =================

//   void clearOrder() {
//     print('=== CLEARING ORDER ===');
//     _currentOrder = null;
//     _error = null;
//     notifyListeners();
//   }
// }

















//////////// New code for fixing the loading issue after accepting the order previous code is the used code////



import 'package:flutter/material.dart';
import '../models/rider_order_model.dart';
import '../models/update_status_request.dart';
import '../services/rider_order_service.dart';

class RiderOrderProvider extends ChangeNotifier {
  final RiderOrderService _service = RiderOrderService();

  AcceptedOrder? _currentOrder;
  bool _isLoading = false;
  String? _error;

  /// ================= GETTERS =================

  AcceptedOrder? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<PendingPharmacy> get pendingPharmacies {
    if (_currentOrder == null) return [];

    print('=== GETTING PENDING PHARMACIES ===');
    print('Total pharmacyResponses: ${_currentOrder!.pharmacyResponses.length}');

    final pharmacies = PendingPharmacy.fromOrder(_currentOrder!);

    for (var pharmacy in pharmacies) {
      print('Pharmacy: ${pharmacy.pharmacyName}, Status: ${pharmacy.status}');
    }

    print('Total pending pharmacies: ${pharmacies.length}');
    return pharmacies;
  }

  List<PendingPharmacy> get acceptedPharmacies {
    final accepted = pendingPharmacies
        .where((p) => p.status.toLowerCase() == 'rider accepted')
        .toList();

    print('Accepted pharmacies count: ${accepted.length}');
    return accepted;
  }

  bool get hasNoPendingPharmacies {
    final isEmpty = _currentOrder?.pharmacyResponses.isEmpty ?? true;
    print('pharmacyResponses is empty: $isEmpty');
    return isEmpty;
  }

  bool get areAllPharmaciesPickedUp => hasNoPendingPharmacies;

  /// ================= RESET =================

  /// FIX: Always call reset() before loadOrder() when navigating to
  /// ConfirmOrderModal. Without this, stale _isLoading = true from the
  /// previous accept/reject operation keeps the screen stuck on the
  /// loading spinner indefinitely in release builds.
  void reset() {
    _currentOrder = null;
    _isLoading = false;
    _error = null;
    // Do NOT call notifyListeners() here — reset() is called before
    // loadOrder() in initState context; notifying here causes an
    // unnecessary rebuild on a widget that hasn't fully mounted yet.
  }

  /// ================= LOAD ORDER =================

  Future<bool> loadOrder(String orderId, String riderId) async {
    print('=== LOADING ORDER ===');
    print('Order ID: $orderId');
    print('Rider ID: $riderId');

    // FIX: Always start from a clean loading state. If _isLoading was
    // already true (left over from acceptOrder or rejectOrder), the
    // Consumer in ConfirmOrderModal would see isLoading=true &&
    // currentOrder==null and show the spinner forever.
    _isLoading = true;
    _error = null;
    notifyListeners();

    const int maxRetries = 5;
    const int baseDelayMs = 1000;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('Load attempt $attempt of $maxRetries');

        final order = await _service.getAcceptedOrder(orderId, riderId);

        if (order != null) {
          _currentOrder = order;
          _error = null;
          _isLoading = false;
          notifyListeners();
          print('Order loaded successfully on attempt $attempt');
          return true;
        }

        print(
          'Attempt $attempt: order null, retrying in ${baseDelayMs * attempt}ms...',
        );
        await Future.delayed(Duration(milliseconds: baseDelayMs * attempt));
      } catch (e) {
        print('Attempt $attempt failed: $e');
        if (attempt == maxRetries) {
          _error = 'Failed to load order after $maxRetries attempts: $e';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        await Future.delayed(Duration(milliseconds: baseDelayMs * attempt));
      }
    }

    _error = 'Order not found after $maxRetries attempts';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// ================= NEXT PHARMACY =================

  PendingPharmacy? getNextPendingPharmacy() {
    if (acceptedPharmacies.isEmpty) return null;
    return acceptedPharmacies.first;
  }

  /// ================= UPDATE STATUS =================

  Future<bool> updatePharmacyStatus({
    required String riderId,
    required String orderId,
    required String pharmacyId,
    required String newStatus,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = UpdateStatusRequest(
        orderId: orderId,
        newStatus: newStatus,
        pharmacyId: pharmacyId,
      );

      final response = await _service.updateOrderStatus(
        riderId: riderId,
        request: request,
      );

      final bool success = response['success'] == true;

      if (!success) {
        _error = response['message'] ?? 'Failed to update status';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Reload order after successful status update.
      // loadOrder() will set _isLoading = true then false internally,
      // so we don't double-set it here.
      await loadOrder(orderId, riderId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ================= SHORTCUT METHODS =================

  Future<bool> markPharmacyAsPickedUp({
    required String riderId,
    required String orderId,
    required String pharmacyId,
  }) {
    return updatePharmacyStatus(
      riderId: riderId,
      orderId: orderId,
      pharmacyId: pharmacyId,
      newStatus: 'PickedUp',
    );
  }

  Future<bool> markPharmacyAsAccepted({
    required String riderId,
    required String orderId,
    required String pharmacyId,
  }) {
    print('=== MARK PHARMACY AS ACCEPTED ===');
    return updatePharmacyStatus(
      riderId: riderId,
      orderId: orderId,
      pharmacyId: pharmacyId,
      newStatus: 'Accepted',
    );
  }

  /// ================= CLEAR =================

  void clearOrder() {
    print('=== CLEARING ORDER ===');
    _currentOrder = null;
    _error = null;
    notifyListeners();
  }
}