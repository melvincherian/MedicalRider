import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
// Import your existing models and screens
// import 'package:veegify/model/AddressModel/address_model.dart';
// import 'package:veegify/views/AddressScreen/address_screen.dart';
// import 'package:veegify/views/AddressScreen/edit_address.dart';
// import 'package:veegify/views/AddressScreen/location_search_dart';

class MapScreen extends StatefulWidget {
  final bool isEditing;
  final dynamic existingAddress; // Replace with AddressModel? when available
  final String userId;

  const MapScreen({
    super.key,
    this.isEditing = false,
    this.existingAddress,
    this.userId = "default_user", // Provide default or make required
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLatLng = LatLng(12.9716, 77.5946); // Default to Bangalore
  String _address = "Loading address...";

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.existingAddress != null) {
      // Uncomment when AddressModel is available
      // _currentLatLng = LatLng(widget.existingAddress!.lat, widget.existingAddress!.lng);
      // _address = widget.existingAddress!.address;
    } else {
      _determinePosition();
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_currentLatLng, 16);
    _getAddressFromLatLng(_currentLatLng);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'FlutterApp', // Required by Nominatim
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _address = data['display_name'] ?? 'No address found';
        });
      } else {
        setState(() {
          _address = 'Failed to load address';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Failed to load address';
      });
    }
  }

  void _onMapMoved(LatLng latLng) {
    setState(() {
      _currentLatLng = latLng;
    });
  }

  void _onMapIdle() {
    _getAddressFromLatLng(_currentLatLng);
  }

  // Navigate to search screen and handle result
  void _openSearchScreen() async {
    // Uncomment when LocationSearchScreen is available
    /*
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationSearchScreen(),
      ),
    );

    if (result != null) {
      final LatLng selectedLocation = result['location'];
      final String selectedAddress = result['address'];
      
      setState(() {
        _currentLatLng = selectedLocation;
        _address = selectedAddress;
      });
      
      _mapController.move(_currentLatLng, 16);
    }
    */
    
    // Temporary placeholder - show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Search functionality will be implemented')),
    );
  }

  // Navigate to Edit Address Screen
  void _confirmLocation() {
    // Uncomment when EditAddressScreen is available
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(
          isEditing: widget.isEditing,
          selectedLat: _currentLatLng.latitude,
          selectedLng: _currentLatLng.longitude,
          selectedAddress: _address,
          userId: widget.userId,
        ),
      ),
    );
    */
    
    // Temporary placeholder - show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Confirmed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected Location:'),
              SizedBox(height: 8),
              Text(
                _address,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('Coordinates: ${_currentLatLng.latitude.toStringAsFixed(4)}, ${_currentLatLng.longitude.toStringAsFixed(4)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLatLng,
              initialZoom: 16.0,
              onMapEvent: (event) {
                if (event is MapEventMove) {
                  _onMapMoved(_mapController.camera.center);
                } else if (event is MapEventMoveEnd) {
                  _onMapIdle();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
            ],
          ),

          // Top Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _openSearchScreen,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Search for a location...',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Center pin icon
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: 300,
            right: 16,
            child: GestureDetector(
              onTap: _determinePosition,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.my_location, size: 18, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        'Current location',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Place the pin at exact delivery location',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _address,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm & proceed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
    );
  }
}