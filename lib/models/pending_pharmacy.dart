class PendingPharmacy {
  final String pharmacyId;
  final String pharmacyName;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;

  PendingPharmacy({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });
}