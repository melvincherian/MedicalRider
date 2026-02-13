/// Helper class to manage pharmacy pickup state across the app
/// This tracks which pharmacies have been picked up for the current order
class PharmacyPickupManager {
  static final PharmacyPickupManager _instance = PharmacyPickupManager._internal();
  
  factory PharmacyPickupManager() {
    return _instance;
  }
  
  PharmacyPickupManager._internal();
  
  final Set<String> _pickedUpPharmacyIds = {};
  
  /// Mark a pharmacy as picked up
  void markAsPickedUp(String pharmacyId) {
    _pickedUpPharmacyIds.add(pharmacyId);
  }
  
  /// Check if a pharmacy has been picked up
  bool isPickedUp(String pharmacyId) {
    return _pickedUpPharmacyIds.contains(pharmacyId);
  }
  
  /// Get all picked up pharmacy IDs
  Set<String> getPickedUpPharmacies() {
    return Set.from(_pickedUpPharmacyIds);
  }
  
  /// Reset all picked up pharmacies (call when starting a new order)
  void reset() {
    _pickedUpPharmacyIds.clear();
  }
  
  /// Get count of picked up pharmacies
  int get pickedUpCount => _pickedUpPharmacyIds.length;
}