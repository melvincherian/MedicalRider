import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/firebase/firebase_service.dart';
import 'package:medical_delivery_app/firebase/local_notification_service.dart';
import 'package:medical_delivery_app/providers/add_bankdetails_provider.dart';
import 'package:medical_delivery_app/providers/chart_provider.dart';
import 'package:medical_delivery_app/providers/chat_provider%20copy.dart';
import 'package:medical_delivery_app/providers/create_query_provider.dart';
import 'package:medical_delivery_app/providers/dashboard_provider.dart';
import 'package:medical_delivery_app/providers/document_provider.dart';
import 'package:medical_delivery_app/providers/forgot_password_provider.dart';
import 'package:medical_delivery_app/providers/history_provider.dart';
// import 'package:medical_delivery_app/providers/accept_pickup_provider.dart';
// import 'package:medical_delivery_app/providers/add_bankdetails_provider.dart';
// import 'package:medical_delivery_app/providers/chart_provider.dart';
// import 'package:medical_delivery_app/providers/chat_provider.dart';
// import 'package:medical_delivery_app/providers/create_query_provider.dart';
// import 'package:medical_delivery_app/providers/dashboard_provider.dart';
// import 'package:medical_delivery_app/providers/document_provider.dart';
// import 'package:medical_delivery_app/providers/forgot_password_provider.dart';
// import 'package:medical_delivery_app/providers/history_provider.dart';
import 'package:medical_delivery_app/providers/login_provider.dart';
import 'package:medical_delivery_app/providers/navbar_provider.dart';
import 'package:medical_delivery_app/providers/new_order_provider.dart';
import 'package:medical_delivery_app/providers/notification_provider.dart';
import 'package:medical_delivery_app/providers/pending_accepted_order_provider.dart';
import 'package:medical_delivery_app/providers/profile_provider.dart';
import 'package:medical_delivery_app/providers/rider_order_provider.dart';
import 'package:medical_delivery_app/providers/signup_provider.dart';
import 'package:medical_delivery_app/providers/status_provider.dart';
import 'package:medical_delivery_app/providers/users_location_provider.dart';
import 'package:medical_delivery_app/providers/wallet_provider.dart';
import 'package:medical_delivery_app/providers/withdraw_wallet_provider.dart';
import 'package:medical_delivery_app/view/auth/splash_screen.dart';
// import 'package:medical_delivery_app/providers/navbar_provider.dart';
// import 'package:medical_delivery_app/providers/new_order_provider.dart';
// import 'package:medical_delivery_app/providers/notification_provider.dart';
// import 'package:medical_delivery_app/providers/order_delivered_provider.dart';
// import 'package:medical_delivery_app/providers/profile_provider.dart';
// import 'package:medical_delivery_app/providers/signup_provider.dart';
// import 'package:medical_delivery_app/providers/static_order_provider.dart';
// import 'package:medical_delivery_app/providers/status_provider.dart';
// import 'package:medical_delivery_app/providers/users_location_provider.dart';
// import 'package:medical_delivery_app/providers/wallet_provider.dart';
// import 'package:medical_delivery_app/providers/withdraw_wallet_provider.dart';
// import 'package:medical_delivery_app/view/auth/splash_screen.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FCMService().initialize();

  await LocalNotificationService.init();

  print('✅ Firebase & FCM initialized successfully');

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavbarProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => NewOrderProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => AddBankDetailsProvider()),
        ChangeNotifierProvider(create: (context) => WithdrawWalletProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        // ChangeNotifierProvider(create: (context) => AcceptPickupProvider()),
        // ChangeNotifierProvider(create: (context) => OrderDeliveredProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => DocumentProvider()),
        ChangeNotifierProvider(create: (context) => StatusProvider()),
        ChangeNotifierProvider(create: (context) => ChartProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => CreateQueryProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => RiderOrderProvider()),
        ChangeNotifierProvider(
          create: (context) => PendingAcceptedOrderProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'CLYNIX RIDER',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
