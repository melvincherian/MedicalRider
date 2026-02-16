
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/models/history_model.dart';
import 'package:medical_delivery_app/providers/history_provider.dart';
import 'package:medical_delivery_app/view/notifications/notification_screen.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Set to track expanded order IDs
  final Set<String> expandedOrders = <String>{};

  @override
  void initState() {
    super.initState();
    // Fetch orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().fetchAllOrders();
    });
  }

  void _toggleOrderExpansion(String orderId) {
    setState(() {
      if (expandedOrders.contains(orderId)) {
        expandedOrders.remove(orderId);
      } else {
        expandedOrders.add(orderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.history, color: Colors.black, size: 20),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, historyProvider, child) {
          if (historyProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (historyProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${historyProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      historyProvider.clearError();
                      historyProvider.fetchAllOrders();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => historyProvider.refreshOrders(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active Orders Section
                  if (historyProvider.hasActiveOrders) ...[
                    const Text(
                      'Active Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...historyProvider.activeOrders.map(
                      (order) => _buildOrderCard(
                        order,
                        historyProvider,
                        isActive: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Previous Orders Section
                  if (historyProvider.hasPreviousOrders) ...[
                    const Text(
                      'Previous Orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...historyProvider.previousOrders.map(
                      (order) => _buildOrderCard(
                        order,
                        historyProvider,
                        isActive: false,
                      ),
                    ),
                  ],

                  // Empty state
                  if (!historyProvider.hasActiveOrders &&
                      !historyProvider.hasPreviousOrders) ...[
                    const SizedBox(height: 100),
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.history, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No order history found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your completed and active orders will appear here',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
    OrderModel order,
    HistoryProvider provider, {
    required bool isActive,
  }) {
    final latestStatus = provider.getLatestStatus(order.statusTimeline);
    final totalItems = provider.getTotalItemsCount(order.orderItems);
    final pharmacyName = provider.getPharmacyName(order);
    final isExpanded = expandedOrders.contains(order.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 186, 186, 186)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side: Circle -> Dotted Line -> Location
                Column(
                  children: [
                    // Top Circle
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: provider.getOrderStatusColor(
                          latestStatus?.status ?? 'pending',
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Dotted Line
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      height: 30,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.vertical,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              8,
                              (index) => Container(
                                width: 2,
                                height: 3,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Bottom Location Icon
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Right side details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pharmacy Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pharmacyName ?? 'Unknown Pharmacy',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Earned Amount Box
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 12,
                          //     vertical: 4,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey.shade200,
                          //     borderRadius: BorderRadius.circular(9),
                          //   ),
                          //   child: Text(
                          //     order.billingDetails!.deliveryCharge,
                          //     style: const TextStyle(
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.black87,
                          //     ),
                          //   ),

                          //   // child: Text(
                          //   //   order.deliveryCharge.toString(),
                          //   //   style: const TextStyle(
                          //   //     fontSize: 14,
                          //   //     fontWeight: FontWeight.w500,
                          //   //     color: Colors.black87,
                          //   //   ),
                          //   // ),

                          //   // child: Text(
                          //   //   order.billingDetails?.totalPaid ??
                          //   //       order.totalAmount.toString(),
                          //   //   style: const TextStyle(
                          //   //     fontSize: 14,
                          //   //     fontWeight: FontWeight.w500,
                          //   //     color: Colors.black87,
                          //   //   ),
                          //   // ),

                          //   // child: Text(
                          //   //   provider.formatCurrency(order.totalAmount),
                          //   //   style: const TextStyle(
                          //   //     fontSize: 14,
                          //   //     fontWeight: FontWeight.w500,
                          //   //     color: Colors.black87,
                          //   //   ),
                          //   // ),
                          // ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              order.deliveryCharge.toString(),
                                  // Fallback calculation
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Time Row
                      Text(
                        provider.getFormattedDate(order.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      //    Text(
                      //  order.createdAt.toString(),
                      //     style: const TextStyle(
                      //       fontSize: 12,
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      const SizedBox(height: 8),
                      // Address
                      Text(
                        order.deliveryAddress.fullAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Expand/Collapse Button
            GestureDetector(
              onTap: () => _toggleOrderExpansion(order.id),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, size: 27),
                  ),
                ],
              ),
            ),

            // Expandable Details Section
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? null : 0,
              child: isExpanded
                  ? _buildExpandedDetails(order, provider, isActive)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedDetails(
    OrderModel order,
    HistoryProvider provider,
    bool isActive,
  ) {
    final totalItems = provider.getTotalItemsCount(order.orderItems);

    return Column(
      children: [
        const SizedBox(height: 12),

        // Order Items Summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$totalItems item${totalItems > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    provider.getPaymentMethodDisplay(order.paymentMethod),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              if (order.orderItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Show all items with images
                ...order.orderItems.map(
                  (item) => _buildOrderItem(item, provider, showImages: true),
                ),
              ],

              // Always show billing details section
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Billing Details - Always displayed
              if (order.billingDetails != null)
                _buildBillingDetails(order.billingDetails!, provider)
              else
                // Fallback billing display if billingDetails is null
                _buildFallbackBillingDetails(order, provider),

              // Payment Status
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0F2E0), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Bill Paid Through ${provider.getPaymentMethodDisplay(order.paymentMethod)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Voice note indicator
        if (provider.hasVoiceNote(order)) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.mic, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              const Text(
                'Voice note attached',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFallbackBillingDetails(
    OrderModel order,
    HistoryProvider provider,
  ) {
    // You might need to calculate these values or get them from the order directly
    final subTotal = provider.formatCurrency(
      order.totalAmount * 0.85,
    ); // Assuming 85% is subtotal
    final platformFee = provider.formatCurrency(
      order.totalAmount * 0.05,
    ); // 5% platform fee
    final deliveryCharge =order.deliveryCharge.toString();
     // 10% delivery
    final totalPaid = provider.formatCurrency(order.totalAmount);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sub Total',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              subTotal,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Platform Fee',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              platformFee,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Delivery Charge',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              deliveryCharge,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Paid',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            Text(
              order.totalAmount.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            // Text(
            //   provider.formatCurrency(order.totalAmount),
            //   style: const TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black87,
            //   ),
            // ),

            //  Text(
            //   totalPaid,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillingDetails(
    BillingDetailsModel billing,
    HistoryProvider provider,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sub Total',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              billing.subTotal,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Platform Fee',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              billing.platformFee,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Delivery Charge',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              billing.deliveryCharge,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Paid',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              billing.totalPaid,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderItem(
    OrderItemModel item,
    HistoryProvider provider, {
    required bool showImages,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Show image container
          if (showImages) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: item.medicineId?.images.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item.medicineId!.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.medical_services,
                            size: 16,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.medical_services,
                      size: 16,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.medicineId?.name ?? item.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.medicineId != null) ...[
                  Text(
                    '₹${item.medicineId!.mrp}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          Text(
            'x${item.quantity}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
