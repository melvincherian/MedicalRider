import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_delivery_app/view/pending_pharmacies_screen.dart';
import 'package:medical_delivery_app/view/user_screen.dart';
import 'package:medical_delivery_app/widget/order_delivered_modal.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/rider_order_model.dart';
import '../../providers/rider_order_provider.dart';
import '../../services/rider_order_service.dart';
import '../home/navbar_screen.dart';

class ConfirmOrderModal extends StatefulWidget {
  final String orderId;
  final String riderId;

  const ConfirmOrderModal({
    super.key,
    required this.orderId,
    required this.riderId,
  });

  @override
  State<ConfirmOrderModal> createState() => _ConfirmOrderModalState();
}

class _ConfirmOrderModalState extends State<ConfirmOrderModal> {
  bool _isUpdatingStatus = false;
  final RiderOrderService _service = RiderOrderService();
  final ImagePicker _imagePicker = ImagePicker();
  
  final Map<String, List<File>> _pharmacyImages = {};
  final Map<String, bool> _isUploading = {};
  final Map<String, bool> _imagesUploaded = {};

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    print('=== LOADING ORDER IN CONFIRM MODAL ===');
    print('Order ID: ${widget.orderId}');
    print('Rider ID: ${widget.riderId}');
    
    final provider = Provider.of<RiderOrderProvider>(context, listen: false);
    await provider.loadOrder(widget.orderId, widget.riderId);
    
    print('Order loaded. pharmacyResponses count: ${provider.currentOrder?.pharmacyResponses.length ?? 0}');
    
    // After loading, check pharmacy status
    if (mounted) {
      _checkPharmacyStatus();
    }
  }

  void _checkPharmacyStatus() {
    final provider = Provider.of<RiderOrderProvider>(context, listen: false);
    
    print('=== CHECKING PHARMACY STATUS ===');
    
    // Check if pharmacyResponses array is empty (all pharmacies picked up)
    if (provider.hasNoPendingPharmacies) {
      print('pharmacyResponses is EMPTY - all pharmacies picked up!');
      print('Navigating to UserScreen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToUserScreen();
      });
      return;
    }
    
    print('Total pharmacyResponses: ${provider.pendingPharmacies.length}');
    
    // Count accepted pharmacies (status = "Accepted")
    final acceptedPharmacies = provider.acceptedPharmacies;
    
    print('Accepted pharmacies count: ${acceptedPharmacies.length}');
    
    // If there are NO accepted pharmacies, navigate to PendingPharmaciesScreen
    if (acceptedPharmacies.isEmpty) {
      print('No accepted pharmacies found. Navigating to PendingPharmaciesScreen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToPendingPharmaciesScreen();
      });
    }
  }

  void _navigateToPendingPharmaciesScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PendingPharmaciesScreen(
          orderId: widget.orderId,
          riderId: widget.riderId,
        ),
      ),
    );
  }

  void _navigateToUserScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDeliveredModal(
          orderId: widget.orderId,
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    try {
      final String googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      final String googleMapsAppUrl =
          'google.navigation:q=$latitude,$longitude';

      bool launched = false;

      try {
        if (await canLaunchUrl(Uri.parse(googleMapsAppUrl))) {
          launched = await launchUrl(
            Uri.parse(googleMapsAppUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      } catch (e) {
        print('Could not launch Google Maps app: $e');
      }

      if (!launched) {
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          launched = await launchUrl(
            Uri.parse(googleMapsUrl),
            mode: LaunchMode.externalApplication,
          );
        }
      }

      if (!launched) {
        _showErrorSnackbar(
          'Could not open Google Maps. Please check if you have Google Maps installed.',
        );
      }
    } catch (e) {
      _showErrorSnackbar('Failed to open Google Maps');
    }
  }

  Future<void> _pickImage(String pharmacyId) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          if (!_pharmacyImages.containsKey(pharmacyId)) {
            _pharmacyImages[pharmacyId] = [];
          }
          _pharmacyImages[pharmacyId]!.add(File(image.path));
          _imagesUploaded[pharmacyId] = false;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Failed to pick image');
    }
  }

  void _removeImage(String pharmacyId, int index) {
    setState(() {
      if (_pharmacyImages.containsKey(pharmacyId)) {
        _pharmacyImages[pharmacyId]!.removeAt(index);
        if (_pharmacyImages[pharmacyId]!.isEmpty) {
          _pharmacyImages.remove(pharmacyId);
          _imagesUploaded[pharmacyId] = false;
        }
      }
    });
  }

  Future<bool> _uploadDeliveryProof(String pharmacyId) async {
    if (!_pharmacyImages.containsKey(pharmacyId) || 
        _pharmacyImages[pharmacyId]!.isEmpty) {
      _showErrorSnackbar('Please take at least one photo');
      return false;
    }

    setState(() {
      _isUploading[pharmacyId] = true;
    });

    try {
      bool allUploadsSuccessful = true;
      
      for (var image in _pharmacyImages[pharmacyId]!) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://31.97.206.144:7021/api/rider/uploadDeliveryProof/${widget.riderId}/${widget.orderId}/$pharmacyId'),
        );
        
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
          ),
        );
        
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        
        print('Upload delivery proof response: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        if (response.statusCode != 200) {
          allUploadsSuccessful = false;
          break;
        }
      }
      
      setState(() {
        _isUploading[pharmacyId] = false;
        if (allUploadsSuccessful) {
          _imagesUploaded[pharmacyId] = true;
        }
      });
      
      if (allUploadsSuccessful) {
        _showSuccessSnackbar('Photos uploaded successfully');
      }
      
      return allUploadsSuccessful;
    } catch (e) {
      setState(() {
        _isUploading[pharmacyId] = false;
        _imagesUploaded[pharmacyId] = false;
      });
      _showErrorSnackbar('Failed to upload images: $e');
      return false;
    }
  }

  Future<void> _handlePharmacyPickup(String pharmacyId) async {
    print('=== HANDLING PHARMACY PICKUP ===');
    print('Pharmacy ID: $pharmacyId');
    print('This will REMOVE pharmacy from pharmacyResponses array');
    
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final provider = Provider.of<RiderOrderProvider>(context, listen: false);
      final success = await provider.markPharmacyAsPickedUp(
        riderId: widget.riderId,
        orderId: widget.orderId,
        pharmacyId: pharmacyId,
      );

      print('Pickup status update result: $success');

      if (success && mounted) {
        // Clear images for this pharmacy
        setState(() {
          _pharmacyImages.remove(pharmacyId);
          _imagesUploaded.remove(pharmacyId);
        });

        _showSuccessSnackbar('Pharmacy marked as picked up');

        // Reload the order to get updated pharmacyResponses array
        await provider.loadOrder(widget.orderId, widget.riderId);

        print('Order reloaded. pharmacyResponses count: ${provider.currentOrder?.pharmacyResponses.length ?? 0}');
        
        // Re-check pharmacy status after reload
        _checkPharmacyStatus();
        
        // If still on this screen (there are more accepted pharmacies), rebuild
        if (mounted) {
          setState(() {}); 
        }
      } else {
        _showErrorSnackbar('Failed to update status');
      }
    } catch (e) {
      print('Error in handlePharmacyPickup: $e');
      _showErrorSnackbar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStatus = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Get the current accepted pharmacy (the one with status "Accepted")
  PendingPharmacy? _getCurrentPharmacy(RiderOrderProvider provider) {
    final acceptedPharmacies = provider.acceptedPharmacies;
    
    if (acceptedPharmacies.isEmpty) return null;
    return acceptedPharmacies.first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RiderOrderProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.currentOrder == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading order',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadOrder,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final order = provider.currentOrder;
        if (order == null) {
          return const Scaffold(
            body: Center(
              child: Text('Order not found'),
            ),
          );
        }

        // Get the current accepted pharmacy to process
        final currentPharmacy = _getCurrentPharmacy(provider);
        
        if (currentPharmacy == null) {
          // No accepted pharmacies - will navigate in _checkPharmacyStatus
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Get items for this pharmacy
        final List<OrderItem> pharmacyItems = [];
        for (var item in order.orderItems) {
          if (item.medicineId != null && 
              item.medicineId!.pharmacyId.id == currentPharmacy.pharmacyId) {
            pharmacyItems.add(item);
          }
        }

        // Get delivery location
        final userLocation = order.userId.location;
        double? deliveryLat;
        double? deliveryLng;
        
        if (userLocation.coordinates.length >= 2) {
          deliveryLng = userLocation.coordinates[0];
          deliveryLat = userLocation.coordinates[1];
        }

        // Check if images are uploaded for current pharmacy
        final bool imagesUploaded = _imagesUploaded[currentPharmacy.pharmacyId] ?? false;
        final bool hasImages = _pharmacyImages.containsKey(currentPharmacy.pharmacyId) && 
                              _pharmacyImages[currentPharmacy.pharmacyId]!.isNotEmpty;

        // Count total pending pharmacies from pharmacyResponses array
        final totalPendingCount = provider.pendingPharmacies.length;

        return Scaffold(
          body: Stack(
            children: [
              // Map Background
              GestureDetector(
                onTap: () {
                  if (deliveryLat != null && deliveryLng != null) {
                    _openGoogleMaps(deliveryLat, deliveryLng);
                  } else {
                    _showErrorSnackbar('Delivery location not available');
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(Icons.map, size: 50, color: Colors.grey),
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavbarScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),

              // Order Number Badge
              Positioned(
                top: MediaQuery.of(context).padding.top + 70,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Order #${order.id.substring(order.id.length - 6)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Sheet
              Positioned(
                top: MediaQuery.of(context).padding.top + 120,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Delivery Address Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.deliveryAddress.fullAddress,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$totalPendingCount Remaining',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Current Pharmacy Card
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  // Pharmacy Header
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.local_pharmacy,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentPharmacy.pharmacyName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                currentPharmacy.address,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[600],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Items for this pharmacy
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: pharmacyItems.map<Widget>((item) {
                                        final medicine = item.medicineId;
                                        if (medicine == null) return const SizedBox.shrink();

                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.grey[100],
                                                ),
                                                child: medicine.images.isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: Image.network(
                                                          medicine.images.first,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return const Icon(
                                                              Icons.medication,
                                                              color: Colors.grey,
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.medication,
                                                        color: Colors.grey,
                                                      ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      medicine.name,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Qty: ${item.quantity}',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '₹${medicine.mrp}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  // Image Upload Section
                                  _buildImageUploadSection(
                                    pharmacyId: currentPharmacy.pharmacyId,
                                  ),

                                  // Upload Button
                                  if (hasImages && !imagesUploaded)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: (_isUploading[currentPharmacy.pharmacyId] ?? false)
                                              ? null
                                              : () => _uploadDeliveryProof(currentPharmacy.pharmacyId),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: (_isUploading[currentPharmacy.pharmacyId] ?? false)
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  'Upload Photos',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),

                                  // Uploaded status
                                  if (imagesUploaded)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.green.shade200),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Photos Uploaded',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.green.shade700,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  // Pickup Button
                                  if (imagesUploaded)
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: _isUpdatingStatus
                                              ? null
                                              : () => _handlePharmacyPickup(currentPharmacy.pharmacyId),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: _isUpdatingStatus
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  'Mark as Picked Up',
                                                  style: TextStyle(
                                                    fontSize: 14,
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
                      ),

                      // Bottom Action Buttons
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Navigate Button
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: totalPendingCount == 0 
                                      ? const Color(0xFF5931DD)
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextButton(
                                  onPressed: totalPendingCount == 0
                                      ? _navigateToUserScreen
                                      : null,
                                  child: Text(
                                    totalPendingCount == 0
                                        ? 'Proceed to Delivery'
                                        : 'Complete pickups first ($totalPendingCount left)',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Location Button
                            GestureDetector(
                              onTap: () {
                                if (deliveryLat != null && deliveryLng != null) {
                                  _openGoogleMaps(deliveryLat, deliveryLng);
                                } else {
                                  _openGoogleMaps(
                                    currentPharmacy.latitude,
                                    currentPharmacy.longitude,
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.grey[700],
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageUploadSection({required String pharmacyId}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pickup Photos (Required)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          if (_pharmacyImages.containsKey(pharmacyId) && _pharmacyImages[pharmacyId]!.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _pharmacyImages[pharmacyId]!.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _pharmacyImages[pharmacyId]![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (!(_isUploading[pharmacyId] ?? false) && !(_imagesUploaded[pharmacyId] ?? false))
                        Positioned(
                          top: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removeImage(pharmacyId, index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          
          const SizedBox(height: 8),
          
          if (!(_imagesUploaded[pharmacyId] ?? false))
            GestureDetector(
              onTap: () => _pickImage(pharmacyId),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (_pharmacyImages[pharmacyId]?.isEmpty ?? true) 
                          ? 'Add Photo' 
                          : 'Add More Photos',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (_isUploading[pharmacyId] ?? false)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }
}