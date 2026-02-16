import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/navbar_screen.dart';
import 'package:medical_delivery_app/models/order_model.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';
import 'package:medical_delivery_app/utils/pharmacy_pickup_manager.dart';
import 'package:medical_delivery_app/widget/image_upload_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDeliveredModal extends StatefulWidget {
  final String orderId;

  const OrderDeliveredModal({super.key, required this.orderId});

  @override
  State<OrderDeliveredModal> createState() => _OrderDeliveredModalState();
}

class _OrderDeliveredModalState extends State<OrderDeliveredModal> {
  Order? currentOrder;
  Map<String, dynamic>? orderData;
  Map<String, dynamic>? billingDetails;
  bool isUpdatingStatus = false;
  bool isLoading = true;
  bool isStaticOrder = false;
  String riderid = '';
  String? selectedPaymentOption;
  String? qrCodeUrl;
  String? upiId;
  bool isLoadingUpiInfo = false;
  final _pickupManager = PharmacyPickupManager();

  @override
  void initState() {
    super.initState();

    // Run async tasks in sequence after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRiderData();
      await _loadOrderData();
    });
  }

  Future<void> _loadRiderData() async {
    final rider = await SharedPreferenceService.getRiderData();
    if (rider != null) {
      setState(() {
        riderid = rider.id;
      });
      print('Loaded rider data: ${rider.name}, Status: ${rider.status}');
    }
  }

  Future<void> _loadOrderData() async {
    try {
      setState(() {
        isLoading = true;
      });

      print('=== ORDER DELIVERED MODAL - LOAD ORDER ===');
      print('Looking for order ID: ${widget.orderId}');

      // Fetch from API for real orders
      print('Fetching from API...');
      final response = await http.get(
        Uri.parse(
          'http://31.97.206.144:7021/api/rider/pickeduporders/$riderid',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> pickedUpOrders = data['pickedUpOrders'] ?? [];

        // Find the order with matching orderId
        Map<String, dynamic>? foundOrderData;
        for (var orderItem in pickedUpOrders) {
          if (orderItem['order']['_id'] == widget.orderId) {
            foundOrderData = orderItem;
            break;
          }
        }

        if (foundOrderData != null) {
          print('Found API order: ${foundOrderData['order']['_id']}');
          
          // Extract order details
          final order = foundOrderData['order'];
          final billing = foundOrderData['billingDetails'];
          final upiIdFromApi = foundOrderData['upiId'];
          
          setState(() {
            orderData = order;
            billingDetails = billing;
            upiId = upiIdFromApi;
            isStaticOrder = false;
            isLoading = false;
          });
          
          print('API order loaded successfully');
          print('UPI ID: $upiId');
          print('Billing Details: $billingDetails');
        } else {
          print('Order not found in API response');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Failed to load orders from API: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }

      print('==========================================');
    } catch (e) {
      print('Error loading order data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUpiInfo() async {
    setState(() {
      isLoadingUpiInfo = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:7021/api/rider/upi-info'),
        headers: {'Content-Type': 'application/json'},
      );

      print('UPI Info Response Status: ${response.statusCode}');
      print('UPI Info Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          qrCodeUrl = data['qrCodeUrl'];
          if (upiId == null) {
            upiId = data['upiId'];
          }
          isLoadingUpiInfo = false;
        });
        print('QR Code URL loaded: $qrCodeUrl');
        print('UPI ID loaded: $upiId');
      } else {
        print('Failed to load UPI info: ${response.statusCode}');
        setState(() {
          isLoadingUpiInfo = false;
        });
        _showErrorSnackbar('Failed to load UPI information');
      }
    } catch (e) {
      print('Error loading UPI info: $e');
      setState(() {
        isLoadingUpiInfo = false;
      });
      _showErrorSnackbar('Error loading UPI information: $e');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    try {
      print('=== OPENING GOOGLE MAPS ===');
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('===========================');

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
        try {
          if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
            launched = await launchUrl(
              Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication,
            );
          }
        } catch (e) {
          print('Could not launch Google Maps web: $e');
        }
      }

      if (!launched) {
        _showErrorSnackbar(
          'Could not open Google Maps. Please check if you have Google Maps installed.',
        );
      }
    } catch (e) {
      print('Failed to open Google Maps: $e');
      _showErrorSnackbar('Failed to open Google Maps: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleOrderDelivered() async {
    if (orderData == null) {
      _showErrorSnackbar('Order data not available');
      return;
    }

    // Validate payment method selection for COD orders
    final paymentMethod = orderData!['paymentMethod'] ?? '';
    if (paymentMethod.toLowerCase() != 'online') {
      if (selectedPaymentOption == null) {
        _showErrorSnackbar('Please select a payment method');
        return;
      }
    }

    setState(() {
      isUpdatingStatus = true;
    });

    try {
      print('=== ORDER DELIVERY ===');
      print("RiderId: $riderid");
      print("Order Id: ${widget.orderId}");

      final totalAmount = orderData!['totalAmount'] ?? 0;
      double collectedAmount = totalAmount.toDouble();

      String paymentMethodType;
      if (paymentMethod.toLowerCase() == 'online') {
        paymentMethodType = 'online';
      } else {
        paymentMethodType = selectedPaymentOption!.toLowerCase();
      }

      final payload = {
        'collectedAmount': collectedAmount,
        'paymentMethodType': paymentMethodType,
      };

      print("Payload: ${json.encode(payload)}");
            print("Payloaddddddddddd: $riderid");
                        print("Payloaddddddddddd: ${widget.orderId}");



      final response = await http.put(
        Uri.parse(
          'http://31.97.206.144:7021/api/rider/deliver-order/$riderid/${widget.orderId}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Reset pharmacy pickup manager
        _pickupManager.reset();
        
        _showSuccessSnackbar('Order delivered successfully!');
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!mounted) return;
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavbarScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        final responseData = json.decode(response.body);
        final errorMessage =
            responseData['message'] ?? 'Failed to update order status';

        if (mounted) {
          _showErrorSnackbar(errorMessage);
        }
      }
      print('===========================');
    } catch (e) {
      print('Error in _handleOrderDelivered: $e');
      if (mounted) {
        _showErrorSnackbar('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isUpdatingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const NavbarScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Drop Details!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Order not found',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NavbarScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Go Home'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Map area
                      GestureDetector(
                        onTap: () {
                          final userLocation = orderData!['userId']['location'];
                          final coordinates = userLocation['coordinates'] as List;
                          if (coordinates.length >= 2) {
                            _openGoogleMaps(
                              coordinates[1], // latitude
                              coordinates[0], // longitude
                            );
                          } else {
                            _showErrorSnackbar('Location not available');
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/mapimage.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.map,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Main content
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drop section
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5931DD).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFF5931DD).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFF5931DD),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Drop',
                                          style: TextStyle(
                                            color: Color(0xFF5931DD),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Customer details
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orderData!['userId']['name'] ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    orderData!['userId']['mobile'] ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getFullAddress(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Order: ${orderData!['_id']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Upload Proof
                            Align(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageUploadWidget(
                                            userId: riderid,
                                            orderId: widget.orderId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.upload,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Upload Proof',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // How To Reach section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'How To Reach:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildActionButton(
                                          icon: Icons.phone,
                                          label: 'Call',
                                          onTap: () {
                                            final mobile = orderData!['userId']['mobile'];
                                            if (mobile != null && mobile.isNotEmpty) {
                                              _makePhoneCall(mobile);
                                            } else {
                                              _showErrorSnackbar('Phone number not available');
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildActionButton(
                                          icon: Icons.map_outlined,
                                          label: 'Map',
                                          onTap: () {
                                            final userLocation = orderData!['userId']['location'];
                                            final coordinates = userLocation['coordinates'] as List;
                                            if (coordinates.length >= 2) {
                                              _openGoogleMaps(
                                                coordinates[1],
                                                coordinates[0],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Payment section
                            if ((orderData!['paymentMethod'] ?? '').toLowerCase() != 'online')
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F9F0),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFE0F2E0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Choose Payment Method:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: "Cash",
                                            groupValue: selectedPaymentOption,
                                            onChanged: (value) {
                                              setState(() => selectedPaymentOption = value);
                                            },
                                          ),
                                          const Text("Cash"),
                                          Radio<String>(
                                            value: "Online",
                                            groupValue: selectedPaymentOption,
                                            onChanged: (value) async {
                                              setState(() => selectedPaymentOption = value);
                                              if (value == "Online") {
                                                await _loadUpiInfo();
                                              }
                                            },
                                          ),
                                          const Text("Online"),
                                        ],
                                      ),
                                      if (selectedPaymentOption == "Online") ...[
                                        const SizedBox(height: 10),
                                        Center(
                                          child: isLoadingUpiInfo
                                              ? const CircularProgressIndicator()
                                              : qrCodeUrl != null
                                                  ? Column(
                                                      children: [
                                                        Image.network(
                                                          qrCodeUrl!,
                                                          width: 200,
                                                          height: 200,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              width: 200,
                                                              height: 200,
                                                              color: Colors.grey[300],
                                                              child: const Center(
                                                                child: Icon(Icons.error),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        if (upiId != null) ...[
                                                          const SizedBox(height: 8),
                                                          Text(
                                                            'UPI ID: $upiId',
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    )
                                                  : upiId != null
                                                      ? Column(
                                                          children: [
                                                            Container(
                                                              width: 200,
                                                              height: 200,
                                                              color: Colors.grey[200],
                                                              child: Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(Icons.qr_code, size: 80, color: Colors.grey),
                                                                    const SizedBox(height: 8),
                                                                    const Text('QR Code not available'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Text(
                                                              'UPI ID: $upiId',
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black87,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(
                                                          width: 200,
                                                          height: 200,
                                                          color: Colors.grey[300],
                                                          child: const Center(
                                                            child: Text('No Payment Info Available'),
                                                          ),
                                                        ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Center(
                                          child: Text(
                                            "Scan to Pay",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),

                            if ((orderData!['paymentMethod'] ?? '').toLowerCase() == 'online')
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F9F0),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFE0F2E0),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Bill Paid Through Online',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            // Bill details
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  if (billingDetails != null) ...[
                                    _buildBillRow(
                                      'Total Items',
                                      billingDetails!['totalItems'].toString(),
                                    ),
                                    _buildBillRow(
                                      'Sub Total',
                                      billingDetails!['subTotal'] ?? '₹0.00',
                                    ),
                                    _buildBillRow(
                                      'Platform Fee',
                                      billingDetails!['platformFee'] ?? '₹0.00',
                                    ),
                                    _buildBillRow(
                                      'Delivery Charge',
                                      billingDetails!['deliveryCharge'] ?? '₹0.00',
                                    ),
                                    const Divider(height: 20),
                                    _buildBillRow(
                                      'Total Paid',
                                      billingDetails!['totalPaid'] ?? '₹0.00',
                                      isTotal: true,
                                    ),
                                  ] else
                                    _buildBillRow(
                                      'Total Amount',
                                      '₹${(orderData!['totalAmount'] ?? 0).toStringAsFixed(2)}',
                                      isTotal: true,
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Order Delivered Button with Swipe Gesture
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(20),
                              child: Stack(
                                children: [
                                  // Fixed background button
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isUpdatingStatus
                                          ? Colors.grey
                                          : const Color(0xFF5931DD),
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Center(
                                      child: Text(
                                        isUpdatingStatus
                                            ? 'Updating...'
                                            : 'Swipe to Deliver →',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Dismissible white container
                                  Dismissible(
                                    key: const ValueKey("orderDeliveredSwipe"),
                                    direction: DismissDirection.startToEnd,
                                    dismissThresholds: const {
                                      DismissDirection.startToEnd: 0.9,
                                    },
                                    confirmDismiss: (_) async {
                                      if (!isUpdatingStatus) {
                                        await _handleOrderDelivered();
                                      }
                                      return false;
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: isUpdatingStatus
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    Colors.deepPurple,
                                                  ),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.keyboard_double_arrow_right,
                                                color: Colors.deepPurple,
                                                size: 20,
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
                    ],
                  ),
                ),
    );
  }

  String _getFullAddress() {
    if (orderData == null || orderData!['deliveryAddress'] == null) {
      return 'N/A';
    }
    
    final address = orderData!['deliveryAddress'];
    final parts = <String>[];
    
    if (address['house'] != null && address['house'].toString().isNotEmpty) {
      parts.add(address['house'].toString());
    }
    if (address['street'] != null && address['street'].toString().isNotEmpty) {
      parts.add(address['street'].toString());
    }
    if (address['city'] != null && address['city'].toString().isNotEmpty) {
      parts.add(address['city'].toString());
    }
    if (address['state'] != null && address['state'].toString().isNotEmpty) {
      parts.add(address['state'].toString());
    }
    if (address['pincode'] != null && address['pincode'].toString().isNotEmpty) {
      parts.add(address['pincode'].toString());
    }
    
    return parts.join(', ');
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF5931DD), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isTotal ? Colors.black : Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}