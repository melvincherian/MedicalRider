

// import 'package:flutter/material.dart';
// import '../models/rider_order_model.dart';
// import '../models/update_status_request.dart';
// import '../models/pending_pharmacy.dart';
// import '../services/rider_order_service.dart';

// class RiderOrderProvider extends ChangeNotifier {
//   final RiderOrderService _service = RiderOrderService();

//   AcceptedOrder? _currentOrder;
//   bool _isLoading = false;
//   String? _error;
//   List<PendingPharmacy> _pendingPharmacies = [];

//   /// ================= GETTERS =================

//   AcceptedOrder? get currentOrder => _currentOrder;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   List<PendingPharmacy> get pendingPharmacies => _pendingPharmacies;

//   /// ================= LOAD ORDER =================

//   Future<bool> loadOrder(String orderId, String riderId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       _currentOrder =
//           await _service.getAcceptedOrder(orderId, riderId);

//       _updatePendingPharmacies();

//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   /// ================= PENDING PHARMACIES =================

//   void _updatePendingPharmacies() {
//     if (_currentOrder == null) return;

//     _pendingPharmacies = [];

//     final pharmacyMap = <String, PendingPharmacy>{};

//     for (var item in _currentOrder!.orderItems) {
//       if (item.medicineId == null) continue;

//       final pharmacy = item.medicineId!.pharmacyId;

//       if (!pharmacyMap.containsKey(pharmacy.id)) {
//         pharmacyMap[pharmacy.id] = PendingPharmacy(
//           pharmacyId: pharmacy.id,
//           pharmacyName: pharmacy.name,
//           address: pharmacy.address,
//           phone: pharmacy.vendorPhone,
//           latitude: pharmacy.latitude,
//           longitude: pharmacy.longitude,
//         );
//       }
//     }

//     _pendingPharmacies = pharmacyMap.values.toList();
//   }

//   /// ================= CHECK PICKUP COMPLETE =================

//   bool get areAllPharmaciesPickedUp {
//     if (_currentOrder == null) return false;

//     return _pendingPharmacies.isEmpty;
//   }

//   /// ================= NEXT PHARMACY =================

//   PendingPharmacy? getNextPendingPharmacy() {
//     if (_pendingPharmacies.isEmpty) return null;
//     return _pendingPharmacies.first;
//   }

//   /// ================= UPDATE STATUS =================

//   Future<bool> updatePharmacyStatus({
//     required String riderId,
//     required String orderId,
//     required String pharmacyId,
//     required String newStatus,
//   }) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final request = UpdateStatusRequest(
//         orderId: orderId,
//         newStatus: newStatus,
//         pharmacyId: pharmacyId,
//       );

//       await _service.updateOrderStatus(
//         riderId: riderId,
//         request: request,
//       );

//       await loadOrder(orderId, riderId);

//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   /// ================= SHORTCUT METHODS =================

//   Future<bool> markPharmacyAsPickedUp({
//     required String riderId,
//     required String orderId,
//     required String pharmacyId,
//   }) {
//     return updatePharmacyStatus(
//       riderId: riderId,
//       orderId: orderId,
//       pharmacyId: pharmacyId,
//       newStatus: 'PickedUp',
//     );
//   }

//   Future<bool> markPharmacyAsAccepted({
//     required String riderId,
//     required String orderId,
//     required String pharmacyId,
//   }) {
//     return updatePharmacyStatus(
//       riderId: riderId,
//       orderId: orderId,
//       pharmacyId: pharmacyId,
//       newStatus: 'Accepted',
//     );
//   }

//   /// ================= CLEAR =================

//   void clearOrder() {
//     _currentOrder = null;
//     _pendingPharmacies = [];
//     notifyListeners();
//   }
// }


















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

  /// Get pending pharmacies from pharmacyResponses array
  /// This is the single source of truth - when a pharmacy is picked up,
  /// it gets removed from this array by the backend
  List<PendingPharmacy> get pendingPharmacies {
    if (_currentOrder == null) return [];
    
    print('=== GETTING PENDING PHARMACIES ===');
    print('Total pharmacyResponses: ${_currentOrder!.pharmacyResponses.length}');
    
    // Use the static helper method to create PendingPharmacy list from pharmacyResponses
    final pharmacies = PendingPharmacy.fromOrder(_currentOrder!);
    
    for (var pharmacy in pharmacies) {
      print('Pharmacy: ${pharmacy.pharmacyName}, Status: ${pharmacy.status}');
    }
    
    print('Total pending pharmacies: ${pharmacies.length}');
    return pharmacies;
  }

  /// Get only accepted pharmacies (status = "Accepted")
  /// These are the pharmacies the rider needs to pick up now
  List<PendingPharmacy> get acceptedPharmacies {
    final accepted = pendingPharmacies
        .where((p) => p.status.toLowerCase() == 'rider accepted')
        .toList();
    
    print('Accepted pharmacies count: ${accepted.length}');
    return accepted;
  }

  /// Check if there are any pending pharmacies left in pharmacyResponses array
  /// If empty, all pharmacies have been picked up
  bool get hasNoPendingPharmacies {
    final isEmpty = _currentOrder?.pharmacyResponses.isEmpty ?? true;
    print('pharmacyResponses is empty: $isEmpty');
    return isEmpty;
  }

  /// Check if all pharmacies are picked up (same as hasNoPendingPharmacies)
  bool get areAllPharmaciesPickedUp {
    return hasNoPendingPharmacies;
  }

  /// ================= LOAD ORDER =================

  Future<bool> loadOrder(String orderId, String riderId) async {
    print('=== LOADING ORDER ===');
    print('Order ID: $orderId');
    print('Rider ID: $riderId');
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentOrder = await _service.getAcceptedOrder(orderId, riderId);

      if (_currentOrder != null) {
        print('Order loaded successfully');
        print('Order status: ${_currentOrder!.status}');
        print('Assigned rider status: ${_currentOrder!.assignedRiderStatus}');
        print('PharmacyResponses count: ${_currentOrder!.pharmacyResponses.length}');
        
        // Print pharmacy responses
        for (var response in _currentOrder!.pharmacyResponses) {
          print('Pharmacy ${response.pharmacyId}: ${response.status}');
        }
        
        _error = null;
      } else {
        _error = 'No accepted order found';
        print('No order found for rider');
      }

      _isLoading = false;
      notifyListeners();
      return _currentOrder != null;
    } catch (e) {
      _error = e.toString();
      print('Error loading order: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ================= NEXT PHARMACY =================

  /// Get the first accepted pharmacy to process
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
    print('=== UPDATING PHARMACY STATUS ===');
    print('Rider ID: $riderId');
    print('Order ID: $orderId');
    print('Pharmacy ID: $pharmacyId');
    print('New Status: $newStatus');
    
    _isLoading = true;
    notifyListeners();

    try {
      final request = UpdateStatusRequest(
        orderId: orderId,
        newStatus: newStatus,
        pharmacyId: pharmacyId,
      );

      await _service.updateOrderStatus(
        riderId: riderId,
        request: request,
      );

      print('Status updated successfully');
      
      // Reload order to get updated pharmacyResponses array
      await loadOrder(orderId, riderId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      print('Error updating pharmacy status: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// ================= SHORTCUT METHODS =================

  /// Mark pharmacy as picked up
  /// This will REMOVE the pharmacy from pharmacyResponses array
  Future<bool> markPharmacyAsPickedUp({
    required String riderId,
    required String orderId,
    required String pharmacyId,
  }) {
    print('=== MARK PHARMACY AS PICKED UP ===');
    print('This will remove pharmacy $pharmacyId from pharmacyResponses array');
    
    return updatePharmacyStatus(
      riderId: riderId,
      orderId: orderId,
      pharmacyId: pharmacyId,
      newStatus: 'PickedUp',
    );
  }

  /// Mark pharmacy as accepted
  /// This will update the pharmacy status in pharmacyResponses array to "Accepted"
  Future<bool> markPharmacyAsAccepted({
    required String riderId,
    required String orderId,
    required String pharmacyId,
  }) {
    print('=== MARK PHARMACY AS ACCEPTED ===');
    print('This will update pharmacy $pharmacyId status to "Accepted"');
    
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