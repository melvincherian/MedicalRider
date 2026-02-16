import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/navbar_screen.dart';
import 'package:medical_delivery_app/models/pending_accepted_order_model.dart';
import 'package:medical_delivery_app/providers/pending_accepted_order_provider.dart';
import 'package:medical_delivery_app/widget/confirm_order_modal.dart';
import 'package:medical_delivery_app/widget/order_delivered_modal.dart';
import 'package:provider/provider.dart';

class PharmacyPickupScreen extends StatefulWidget {
  final String orderId;
  final String riderId;

  const PharmacyPickupScreen({
    super.key,
    required this.orderId,
    required this.riderId,
  });

  @override
  State<PharmacyPickupScreen> createState() => _PharmacyPickupScreenState();
}

class _PharmacyPickupScreenState extends State<PharmacyPickupScreen> {
  String? _selectedPharmacyId;
  NewOrder? _order;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrderDetails();
    });
  }

  Future<void> _fetchOrderDetails() async {
    final provider = Provider.of<PendingAcceptedOrderProvider>(
      context,
      listen: false,
    );

    await provider.fetchPendingAcceptedOrders(widget.riderId);

    if (mounted) {
      setState(() {
        _order = provider.getOrderById(widget.orderId);
      });

      if (_order == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Order not found'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  OrderDeliveredModal(orderId: widget.orderId,),
          ),
        );
      }
    }
  }

  Future<void> _handleAcceptOrder(
    BuildContext context,
    PendingAcceptedOrderProvider provider,
  ) async {
    if (_selectedPharmacyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pharmacy first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await provider.acceptOrderWithPharmacy(
      riderId: widget.riderId,
      orderId: widget.orderId,
      pharmacyId: _selectedPharmacyId!,
    );

    if (!success || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.updateMessage.isNotEmpty
                ? provider.updateMessage
                : 'Failed to accept order',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.updateMessage),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or to next screen
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>  ConfirmOrderModal(orderId: widget.orderId,riderId: widget.riderId,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NavbarScreen(),
              ),
            );
          },
        ),
        title: const Text(
          'Pharmacy Pickup',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<PendingAcceptedOrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && _order == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && _order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading order',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchOrderDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_order == null) {
            return const Center(
              child: Text('Order not found'),
            );
          }

          final order = _order!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Order ID
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Order #${order.orderId}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Divider(),
                      const SizedBox(height: 20),

                      // Pharmacy Selection Section
                      if (order.pharmacyResponses.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.1),
                                Colors.blue.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_pharmacy,
                                    color: Colors.blue[700],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Select Pickup Pharmacy',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tap to choose one pharmacy (${order.pharmacyResponses.length} available)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Pharmacy List
                        ...order.pharmacyResponses.map((response) {
                          final details = response.pharmacyDetails;
                          if (details == null) return const SizedBox.shrink();
                          
                          final isSelected = _selectedPharmacyId == response.pharmacyId;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPharmacyId = response.pharmacyId;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Radio indicator
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),

                                  // Pharmacy Image
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: details.image.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              details.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) {
                                                return const Icon(
                                                  Icons.local_pharmacy,
                                                  size: 25,
                                                  color: Colors.deepPurple,
                                                );
                                              },
                                            ),
                                          )
                                        : const Icon(
                                            Icons.local_pharmacy,
                                            size: 25,
                                            color: Colors.deepPurple,
                                          ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Pharmacy Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          details.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.blue[900]
                                                : Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          details.address,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: response.status.toLowerCase() == 'accepted'
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: response.status.toLowerCase() == 'accepted'
                                                  ? Colors.green
                                                  : Colors.orange,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            response.status,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: response.status.toLowerCase() == 'accepted'
                                                  ? Colors.green[700]
                                                  : Colors.orange[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: provider.isUpdating || _selectedPharmacyId == null
                        ? null
                        : () => _handleAcceptOrder(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: provider.isUpdating || _selectedPharmacyId == null
                            ? Colors.grey[300]
                            : const Color(0xFF5931DD),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: provider.isUpdating
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _selectedPharmacyId == null
                                      ? 'Select a Pharmacy'
                                      : 'Accept Order',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}