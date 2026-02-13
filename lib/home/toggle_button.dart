
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medical_delivery_app/utils/helper_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusToggleButton extends StatefulWidget {
  const StatusToggleButton({Key? key}) : super(key: key);

  @override
  _StatusToggleButtonState createState() => _StatusToggleButtonState();
}

class _StatusToggleButtonState extends State<StatusToggleButton> {
  String status = 'offline'; // Default status
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialStatus();
  }

  /// Load initial status from shared preferences or API
  Future<void> _loadInitialStatus() async {
    try {
      final savedStatus = await SharedPreferenceService.getRiderStatus();
      if (savedStatus != null) {
        setState(() {
          status = savedStatus;
        });
      } else {
        final riderData = await SharedPreferenceService.getRiderData();
        if (riderData != null && riderData.status != null) {
          setState(() {
            status = riderData.status!;
          });
        }
      }
    } catch (e) {
      print('Error loading initial status: $e');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.red;
      case 'busy':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }

  Future<void> _updateStatusOnServer(String newStatus) async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get rider data to extract rider ID
      final riderData = await SharedPreferenceService.getRiderData();
      if (riderData == null) {
        _showError('Rider data not found. Please login again.');
        return;
      }

      final riderId = riderData.id; // Adjust based on your RiderModel structure
      final token = await SharedPreferenceService.getToken();

      final url = 'http://31.97.206.144:7021/api/rider/togglerider/$riderId';

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final body = json.encode({
        'status': newStatus,
      });

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated on server
        setState(() {
          status = newStatus;
        });

        // ✅ Save status locally
        await SharedPreferenceService.saveRiderStatus(newStatus);

        _showSuccess('Status updated to ${_formatStatus(newStatus)}');
      } else {
        _showError('Failed to update status: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      _showError('Network error: Please check your connection');
      print('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleStatus() async {
    if (isLoading) return; // Prevent multiple requests

    final newStatus = status == 'online' ? 'offline' : 'online';
    await _updateStatusOnServer(newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    return GestureDetector(
      onTap: _toggleStatus,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: statusColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(Icons.circle, color: statusColor, size: 28),
            const SizedBox(width: 4),
            Text(
              isLoading ? 'Updating...' : _formatStatus(status),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
