
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/home/home_screen.dart';
import 'package:medical_delivery_app/home/profile_screen.dart';
import 'package:medical_delivery_app/providers/navbar_provider.dart';
// import 'package:medical_delivery_app/view/home/history_screen.dart';
// import 'package:medical_delivery_app/view/home/home_screen.dart';
// import 'package:medical_delivery_app/view/home/profile_screen.dart';
// import 'package:medical_delivery_app/view/home/wallet_screen.dart';
import 'package:provider/provider.dart';

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomnavbarProvider = Provider.of<BottomNavbarProvider>(context);

    final pages = [
      HomeScreen(),
            ProfileScreen(),

      HomeScreen(),
      ProfileScreen()
    ];

    return Scaffold(
      body: pages[bottomnavbarProvider.currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: bottomnavbarProvider.currentIndex,
          onTap: (index) => bottomnavbarProvider.setIndex(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF6C63FF), // Purple color matching your image
          unselectedItemColor: Colors.grey[500],
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet_outlined),
              activeIcon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}