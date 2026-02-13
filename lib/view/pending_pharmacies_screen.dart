import 'package:flutter/material.dart';
import 'package:medical_delivery_app/widget/confirm_order_modal.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/models/rider_order_model.dart';
import 'package:medical_delivery_app/providers/rider_order_provider.dart';

class PendingPharmaciesScreen extends StatefulWidget {
  final String orderId;
  final String riderId;

  const PendingPharmaciesScreen({
    super.key,
    required this.orderId,
    required this.riderId,
  });

  @override
  State<PendingPharmaciesScreen> createState() => _PendingPharmaciesScreenState();
}

class _PendingPharmaciesScreenState extends State<PendingPharmaciesScreen> {
  String? _selectedPharmacyId;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    print('=== LOADING ORDER IN PENDING PHARMACIES SCREEN ===');
    final provider = Provider.of<RiderOrderProvider>(context, listen: false);
    await provider.loadOrder(widget.orderId, widget.riderId);
  }

  Future<void> _handlePharmacySelection(PendingPharmacy pharmacy) async {
    print('=== HANDLING PHARMACY SELECTION ===');
    print('Selected Pharmacy: ${pharmacy.pharmacyName}');
    print('Pharmacy ID: ${pharmacy.pharmacyId}');
    
    setState(() {
      _selectedPharmacyId = pharmacy.pharmacyId;
      _isUpdating = true;
    });

    try {
      final provider = Provider.of<RiderOrderProvider>(context, listen: false);
      
      print('Calling markPharmacyAsAccepted...');
      final success = await provider.markPharmacyAsAccepted(
        riderId: widget.riderId,
        orderId: widget.orderId,
        pharmacyId: pharmacy.pharmacyId,
      );

      print('markPharmacyAsAccepted result: $success');

      if (success && mounted) {
        _showSuccessSnackbar('Pharmacy accepted successfully');
        
        // Navigate to ConfirmOrderModal which will show only this accepted pharmacy
        print('Navigating to ConfirmOrderModal...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmOrderModal(
              orderId: widget.orderId,
              riderId: widget.riderId,
            ),
          ),
        );
      } else {
        _showErrorSnackbar('Failed to update pharmacy status');
      }
    } catch (e) {
      print('Error in handlePharmacySelection: $e');
      _showErrorSnackbar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<RiderOrderProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Get ONLY pharmacies that are NOT yet accepted
        // Filter out pharmacies with status "Accepted"
        final allPharmacies = provider.pendingPharmacies;
        final pendingPharmacies = allPharmacies
            .where((p) => p.status.toLowerCase() != 'rider accepted')
            .toList();

        print('=== PENDING PHARMACIES SCREEN BUILD ===');
        print('Total pharmacies in pharmacyResponses: ${allPharmacies.length}');
        print('Pending (not accepted) pharmacies: ${pendingPharmacies.length}');
        for (var p in allPharmacies) {
          print('  - ${p.pharmacyName}: ${p.status}');
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Pharmacy to Accept'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmOrderModal(
                      orderId: widget.orderId,
                      riderId: widget.riderId,
                    ),
                  ),
                );
              },
            ),
          ),
          body: pendingPharmacies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: Colors.green[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Pending Pharmacies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All pharmacies have been accepted',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmOrderModal(
                                orderId: widget.orderId,
                                riderId: widget.riderId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Back to Pickup'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info card
                      Container(
                        width: double.infinity,
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
                                  Icons.info_outline,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Select Next Pharmacy',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Choose one pharmacy to accept and pick up medicines from.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pendingPharmacies.length} ${pendingPharmacies.length == 1 ? 'pharmacy' : 'pharmacies'} remaining',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Pharmacies list
                      ...pendingPharmacies.map((pharmacy) {
                        final bool isSelected = _selectedPharmacyId == pharmacy.pharmacyId;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected 
                                ? Colors.blue.withOpacity(0.05)
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? Colors.blue.shade100
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.local_pharmacy,
                                    color: Colors.blue.shade700,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  pharmacy.pharmacyName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            pharmacy.address,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          pharmacy.phone,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.orange.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        'Status: ${pharmacy.status}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: (_isUpdating && isSelected) 
                                        ? null 
                                        : () => _handlePharmacySelection(pharmacy),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected 
                                          ? Colors.green 
                                          : Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: isSelected ? 2 : 0,
                                    ),
                                    child: (_isUpdating && isSelected)
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isSelected 
                                                    ? Icons.check_circle
                                                    : Icons.check_circle_outline,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                isSelected 
                                                    ? 'Processing...' 
                                                    : 'Accept & Proceed',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
        );
      },
    );
  }
}