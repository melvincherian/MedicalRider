import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/profile_screen.dart';
import 'package:medical_delivery_app/home/toggle_button.dart';
import 'package:medical_delivery_app/providers/chart_provider.dart';
import 'package:medical_delivery_app/providers/profile_provider.dart';
import 'package:medical_delivery_app/providers/status_provider.dart';
import 'package:medical_delivery_app/providers/users_location_provider.dart';
import 'package:medical_delivery_app/utils/helper_function.dart';
// import 'package:medical_delivery_app/view/details/detail_screen.dart';
import 'package:medical_delivery_app/view/locationsearch/location_search_screen.dart';
import 'package:medical_delivery_app/view/notifications/notification_screen.dart';
import 'package:medical_delivery_app/view/pending_pharmacies_screen.dart';
import 'package:medical_delivery_app/widget/confirm_order_modal.dart';
import 'package:medical_delivery_app/widget/order_delivered_modal.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/dashboard_provider.dart';
import 'package:medical_delivery_app/providers/new_order_provider.dart';
import 'package:medical_delivery_app/widget/home_chart_widget.dart';
import 'package:medical_delivery_app/widget/order_modal.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String riderName = 'Rider';
  String riderid = '';
  bool _isLoadingCurrentLocation = false;
  bool _hasShownModal = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAlert = false;
  int _previousPendingOrdersCount = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    _loadRiderData();
    _fetchDashboardData();
    _fetchNewOrders();
    _fetchChartData();

    // Initialize profile data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _handleCurrentLocation();
      context.read<ProfileProvider>().initializeProfile();
      _isInitialized = true;
      // Initial check after everything is loaded
      _checkAndShowPendingOrderModal();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground - check for new orders
      _refreshAndCheckOrders();
    }
  }

  Future<void> _refreshAndCheckOrders() async {
    final newOrderProvider = Provider.of<NewOrderProvider>(
      context,
      listen: false,
    );
        print("sfjsfjdfjds;fj;dkfjdsk;fjds;lfjdsklfjdsfjk sdfjkhjs1111111111111111 $riderid");

    await newOrderProvider.fetchNewOrders(riderid);

    // After refresh, check if we need to show modal and play sound
    if (mounted) {
      _checkAndShowPendingOrderModal();
    }
  }

  Future<void> _playAlertSound() async {
    if (!_isPlayingAlert) {
      try {
        _isPlayingAlert = true;
        print("Starting alert sound...");
        await _audioPlayer.play(AssetSource('order_alert.mp3'));

        // Set up looping
        _audioPlayer.setReleaseMode(ReleaseMode.loop);

        print('Alert sound started playing');
      } catch (e) {
        print('Error playing alert sound: $e');
        _isPlayingAlert = false;
      }
    }
  }

  Future<void> _stopAlertSound() async {
    if (_isPlayingAlert) {
      try {
        await _audioPlayer.stop();
        _isPlayingAlert = false;
        print('Alert sound stopped');
      } catch (e) {
        print('Error stopping alert sound: $e');
      }
    }
  }

  Future<void> _handleCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

    try {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      await locationProvider.initLocation(riderid.toString());

      if (mounted) {
        if (locationProvider.hasError) {
          _showError(locationProvider.errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        _showError("Failed to get current location: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCurrentLocation = false;
        });
      }
    }
  }

  void _checkAndShowPendingOrderModal() {
    if (!_isInitialized || !mounted) return;

    final orderProvider = Provider.of<NewOrderProvider>(context, listen: false);

    print('Checking pending orders: ${orderProvider.pendingOrders.length}');
    print('Previous count: $_previousPendingOrdersCount');
    print('Has shown modal: $_hasShownModal');

    if (orderProvider.pendingOrders.isNotEmpty) {
      bool hasNewOrders =
          orderProvider.pendingOrders.length > _previousPendingOrdersCount;
      bool isFirstTimeWithOrders =
          _previousPendingOrdersCount == 0 && !_hasShownModal;

      // Only play sound for NEW orders
      if (hasNewOrders || isFirstTimeWithOrders) {
        print(
          'Playing alert sound for ${hasNewOrders ? "new" : "existing"} orders',
        );
        _playAlertSound();
      }

      _previousPendingOrdersCount = orderProvider.pendingOrders.length;

      // Show modal ONLY if not already shown
      if (!_hasShownModal) {
        _hasShownModal = true;

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && !_hasShownModal) return; // Double check

          final latestOrder = orderProvider.pendingOrders.first;

          showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            enableDrag: false,
            builder: (context) => OrderScreen(
              riderId: riderid.toString(),
              order: latestOrder,
              onOrderAccepted: () {
                _stopAlertSound();
                _hasShownModal = false;
                _previousPendingOrdersCount--;
                Navigator.of(context).pop(true);
              },
              onOrderRejected: () {
                _stopAlertSound();
                _hasShownModal = false;
                _previousPendingOrdersCount--;
                Navigator.of(context).pop(false);
              },
            ),
          ).then((result) async {
            _stopAlertSound();
            _hasShownModal = false;

            if (result == true) {
              _previousPendingOrdersCount--;

              await Future.wait([
                Provider.of<DashboardProvider>(
                  context,
                  listen: false,
                ).refreshDashboard(),
                Provider.of<NewOrderProvider>(
                  context,
                  listen: false,
                ).refreshOrders(riderid),
              ]);

              // if (mounted) {
              //   showModalBottomSheet(
              //     context: context,
              //     backgroundColor: Colors.transparent,
              //     isScrollControlled: true,
              //     isDismissible: false,
              //     enableDrag: false,
              //     builder: (context) =>
              //         ConfirmOrderModal(orderId: latestOrder.id),
              //   );
              // }
            } else {
              await Future.wait([
                Provider.of<DashboardProvider>(
                  context,
                  listen: false,
                ).refreshDashboard(),
                Provider.of<NewOrderProvider>(
                  context,
                  listen: false,
                ).refreshOrders(riderid),
              ]);
            }
          });
        });
      }
    } else {
      // Reset everything when no orders
      _previousPendingOrdersCount = 0;
      _hasShownModal = false;
      _stopAlertSound();
    }
  }

  // Future<void> _handleOrderButtonTap(
  //   BuildContext context,
  //   NewOrderProvider orderProvider,
  // ) async {
  //   _stopAlertSound();
  //   _hasShownModal = false;

  //   print('jjjjjjjjjjjjjjjjjjjjjjjjtttttttttttttttttttt${orderProvider.pendingOrders.isNotEmpty}');

  //   // Check for pending orders from NewOrderProvider
  //   if (orderProvider.pendingOrders.isNotEmpty) {
  //     final latestOrder = orderProvider.pendingOrders.first;

  //     final result = await showModalBottomSheet<bool>(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       isDismissible: false,
  //       enableDrag: false,
  //       builder: (context) => OrderModal(
  //         riderId: riderid.toString(),
  //         order: latestOrder,
  //         onOrderAccepted: () {
  //           _stopAlertSound();
  //           _hasShownModal = false;
  //           _previousPendingOrdersCount--;
  //           Navigator.of(context).pop(true);
  //         },
  //         onOrderRejected: () {
  //           _stopAlertSound();
  //           _hasShownModal = false;
  //           _previousPendingOrdersCount--;
  //           Navigator.of(context).pop(false);
  //         },
  //       ),
  //     );

  //     if (result == true && mounted) {
  //       await Future.wait([
  //         Provider.of<DashboardProvider>(
  //           context,
  //           listen: false,
  //         ).refreshDashboard(),
  //         Provider.of<NewOrderProvider>(
  //           context,
  //           listen: false,
  //         ).refreshOrders(riderid),
  //       ]);

  //       // showModalBottomSheet(
  //       //   context: context,
  //       //   backgroundColor: Colors.transparent,
  //       //   isScrollControlled: true,
  //       //   isDismissible: false,
  //       //   enableDrag: false,
  //       //   builder: (context) =>
  //       //       ConfirmOrderModal(orderId: latestOrder.id),
  //       // );
  //     } else if (result == false && mounted) {
  //       await Future.wait([
  //         Provider.of<DashboardProvider>(
  //           context,
  //           listen: false,
  //         ).refreshDashboard(),
  //         Provider.of<NewOrderProvider>(
  //           context,
  //           listen: false,
  //         ).refreshOrders(riderid),
  //       ]);
  //     }

  //     return;
  //   }

  //   // Backend fallback for accepted/picked up orders
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) =>
  //         const Center(child: CircularProgressIndicator()),
  //   );

  //   try {
  //     final riderId =
  //         context.read<ProfileProvider>().rider?.id ??
  //             '68db5ca9449eb73e2d2cc7d0';

  //     // ACCEPTED ORDERS
  //     final acceptedResponse = await http.get(
  //       Uri.parse(
  //         'http://31.97.206.144:7021/api/rider/acceptedorders/$riderId',
  //       ),
  //     );

  //     if (acceptedResponse.statusCode == 200) {
  //       final acceptedData = json.decode(acceptedResponse.body);

  //       if (acceptedData['acceptedOrder'] != null) {
  //         final orderId = acceptedData['acceptedOrder']['order']['_id'];

  //         Navigator.pop(context);

  //         // showModalBottomSheet(
  //         //   context: context,
  //         //   backgroundColor: Colors.transparent,
  //         //   isScrollControlled: true,
  //         //   isDismissible: false,
  //         //   enableDrag: false,
  //         //   builder: (context) =>
  //         //       ConfirmOrderModal(orderId: orderId),
  //         // );
  //         return;
  //       }
  //     }

  //     // PICKED UP ORDERS
  //     final pickedUpResponse = await http.get(
  //       Uri.parse(
  //         'http://31.97.206.144:7021/api/rider/pickeduporders/$riderId',
  //       ),
  //     );

  //     if (pickedUpResponse.statusCode == 200) {
  //       final pickedUpData = json.decode(pickedUpResponse.body);

  //       if (pickedUpData['pickedUpOrders'] != null &&
  //           (pickedUpData['pickedUpOrders'] as List).isNotEmpty) {
  //         final orderId =
  //             pickedUpData['pickedUpOrders'][0]['order']['_id'];

  //         Navigator.pop(context);

  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(
  //         //     builder: (context) =>
  //         //         OrderDeliveredModal(orderId: orderId),
  //         //   ),
  //         // );
  //         return;
  //       }
  //     }

  //     Navigator.pop(context);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('No active orders found'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   } catch (e) {
  //     Navigator.pop(context);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error loading orders: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }


// Future<void> _handleOrderButtonTap(
//   BuildContext context,
//   NewOrderProvider orderProvider,
// ) async {
//   _stopAlertSound();
//   _hasShownModal = false;

//   print('========== CHECKING ORDERS ==========');
//   print('Pending orders count: ${orderProvider.pendingOrders.length}');
//   print('Rider ID: $riderid');

//   // FIRST: Check for pending orders from NewOrderProvider
//   if (orderProvider.pendingOrders.isNotEmpty) {
//     print('Found pending orders - showing OrderModal');
//     final latestOrder = orderProvider.pendingOrders.first;

//     final result = await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: false,
//       enableDrag: false,
//       builder: (context) => OrderModal(
//         riderId: riderid.toString(),
//         order: latestOrder,
//         onOrderAccepted: () {
//           _stopAlertSound();
//           _hasShownModal = false;
//           _previousPendingOrdersCount--;
//           Navigator.of(context).pop(true);
//         },
//         onOrderRejected: () {
//           _stopAlertSound();
//           _hasShownModal = false;
//           _previousPendingOrdersCount--;
//           Navigator.of(context).pop(false);
//         },
//       ),
//     );

//     if (result == true && mounted) {
//       await Future.wait([
//         Provider.of<DashboardProvider>(
//           context,
//           listen: false,
//         ).refreshDashboard(),
//         Provider.of<NewOrderProvider>(
//           context,
//           listen: false,
//         ).refreshOrders(riderid),
//       ]);

//       // After accepting order, navigate to ConfirmOrderModal
//       if (mounted) {
//         showModalBottomSheet(
//           context: context,
//           backgroundColor: Colors.transparent,
//           isScrollControlled: true,
//           isDismissible: false,
//           enableDrag: false,
//           builder: (context) => ConfirmOrderModal(
//             orderId: latestOrder.id,
//             riderId: riderid,
//           ),
//         );
//       }
//     } else if (result == false && mounted) {
//       await Future.wait([
//         Provider.of<DashboardProvider>(
//           context,
//           listen: false,
//         ).refreshDashboard(),
//         Provider.of<NewOrderProvider>(
//           context,
//           listen: false,
//         ).refreshOrders(riderid),
//       ]);
//     }

//     return;
//   }

//   // Show loading dialog while checking backend
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => const Center(
//       child: CircularProgressIndicator(),
//     ),
//   );

//   try {
//     final riderId = context.read<ProfileProvider>().rider?.id ?? riderid;
//     print('Checking backend for orders with riderId: $riderId');

//     // SECOND: Check for ACCEPTED ORDERS
//     print('Fetching accepted orders from: http://31.97.206.144:7021/api/rider/acceptedorders/$riderId');
    
//     final acceptedResponse = await http.get(
//       Uri.parse(
//         'http://31.97.206.144:7021/api/rider/acceptedorders/$riderId',
//       ),
//     );

//     print('Accepted orders response status: ${acceptedResponse.statusCode}');
//     print('Accepted orders response body: ${acceptedResponse.body}');

//     if (acceptedResponse.statusCode == 200) {
//       final acceptedData = json.decode(acceptedResponse.body);
      
//       // Check if acceptedOrder exists and is not null
//       if (acceptedData.containsKey('acceptedOrder')) {
//         print('acceptedOrder key exists');
        
//         final acceptedOrder = acceptedData['acceptedOrder'];
        
//         if (acceptedOrder != null) {
//           print('acceptedOrder is not null');
          
//           // The acceptedOrder object itself IS the order
//           if (acceptedOrder.containsKey('_id')) {
//             final orderId = acceptedOrder['_id'];
//             print('✅ Found accepted order with ID: $orderId');
            
//             // Dismiss loading dialog
//             if (mounted) Navigator.pop(context);

//             // Navigate to ConfirmOrderModal
//             if (mounted) {
//               showModalBottomSheet(
//                 context: context,
//                 backgroundColor: Colors.transparent,
//                 isScrollControlled: true,
//                 isDismissible: false,
//                 enableDrag: false,
//                 builder: (context) => ConfirmOrderModal(
//                   orderId: orderId,
//                   riderId: riderId,
//                 ),
//               );
//             }
//             return;
//           } else {
//             print('❌ acceptedOrder has no _id field');
//           }
//         } else {
//           print('❌ acceptedOrder is null');
//         }
//       } else {
//         print('❌ Response has no acceptedOrder key');
//       }
//     } else {
//       print('❌ Failed to fetch accepted orders: ${acceptedResponse.statusCode}');
//     }

//     // THIRD: Check for PICKED UP ORDERS
//     print('Fetching picked up orders from: http://31.97.206.144:7021/api/rider/pickeduporders/$riderId');
    
//     final pickedUpResponse = await http.get(
//       Uri.parse(
//         'http://31.97.206.144:7021/api/rider/pickeduporders/$riderId',
//       ),
//     );

//     print('Picked up orders response status: ${pickedUpResponse.statusCode}');
//     print('Picked up orders response body: ${pickedUpResponse.body}');

//     if (pickedUpResponse.statusCode == 200) {
//       final pickedUpData = json.decode(pickedUpResponse.body);

//       // Check if there are picked up orders
//       if (pickedUpData.containsKey('pickedUpOrders')) {
//         print('pickedUpOrders key exists');
        
//         final pickedUpOrders = pickedUpData['pickedUpOrders'];
        
//         if (pickedUpOrders != null && pickedUpOrders is List && pickedUpOrders.isNotEmpty) {
//           print('Found ${pickedUpOrders.length} picked up orders');
          
//           final firstOrder = pickedUpOrders[0];
          
//           // Check the structure of picked up orders
//           // It might be similar to accepted orders or nested differently
//           if (firstOrder.containsKey('_id')) {
//             // Direct order object
//             final orderId = firstOrder['_id'];
//             print('✅ Found picked up order with ID: $orderId');

//             // Dismiss loading dialog
//             if (mounted) Navigator.pop(context);

//             // Navigate to OrderDeliveredModal
//             // if (mounted) {
//             //   Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //       builder: (context) => OrderDeliveredModal(orderId: orderId),
//             //     ),
//             //   );
//             // }
//             return;
//           } else if (firstOrder.containsKey('order')) {
//             // Nested order object
//             final orderObject = firstOrder['order'];
//             if (orderObject != null && orderObject.containsKey('_id')) {
//               final orderId = orderObject['_id'];
//               print('✅ Found picked up order with ID: $orderId');

//               if (mounted) Navigator.pop(context);

//               // if (mounted) {
//               //   Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //       builder: (context) => OrderDeliveredModal(orderId: orderId),
//               //     ),
//               //   );
//               // }
//               return;
//             }
//           }
//         } else {
//           print('❌ pickedUpOrders is empty or not a list');
//         }
//       } else {
//         print('❌ Response has no pickedUpOrders key');
//       }
//     } else {
//       print('❌ Failed to fetch picked up orders: ${pickedUpResponse.statusCode}');
//     }

//     // No orders found in any state
//     print('❌ No orders found in any state');
//     if (mounted) Navigator.pop(context); // Dismiss loading dialog

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No active orders found'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   } catch (e) {
//     print('❌ Error checking orders: $e');
//     print('Stack trace: ${StackTrace.current}');
    
//     if (mounted) Navigator.pop(context); // Dismiss loading dialog

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading orders: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
  
//   print('========== ORDER CHECK COMPLETE ==========');
// }


// Future<void> _handleOrderButtonTap(
//   BuildContext context,
//   NewOrderProvider orderProvider,
// ) async {
//   _stopAlertSound();
//   _hasShownModal = false;

//   print('========== CHECKING ORDERS ==========');

//   /// ======================
//   /// FIRST: Pending Orders
//   /// ======================
//   if (orderProvider.pendingOrders.isNotEmpty) {
//     final latestOrder = orderProvider.pendingOrders.first;

//     final result = await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: false,
//       enableDrag: false,
//       builder: (context) => OrderModal(
//         riderId: riderid.toString(),
//         order: latestOrder,
//         onOrderAccepted: () {
//           _stopAlertSound();
//           _hasShownModal = false;
//           _previousPendingOrdersCount--;
//           Navigator.pop(context, true);
//         },
//         onOrderRejected: () {
//           _stopAlertSound();
//           _hasShownModal = false;
//           _previousPendingOrdersCount--;
//           Navigator.pop(context, false);
//         },
//       ),
//     );

//     if (result == true && mounted) {
//       await Future.wait([
//         context.read<DashboardProvider>().refreshDashboard(),
//         context.read<NewOrderProvider>().refreshOrders(riderid),
//       ]);

//       if (mounted) {
//         showModalBottomSheet(
//           context: context,
//           backgroundColor: Colors.transparent,
//           isScrollControlled: true,
//           isDismissible: false,
//           enableDrag: false,
//           builder: (_) => ConfirmOrderModal(
//             orderId: latestOrder.id,
//             riderId: riderid,
//           ),
//         );
//       }
//     }
//     return;
//   }

//   /// ======================
//   /// LOADING
//   /// ======================
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => const Center(child: CircularProgressIndicator()),
//   );

//   try {
//     final riderId = context.read<ProfileProvider>().rider?.id ?? riderid;

//     /// ======================
//     /// SECOND: ACCEPTED API
//     /// ======================
//     final acceptedResponse = await http.get(
//       Uri.parse(
//         'http://31.97.206.144:7021/api/rider/acceptedorders/$riderId',
//       ),
//     );

//     bool validAcceptedFound = false;

//     if (acceptedResponse.statusCode == 200) {
//       final acceptedData = json.decode(acceptedResponse.body);

//       // ✅ CASE 1: API returned only message
//       if (acceptedData.containsKey('message')) {
//         print('⏭️ No accepted orders (message response)');
//       }

//       // ✅ CASE 2: acceptedOrder exists
//       else if (acceptedData['acceptedOrder'] != null) {
//         final acceptedOrder = acceptedData['acceptedOrder'];

//         bool hasValidPharmacyResponses =
//             acceptedOrder['pharmacyResponses'] is List &&
//             acceptedOrder['pharmacyResponses'].isNotEmpty;

//         if (hasValidPharmacyResponses &&
//             acceptedOrder.containsKey('_id')) {

//           validAcceptedFound = true;

//           final orderId = acceptedOrder['_id'];
//           print('✅ Valid accepted order: $orderId');

//           if (mounted) Navigator.pop(context);

//           if (mounted) {
//             showModalBottomSheet(
//               context: context,
//               backgroundColor: Colors.transparent,
//               isScrollControlled: true,
//               isDismissible: false,
//               enableDrag: false,
//               builder: (_) => ConfirmOrderModal(
//                 orderId: orderId,
//                 riderId: riderId,
//               ),
//             );
//           }
//           return;
//         }
//       }
//     }

//     /// ======================
//     /// THIRD: PICKED UP API
//     /// ======================
//     if (!validAcceptedFound) {
//       print('➡️ Checking picked up orders...');

//       final pickedUpResponse = await http.get(
//         Uri.parse(
//           'http://31.97.206.144:7021/api/rider/pickeduporders/$riderId',
//         ),
//       );

//       if (pickedUpResponse.statusCode == 200) {
//         final pickedUpData = json.decode(pickedUpResponse.body);

//         if (pickedUpData['pickedUpOrders'] is List &&
//             pickedUpData['pickedUpOrders'].isNotEmpty) {

//           final firstOrder = pickedUpData['pickedUpOrders'][0];

//           String? orderId =
//               firstOrder['_id'] ?? firstOrder['order']?['_id'];

//           if (orderId != null) {
//             print('✅ Picked up order found: $orderId');

//             if (mounted) Navigator.pop(context);

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>
//                     OrderDeliveredModal(orderId: orderId.toString()),
//               ),
//             );
//             return;
//           }
//         }
//       }
//     }

//     /// ======================
//     /// NO ORDERS
//     /// ======================
//     if (mounted) Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('No active orders found'),
//         backgroundColor: Colors.orange,
//       ),
//     );

//   } catch (e) {
//     if (mounted) Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Error loading orders'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   print('========== ORDER CHECK COMPLETE ==========');
// }





Future<void> _handleOrderButtonTap(
  BuildContext context,
  NewOrderProvider orderProvider,
) async {
  _stopAlertSound();
  _hasShownModal = false;

  print('========== CHECKING ORDERS ==========');

  /// ======================
  /// FIRST: Pending Orders (New Orders)
  /// ======================
  if (orderProvider.pendingOrders.isNotEmpty) {
    final latestOrder = orderProvider.pendingOrders.first;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => OrderScreen(
        riderId: riderid.toString(),
        order: latestOrder,
        onOrderAccepted: () {
          _stopAlertSound();
          _hasShownModal = false;
          _previousPendingOrdersCount--;
          Navigator.pop(context, true);
        },
        onOrderRejected: () {
          _stopAlertSound();
          _hasShownModal = false;
          _previousPendingOrdersCount--;
          Navigator.pop(context, false);
        },
      ),
    );

    if (result == true && mounted) {
      await Future.wait([
        context.read<DashboardProvider>().refreshDashboard(),
        context.read<NewOrderProvider>().refreshOrders(riderid),
      ]);

      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (_) => ConfirmOrderModal(
            orderId: latestOrder.id,
            riderId: riderid,
          ),
        );
      }
    }
    return;
  }

  /// ======================
  /// LOADING
  /// ======================
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final riderId = context.read<ProfileProvider>().rider?.id ?? riderid;

    /// ======================
    /// SECOND: ACCEPTED ORDERS API
    /// ======================
    final acceptedResponse = await http.get(
      Uri.parse(
        'http://31.97.206.144:7021/api/rider/acceptedorders/$riderId',
      ),
    );

    bool orderFound = false;

    if (acceptedResponse.statusCode == 200) {
      final acceptedData = json.decode(acceptedResponse.body);

      // Check if acceptedOrder exists
      if (acceptedData['acceptedOrder'] != null && acceptedData['acceptedOrder'] is Map) {
        final acceptedOrder = acceptedData['acceptedOrder'];
        
        // Check if it has valid pharmacy responses
        bool hasValidPharmacyResponses =
            acceptedOrder['pharmacyResponses'] is List &&
            (acceptedOrder['pharmacyResponses'] as List).isNotEmpty;

        if (hasValidPharmacyResponses && acceptedOrder.containsKey('_id')) {
          orderFound = true;
          final orderId = acceptedOrder['_id'];
          print('✅ Valid accepted order found: $orderId');

          if (mounted) Navigator.pop(context);

          if (mounted) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              builder: (_) => ConfirmOrderModal(
                orderId: orderId,
                riderId: riderId,
              ),
            );
          }
          return;
        }
      }
    }

    /// ======================
    /// THIRD: PENDING ACCEPTED ORDERS API (Pharmacy Accepted)
    /// ======================
    if (!orderFound) {
      print('➡️ Checking pending accepted orders (pharmacy accepted)...');
      
      final pendingAcceptedResponse = await http.get(
        Uri.parse(
          'http://31.97.206.144:7021/api/rider/pendingacceptedorders/$riderId',
        ),
      );

      if (pendingAcceptedResponse.statusCode == 200) {
        final pendingAcceptedData = json.decode(pendingAcceptedResponse.body);
        
        // Check if there are newOrders with pharmacy accepted status
        if (pendingAcceptedData['success'] == true && 
            pendingAcceptedData['newOrders'] is List &&
            (pendingAcceptedData['newOrders'] as List).isNotEmpty) {
          
          final newOrders = pendingAcceptedData['newOrders'] as List;
          print('Found ${newOrders.length} pending accepted orders');
          
          // Take the first order
          final firstOrder = newOrders.first;
          
          if (firstOrder.containsKey('_id')) {
            orderFound = true;
            final orderId = firstOrder['_id'];
            print('✅ Pending accepted order found: $orderId');
            
            if (mounted) Navigator.pop(context);
            
            if (mounted) {
              // Navigate to PharmacyPickupScreen instead of ConfirmOrderModal
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PharmacyPickupScreen(
                    orderId: orderId,
                    riderId: riderId,
                  ),
                ),
              );
            }
            return;
          }
        } else {
          print('❌ No pending accepted orders found');
        }
      } else {
        print('❌ Failed to fetch pending accepted orders: ${pendingAcceptedResponse.statusCode}');
      }
    }

    /// ======================
    /// FOURTH: PICKED UP ORDERS API
    /// ======================
    if (!orderFound) {
      print('➡️ Checking picked up orders...');

      final pickedUpResponse = await http.get(
        Uri.parse(
          'http://31.97.206.144:7021/api/rider/pickeduporders/$riderId',
        ),
      );

      if (pickedUpResponse.statusCode == 200) {
        final pickedUpData = json.decode(pickedUpResponse.body);

        if (pickedUpData['pickedUpOrders'] is List &&
            (pickedUpData['pickedUpOrders'] as List).isNotEmpty) {

          final firstOrder = pickedUpData['pickedUpOrders'][0];

          String? orderId =
              firstOrder['_id'] ?? firstOrder['order']?['_id'];

          if (orderId != null) {
            orderFound = true;
            print('✅ Picked up order found: $orderId');

            if (mounted) Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    OrderDeliveredModal(orderId: orderId.toString()),
              ),
            );
            return;
          }
        }
      }
    }

    /// ======================
    /// NO ORDERS FOUND
    /// ======================
    if (!orderFound) {
      print('❌ No orders found in any state');
      if (mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active orders found'),
          backgroundColor: Colors.orange,
        ),
      );
    }

  } catch (e) {
    print('❌ Error in order check: $e');
    print('Stack trace: ${StackTrace.current}');
    
    if (mounted) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error loading orders: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }

  print('========== ORDER CHECK COMPLETE ==========');
}



  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _loadRiderData() async {
    final rider = await SharedPreferenceService.getRiderData();
    if (rider != null) {
      setState(() {
        riderName = rider.name;
        riderid = rider.id;
      });
      print('Loaded rider data: ${rider.name}, Status: ${rider.status}');
      print("ooooooooooooooooooooooooooooooooo$riderid");
    }
  }

  Future<void> _fetchChartData() async {
    final chartProvider = Provider.of<ChartProvider>(context, listen: false);
    await chartProvider.fetchChartData();
  }

  Future<void> _fetchDashboardData() async {
    final dashboardProvider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );
    await dashboardProvider.fetchDashboardData();
  }

  Future<void> _fetchNewOrders() async {
        final rider = await SharedPreferenceService.getRiderData();
    if (rider != null) {
      setState(() {
        riderName = rider.name;
        riderid = rider.id;
      });
      print('Loaded rider data: ${rider.name}, Status: ${rider.status}');
      print("ooooooooooooooooooooooooooooooooo$riderid");
    }
    final newOrderProvider = Provider.of<NewOrderProvider>(
      context,
      listen: false,
    );
    print("sfjsfjdfjds;fj;dkfjdsk;fjds;lfjdsklfjdsfjk sdfjkhjs2222222222222 $riderid");
    await newOrderProvider.fetchNewOrders(riderid);
  }

  void _showFilterDropdown(
    BuildContext context,
    DashboardProvider dashboardProvider,
  ) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height + 200,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        const PopupMenuItem<String>(value: 'today', child: Text('Today')),
        const PopupMenuItem<String>(
          value: 'thisweek',
          child: Text('This Week'),
        ),
        const PopupMenuItem<String>(
          value: 'one month',
          child: Text('One Month'),
        ),
        const PopupMenuItem<String>(value: '3 Months', child: Text('3 Months')),
        const PopupMenuItem<String>(value: '6 Months', child: Text('6 Months')),
        const PopupMenuItem<String>(
          value: '12 Months',
          child: Text('12 Months'),
        ),
      ],
    ).then((value) async {
      if (value != null) {
        setState(() {
          dashboardProvider.updateFilter(value);
        });

        final chartProvider = Provider.of<ChartProvider>(
          context,
          listen: false,
        );
        await chartProvider.fetchChartData(filter: value);
      }
    });
  }

  void _navigateToOrders(
    OrderStatusType filterType, [
    String? specificOrderId,
  ]) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         DetailScreen(initialFilter: filterType, orderId: specificOrderId),
    //   ),
    // );
  }

  void _navigateToSpecificOrder(String orderId) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         DetailScreen(orderId: orderId, initialFilter: OrderStatusType.all),
    //   ),
    // );
  }

  OrderStatusType _getStatusTypeFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatusType.pending;
      case 'accepted':
      case 'rider assigned':
        return OrderStatusType.accepted;
      case 'picked up':
        return OrderStatusType.pickedUp;
      case 'delivered':
      case 'completed':
        return OrderStatusType.delivered;
      case 'cancelled':
        return OrderStatusType.cancelled;
      default:
        return OrderStatusType.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _getProfileImage(profileProvider),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        title: Consumer2<ProfileProvider, LocationProvider>(
          builder: (context, profileProvider, locationProvider, child) {
            final displayName = profileProvider.rider?.name ?? riderName;
            final displayid = profileProvider.rider?.id ?? '';

            final addressParts = (locationProvider?.address ?? '')
                .split(',')
                .map((e) => e.trim())
                .toList();
            final primaryAddress = addressParts.isNotEmpty
                ? addressParts[0]
                : 'Unknown location';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $displayName',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationSearchScreen(userId: displayid.toString()),
                      ),
                    );

                    if (result == true && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Updating  location...'),
                            ],
                          ),
                          backgroundColor: Color(0xFF6366F1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.all(16),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF6366F1),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: locationProvider?.isLoading == true
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            : locationProvider?.hasError == true
                            ? Text(
                                'Tap to set location',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6366F1),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Text(
                                primaryAddress,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          StatusToggleButton(),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: const Color.fromARGB(255, 194, 193, 193),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              Consumer<NewOrderProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.pendingOrders.isNotEmpty) {
                    return Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer3<DashboardProvider, NewOrderProvider, ProfileProvider>(
        builder: (context, dashboardProvider, orderProvider, profileProvider, child) {
          if (_isInitialized) {
            final currentCount = orderProvider.pendingOrders.length;
            if (currentCount != _previousPendingOrdersCount ||
                (currentCount > 0 && !_hasShownModal)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkAndShowPendingOrderModal();
              });
            }
          }

          if (dashboardProvider.isLoading && !dashboardProvider.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                dashboardProvider.refreshDashboard(),
                orderProvider.refreshOrders(riderid),
                profileProvider.initializeProfile(),
              ]);
              // After refresh, check for new orders
              _checkAndShowPendingOrderModal();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (dashboardProvider.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        dashboardProvider.errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCardWithNavigation(
                          title: 'Today Orders',
                          value: dashboardProvider.todayOrders.toString(),
                          color: Colors.white,
                          textColor: Colors.black,
                          navigationFilter: OrderStatusType.all,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCardWithNavigation(
                          title: 'Pending',
                          value: orderProvider.pendingOrders.length.toString(),
                          color: Colors.orange[50]!,
                          textColor: Colors.orange,
                          navigationFilter: OrderStatusType.pending,
                          specificOrderId:
                              orderProvider.pendingOrders.isNotEmpty
                              ? orderProvider.pendingOrders.first.id
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCardWithNavigation(
                          title: 'Cancelled',
                          value: dashboardProvider.cancelledOrders.toString(),
                          color: Colors.red[50]!,
                          textColor: Colors.red,
                          navigationFilter: OrderStatusType.cancelled,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCardWithNavigation(
                          title: 'Completed',
                          value: dashboardProvider.completedOrders.toString(),
                          color: Colors.green[50]!,
                          textColor: Colors.green,
                          navigationFilter: OrderStatusType.completed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: const Color(0xFFF6FAFD),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check Orders',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profileProvider.rider?.name ?? riderName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Tap to view active, accepted or delivered orders',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _handleOrderButtonTap(context, orderProvider),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFF5A35EB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.double_arrow_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    height: 400,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Earnings',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    _showFilterDropdown(
                                      context,
                                      dashboardProvider,
                                    );
                                  },
                                  child: Container(
                                    width: 94,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            dashboardProvider
                                                    .filterUsed
                                                    .isNotEmpty
                                                ? _formatFilterText(
                                                    dashboardProvider
                                                        .filterUsed,
                                                  )
                                                : 'This Week',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Expanded(child: CustomLineChart()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCardWithNavigation({
    required String title,
    required String value,
    required Color color,
    required Color textColor,
    required OrderStatusType navigationFilter,
    String? specificOrderId,
  }) {
    return GestureDetector(
      onTap: () => _navigateToOrders(navigationFilter, specificOrderId),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getProfileImage(ProfileProvider profileProvider) {
    if (profileProvider.rider?.profileImage != null &&
        profileProvider.rider!.profileImage.isNotEmpty) {
      return NetworkImage(profileProvider.rider!.profileImage);
    } else {
      return const AssetImage('');
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFilterText(String filter) {
    switch (filter.toLowerCase()) {
      case 'today':
        return 'Today';
      case 'thisweek':
        return 'This Week';
      case 'thismonth':
        return 'This Month';
      case '6months':
        return '6 Months';
      default:
        return filter;
    }
  }
}